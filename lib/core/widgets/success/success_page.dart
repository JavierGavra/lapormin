import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/text_style/app_text_style.dart';
import '../button/app_filled_button.dart';

class SuccessPage extends StatefulWidget {
  final String title;
  final String description;
  final void Function()? onBack;

  const SuccessPage({
    super.key,
    this.onBack,
    required this.title,
    required this.description,
  });

  @override
  State<SuccessPage> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessPage> {
  final ValueNotifier<int> _countdown = ValueNotifier<int>(4);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown.value > 1) {
        _countdown.value--;
      } else {
        timer.cancel();
        widget.onBack?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // RepaintBoundary(
                  //   child: SvgPicture.asset(
                  //     'assets/images/backgrounds/success_background.svg',
                  //     width: double.infinity,
                  //   ),
                  // ),
                  Image.asset(
                    'assets/images/backgrounds/success_background.png',
                    width: double.infinity,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RepaintBoundary(
                        child: LottieBuilder.asset(
                          'assets/animations/success_check.json',
                          width: 156,
                          height: 156,
                          animate: true,
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Plus Jakarta Sans",
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.description, style: AppTextStyle.s14()),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ValueListenableBuilder<int>(
                valueListenable: _countdown,
                builder: (context, value, child) {
                  return AppFilledButton(
                    text: "Kembali Dalam $value Detik",
                    onPressed: () {
                      _timer?.cancel();
                      widget.onBack?.call();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
