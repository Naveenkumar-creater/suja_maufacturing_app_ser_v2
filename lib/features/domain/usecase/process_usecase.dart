import 'package:suja/features/domain/entity/process_entity.dart';
import 'package:suja/features/domain/repository/process_repository.dart';

class ProcessUsecase {
  final ProcessRepository processRepository;
  ProcessUsecase(this.processRepository);

  Future<ProcessEntity> execute(
    String token,
  ) async {
    return processRepository.getProcessList(token);
  }
}
