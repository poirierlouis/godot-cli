import 'dart:io';

import 'package:gd/services/app_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:mocktail/mocktail.dart';

class MockProgramService extends Mock implements ProgramService {}

class MockAppService extends Mock implements AppService {}

class MockProcess extends Mock implements Process {}
