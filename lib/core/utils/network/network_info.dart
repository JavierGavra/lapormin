import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkInfo {
  const NetworkInfo(this.connectionChecker);

  final InternetConnectionChecker connectionChecker;

  Future<bool> get isConnected => connectionChecker.hasConnection;
}
