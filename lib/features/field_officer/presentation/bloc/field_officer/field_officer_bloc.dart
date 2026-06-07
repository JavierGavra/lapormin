import 'package:flutter_bloc/flutter_bloc.dart';
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

    try {
      final officers = await getFieldOfficers.execute();

      emit(
        state.copyWith(status: FieldOfficerStatus.success, officers: officers),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FieldOfficerStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
