import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/presentation/bloc/create_report/create_report_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/create_report_header.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/evidences_step.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/location_step.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/summary_description_step.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/title_category_step.dart';
import 'package:latlong2/latlong.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  ReportCategory _reportCategory = ReportCategory.infrastructure;
  LatLng? _position;
  String? _address;

  late final List<Widget> _steps;

  void _listener(BuildContext context, CreateReportState state) {
    if (state.status == CreateReportStatus.next) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (state.status == CreateReportStatus.previous) {
      if (state.currentStep == 0) {
        Navigator.pop(context);
        return;
      }

      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (state.status == CreateReportStatus.success) {
      showSnackBar(context, "Laporan berhasil dibuat!");
    } else if (state.status == CreateReportStatus.failure) {
      showSnackBar(
        context,
        "Sepertinya ada yang salah.",
        type: SnackBarType.failure,
      );
    }
  }

  CreateReportEvent? _onStep1() {
    if (!_formKey.currentState!.validate()) return null;
    return CreateReportStep1Submitted(
      title: _titleController.text,
      category: _reportCategory,
    );
  }

  CreateReportEvent? _onStep2() {
    if (_position == null || _address == null) {
      showSnackBar(context, "Lokasi harus diisi!", type: SnackBarType.failure);
      return null;
    }
    return CreateReportStep2Submitted(position: _position!, address: _address!);
  }

  void _nextStep(BuildContext context, int currentStep) {
    if (currentStep < _steps.length) {
      final CreateReportEvent? event = switch (currentStep) {
        1 => _onStep1(),
        2 => _onStep2(),
        3 => null, // TODO: implement step 3 event
        4 => null, // TODO: implement step 4 event
        _ => null,
      };

      if (event != null) context.read<CreateReportBloc>().add(event);
    } else {
      //
    }
  }

  void _prevStep(BuildContext context) {
    context.read<CreateReportBloc>().add(CreateReportPreviousStep());
  }

  @override
  void initState() {
    super.initState();
    _steps = [
      TitleCategoryStep(
        formKey: _formKey,
        titleController: _titleController,
        initialCategory: _reportCategory,
        onCategoryChanged: (category) => _reportCategory = category,
      ),
      LocationStep(
        onLocationChanged: (position, address) {
          _position = position;
          _address = address;
        },
      ),
      EvidencesStep(),
      SummaryDescriptionStep(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateReportBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<CreateReportBloc, CreateReportState>(
          listener: _listener,
          child: Builder(
            builder: (context) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  _prevStep(context);
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      CreateReportHeader(totalSteps: _steps.length),
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
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return BlocBuilder<CreateReportBloc, CreateReportState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: state.isLoading
              ? AppFilledButton.loading()
              : AppFilledButton(
                  text: state.currentStep == 4 ? "Buat Laporan" : "Lanjutkan",
                  onPressed: () => _nextStep(context, state.currentStep),
                  suffixIcon: state.currentStep == 4
                      ? null
                      : Icons.arrow_forward_rounded,
                  iconSize: 16,
                ),
        );
      },
    );
  }
}
