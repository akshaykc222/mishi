import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mishi/mishi/domain/repositories/connection_repository.dart';

class ConnectionRepositoryImpl extends ConnectionRepository {
  final InternetConnectionChecker connectionChecker;

  ConnectionRepositoryImpl(this.connectionChecker);

  @override
  Stream<InternetConnectionStatus> checkConnectionInfo() {
    return connectionChecker.onStatusChange;
  }
}
