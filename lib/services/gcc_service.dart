import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';

class GCCService extends DetectService {
  static final GCCService instance = GCCService._();

  GCCService._();

  @override
  final String executable = "gcc";

  @override
  final SemVer? requiredVersion = SemVer(7);
}
