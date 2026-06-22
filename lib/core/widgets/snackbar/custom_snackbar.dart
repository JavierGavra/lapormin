import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

enum SnackBarType { success, failure }

void showSnackBar(
  BuildContext context,
  String title, {
  SnackBarType type = SnackBarType.success,
}) {
  _AnimatedSnackbarOverlay.show(context, title: title, type: type);
}

// ─── Overlay Controller ──────────────────────────────────────────────────────

class _AnimatedSnackbarOverlay {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String title,
    required SnackBarType type,
  }) {
    // Dismiss yang sebelumnya jika masih tampil
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _SnackbarWidget(
        title: title,
        type: type,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

// ─── Widget ──────────────────────────────────────────────────────────────────

class _SnackbarWidget extends StatefulWidget {
  final String title;
  final SnackBarType type;
  final VoidCallback onDismiss;

  const _SnackbarWidget({
    required this.title,
    required this.type,
    required this.onDismiss,
  });

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  static const Duration _animIn = Duration(milliseconds: 350);
  static const Duration _animOut = Duration(milliseconds: 250);
  static const Duration _displayDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _animIn);

    // Slide dari bawah ke atas
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Fade in
    _fadeAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Jalankan animasi masuk → tahan → animasi keluar → dismiss
    _controller.forward().then((_) async {
      await Future.delayed(_displayDuration);
      if (mounted) await _dismiss();
    });
  }

  Future<void> _dismiss() async {
    _controller.duration = _animOut;
    await _controller.reverse();
    if (mounted) widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final backgroundColor = switch (widget.type) {
      SnackBarType.success => color.primary,
      SnackBarType.failure => color.error,
    };

    final textColor = switch (widget.type) {
      SnackBarType.success => color.onPrimary,
      SnackBarType.failure => color.onError,
    };

    final icon = switch (widget.type) {
      SnackBarType.success => Icons.check_circle_rounded,
      SnackBarType.failure => Icons.error_rounded,
    };

    return Positioned(
      bottom:
          MediaQuery.of(context).viewInsets.bottom +
          MediaQuery.of(context).padding.bottom +
          16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                // Swipe ke bawah untuk dismiss
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 200) {
                  _dismiss();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ).copyWith(right: 8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  spacing: 12,
                  children: [
                    Icon(icon, size: 20, color: textColor),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyle.s14(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Tombol close
                    IconButton(
                      onPressed: _dismiss,
                      icon: Icon(
                        Icons.close_rounded,
                        // size: 18,
                        color: textColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
