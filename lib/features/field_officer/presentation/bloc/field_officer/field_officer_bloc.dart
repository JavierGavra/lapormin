import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import '../../../domain/use_cases/get_field_officers.dart';
import 'field_officer_event.dart';
import 'field_officer_state.dart';

class FieldOfficerBloc extends Bloc<FieldOfficerEvent, FieldOfficerState> {
  final GetFieldOfficers getFieldOfficers;

  FieldOfficerBloc({required this.getFieldOfficers})
    : super(const FieldOfficerState()) {
    on<FetchFieldOfficers>(_onFetchFieldOfficers);
  }

  Future<void> _onFetchFieldOfficers(
    FetchFieldOfficers event,
    Emitter<FieldOfficerState> emit,
  ) async {
    emit(state.copyWith(status: FieldOfficerStatus.loading));

    final officers = await getFieldOfficers(NoParams());

    officers.fold(
      (failure) => emit(
        state.copyWith(
          status: FieldOfficerStatus.failure,
          errorMessage: failure.toString(),
        ),
      ),
      (officers) => emit(
        state.copyWith(status: FieldOfficerStatus.success, officers: officers),
      ),
    );
  }
}
