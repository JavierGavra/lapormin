import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/my_reports/my_reports_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/admin_reports/admin_reports_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/field_officer_reports/field_officer_reports_bloc.dart';
import 'package:lapormin/injection.dart';

class Provider {
  static List<BlocProvider> providers() {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
      ),
      BlocProvider<PublicReportsBloc>(
        create: (context) =>
            sl<PublicReportsBloc>()..add(const FetchPublicReports()),
      ),
      BlocProvider<MyReportsBloc>(create: (context) => sl<MyReportsBloc>()),
      BlocProvider<AdminReportsBloc>(
        create: (context) =>
            sl<AdminReportsBloc>()..add(const FetchAdminReports()),
      ),
      BlocProvider<FieldOfficerReportsBloc>(
        create: (context) =>
            sl<FieldOfficerReportsBloc>()
              ..add(const FetchFieldOfficerReports()),
      ),
    ];
  }
}
