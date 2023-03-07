import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:path/path.dart' as p;

class GCCService extends DetectService {
  static final GCCService instance = GCCService._();

  GCCService._();

  @override
  String get executable {
    final path = app.getProgram("GCC");

    if (path == null) {
      return "gcc";
    }
    return p.join(path, "gcc");
  }

  @override
  final SemVer? requiredVersion = SemVer(7);
}
