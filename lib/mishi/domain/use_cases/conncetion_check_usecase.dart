import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mishi/core/usecase.dart';
import 'package:mishi/mishi/domain/repositories/connection_repository.dart';

class ConnectionCheckUseCase
    extends StreamUseCase<InternetConnectionStatus, NoParams> {
  final ConnectionRepository repository;

  ConnectionCheckUseCase(this.repository);

  @override
  Stream<InternetConnectionStatus> call(NoParams params) {
    return repository.checkConnectionInfo();
  }
}
