part of 'home_admin_bloc.dart';

sealed class HomeAdminEvent extends Equatable {
  const HomeAdminEvent();

  @override
  List<Object?> get props => [];
}

final class FetchHomeAdminReports extends HomeAdminEvent {
  const FetchHomeAdminReports();
}
