import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { create } from "https://deno.land/x/djwt@v2.8/mod.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const FIREBASE_PROJECT_ID = Deno.env.get('FIREBASE_PROJECT_ID')
const FIREBASE_CLIENT_EMAIL = Deno.env.get('FIREBASE_CLIENT_EMAIL')
const FIREBASE_PRIVATE_KEY = Deno.env.get('FIREBASE_PRIVATE_KEY')?.replace(/\\n/g, '\n')

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

const supabase = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!)

// HELPER: Mengonversi String PEM menjadi CryptoKey untuk djwt
async function importPrivateKey(pem: string): Promise<CryptoKey> {
  const pemHeader = "-----BEGIN PRIVATE KEY-----"
  const pemFooter = "-----END PRIVATE KEY-----"
  const pemContents = pem.substring(pemHeader.length, pem.length - pemFooter.length - 1).replace(/\n/g, "")
  const binaryDerString = atob(pemContents)
  const binaryDer = new Uint8Array(binaryDerString.length)
  for (let i = 0; i < binaryDerString.length; i++) {
    binaryDer[i] = binaryDerString.charCodeAt(i)
  }
  return await crypto.subtle.importKey(
    "pkcs8",
    binaryDer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    true,
    ["sign"]
  )
}

serve(async (req) => {
  try {
    const payload = await req.json()
    const notificationRecord = payload.record 

    // 1. Dapatkan FCM Token
    const { data: userProfile, error: profileError } = await supabase
      .from('device_tokens') 
      .select('token')
      .eq('user_id', notificationRecord.user_id)
      .single()

    if (profileError || !userProfile?.token) {
      console.error('FCM Token tidak ditemukan untuk user:', notificationRecord.user_id)
      return new Response(JSON.stringify({ error: 'Token tidak ditemukan' }), { status: 400 })
    }

    const fcmToken = userProfile.token

    const NOTIFICATION_MAP: Record<string, { title: string, channel: string }> = {
      'ganti_status': { title: 'Pergantian Status', channel: 'status_laporan_channel' },
      'laporan_baru': { title: 'Ada Laporan Baru', channel: 'general_channel' },
      'penugasan': { title: 'Panggilan Tugas', channel: 'status_laporan_channel' },
      'hasil_laporan': { title: 'Surat Cinta dari Petugas', channel: 'status_laporan_channel' },
      'laporan_terdekat': { title: 'Ada Laporan Di Sekitarmu', channel: 'general_channel' }
    }

    const config = NOTIFICATION_MAP[notificationRecord.type] || { 
      title: 'Pemberitahuan Baru', 
      channel: 'general_channel' 
    }

    // 2. Siapkan Payload FCM (Ubah semua value menjadi string & masukkan tipe_notif)
    const rawPayload = notificationRecord.payload || {}
    const safeDataPayload: Record<string, string> = {
      tipe_notif: notificationRecord.type // Kunci penting untuk Flutter!
    }
    
    // Looping untuk memastikan angka/boolean menjadi string
    for (const key in rawPayload) {
      safeDataPayload[key] = String(rawPayload[key])
    }

    // 3. Buat JWT menggunakan CryptoKey
    const privateKey = await importPrivateKey(FIREBASE_PRIVATE_KEY!)
    const jwt = await create(
      { alg: "RS256", typ: "JWT" },
      {
        iss: FIREBASE_CLIENT_EMAIL,
        scope: "https://www.googleapis.com/auth/firebase.messaging",
        aud: "https://oauth2.googleapis.com/token",
        exp: Math.floor(Date.now() / 1000) + 3600,
        iat: Math.floor(Date.now() / 1000),
      },
      privateKey // <-- Menggunakan CryptoKey, bukan string mentah
    )

    const tokenRes = await fetch("https://oauth2.googleapis.com/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
    })
    const { access_token } = await tokenRes.json()

    // 4. Kirim ke Firebase v1
    const fcmRes = await fetch(
      `https://fcm.googleapis.com/v1/projects/${FIREBASE_PROJECT_ID}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${access_token}`,
        },
        body: JSON.stringify({
          message: {
            token: fcmToken,
            notification: {
              title: config.title,
              body: notificationRecord.content,
            },
            android: {
              notification: {
                channel_id: config.channel,
              },
            },
            data: safeDataPayload // <-- Menggunakan payload yang sudah disanitasi
          },
        }),
      }
    )

    // Deteksi jika Firebase menolak (Token kadaluarsa, dsb)
    if (!fcmRes.ok) {
        const errorData = await fcmRes.json()
        console.error("Gagal mengirim ke FCM:", errorData)
        return new Response(JSON.stringify({ error: 'FCM Rejection', details: errorData }), { status: 500 })
    }

    return new Response(JSON.stringify({ success: true }), { headers: { "Content-Type": "application/json" } })
  } catch (error) {
    console.error("Fatal Error:", error)
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})