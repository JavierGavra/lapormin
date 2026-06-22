import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/field_officer/domain/use_cases/add_field_officer.dart';
import 'add_field_officer_event.dart';
import 'add_field_officer_state.dart';

class AddFieldOfficerBloc
    extends Bloc<AddFieldOfficerEvent, AddFieldOfficerState> {
  final AddFieldOfficer addFieldOfficerUseCase;

  AddFieldOfficerBloc({required this.addFieldOfficerUseCase})
    : super(AddFieldOfficerInitial()) {
    on<SubmitFieldOfficer>((event, emit) async {
      emit(AddFieldOfficerLoading());

      String formattedPhone = event.phone.trim();

      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+62${formattedPhone.substring(1)}';
      } else if (!formattedPhone.startsWith('+')) {
        formattedPhone = '+$formattedPhone';
      }

      final randomDigits = Random().nextInt(10000).toString().padLeft(4, '0');
      final generatedPassword = 'LaporMin!$randomDigits';

      final result = await addFieldOfficerUseCase(
        AddFieldOfficerParams(
          name: event.name,
          phone: formattedPhone,
          password: generatedPassword,
        ),
      );

      result.fold(
        (failure) {
          emit(
            AddFieldOfficerFailure(
              failure.message ?? 'Gagal menambahkan petugas',
            ),
          );
        },
        (_) {
          emit(AddFieldOfficerSuccess(generatedPassword));
        },
      );
    });
  }
}
