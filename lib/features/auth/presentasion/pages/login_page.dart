import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: color.primary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                        color: color.shadow.withValues(alpha: 0.1),
                      ),
                      BoxShadow(
                        blurRadius: 15,
                        spreadRadius: -3,
                        offset: const Offset(0, 10),
                        color: color.shadow.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 22,
                    height: 1.272,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Plus Jakarta Sans",
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Laportkan hal di sekitar anda pada mimin!",
                  style: TextStyle(fontSize: 14, height: 1.428),
                ),
                const SizedBox(height: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Nomor Telepon",
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.333,
                          fontWeight: FontWeight.w600,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "8xx-xxxx-xxxx",
                        filled: true,
                        fillColor: color.surfaceContainerLowest,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: color.secondary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.error),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.333,
                          fontWeight: FontWeight.w600,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        filled: true,
                        fillColor: color.surfaceContainerLowest,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: color.secondary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.visibility_off_outlined),
                          color: color.outline,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: color.error),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Lupa kata sandi?"),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Masuk"),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text.rich(
                      TextSpan(
                        text: "Belum punya akun? ",
                        children: [
                          TextSpan(
                            text: "Daftar",
                            style: TextStyle(
                              color: color.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        style: const TextStyle(fontSize: 14, height: 1.428),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
