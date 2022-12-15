import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class ConnectionRepository {
  Stream<InternetConnectionStatus> checkConnectionInfo();
}
