import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// 📍 1. Aturan Pintu Masuk (CORS) biar Kurir Flutter diizinkan
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // 📍 2. Tangani surat "Cek Ombak" (OPTIONS request) dari Flutter
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  // 📍 3. Pakai Try-Catch biar kalau gagal nggak Error 500
  try {
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Tangkap data dari body
    const { name, phone, password } = await req.json()

    // Proses daftar akun
    const { data, error } = await supabaseAdmin.auth.admin.createUser({
      phone: phone,
      password: password,
      phone_confirm: true,
      user_metadata: {
        username: name,
        no_telp: phone,
        role: 'field_officer'
      }
    })

    // Jika Supabase nolak (misal nomor udah terdaftar), lempar ke CATCH
    if (error) throw error

    // Laporan Sukses
    return new Response(JSON.stringify({ data }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })

  } catch (error) {
    // 📍 4. Jatuh dengan elegan (Error 400), lalu kirim pesannya ke UI Flutter
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})
