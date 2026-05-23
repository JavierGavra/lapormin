import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import '../../../../../core/utils/text_style/app_text_style.dart';
import 'create_report_step_header.dart';

class EvidencesStep extends StatelessWidget {
  const EvidencesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          const CreateReportStepHeader(
            title: "Tambahkan bukti\n(Foto/Video)",
            description: "Buktikan bahwa laporanmu valid.",
          ),
          _buildUploadButton(color, context),
          _buildPreview(color),
          const SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildUploadButton(ColorScheme color, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showSnackBar(context, "Comming Soon!");
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  color: color.onPrimary,
                  size: 32,
                ),
                Text(
                  "Ambil Foto/Video",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s14(
                    color: color.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(ColorScheme color) {
    const int crossAxisCount = 3;
    const double gap = 8;
    const double containerPadding = 16;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(12),
        padding: EdgeInsets.zero,
        color: color.outline,
        dashPattern: [5, 5],
        strokeWidth: 1.5,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(containerPadding),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              "Terpilih : 4/5",
              style: AppTextStyle.s14(
                color: color.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
                    crossAxisCount;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: itemWidth,
                      height: itemWidth,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/cards/infrastruktur.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // Tombol X di pojok kanan atas
                          // Positioned(
                          //   // top: -8,
                          //   // right: -8,
                          //   child: IconButton.filled(
                          //     onPressed: () {},
                          //     icon: Icon(
                          //       Icons.close_rounded,
                          //       size: 16,
                          //       color: color.tertiary,
                          //     ),
                          //     padding: EdgeInsets.zero,
                          //     constraints: const BoxConstraints(
                          //       minWidth: 28,
                          //       minHeight: 28,
                          //     ),
                          //     style: IconButton.styleFrom(
                          //       shape: const CircleBorder(),
                          //       backgroundColor: color.surface,
                          //       padding: EdgeInsets.zero,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
