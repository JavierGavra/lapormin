import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:lapormin/injection.dart';

class Provider {
  static List<BlocProvider> providers() {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
      ),
    ];
  }
}
