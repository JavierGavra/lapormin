import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/core/widgets/progress_bar/segmented_progress_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/location_step.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/title_category_step.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _pageController = PageController();

  final _titleController = TextEditingController();
  ReportCategory _reportCategory = ReportCategory.infrastructure;

  int currentStep = 1;

  late final List<Widget> _steps;

  void _nextStep() {
    debugPrint("${_titleController.text}, $_reportCategory");
    setState(() {
      currentStep++;
    });
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _prevStep(BuildContext context) {
    setState(() {
      currentStep--;
    });
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    _steps = [
      TitleCategoryStep(
        titleController: _titleController,
        onCategoryChanged: (value) => _reportCategory = value,
      ),
      LocationStep(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _prevStep(context);
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(color),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: _steps.length,
                  itemBuilder: (context, index) {
                    return _steps[index];
                  },
                ),
              ),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 12, top: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                AppBackButton(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Langkah $currentStep dari 4",
                      style: AppTextStyle.s12(color: color.secondary),
                    ),
                    Text(
                      "Buat Laporan",
                      style: AppTextStyle.s16(
                        fontWeight: FontWeight.w600,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SegmentedProgressBar(segment: _steps.length, progress: currentStep),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: AppFilledButton(
        text: currentStep == 4 ? "Buat Laporan" : "Lanjutkan",
        onPressed: () => _nextStep(),
        suffixIcon: currentStep == 4 ? null : Icons.arrow_forward_rounded,
        iconSize: 16,
      ),
    );
  }
}
