import 'dart:convert';
import 'dart:io';

import 'package:gd/platform_path.dart';
import 'package:gd/services/app_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("AppService", () {
    final app = AppService.instance;
    late final Directory appData;
    late final File config;

    // Deletes any previous content within application's data directory to start anew.
    setUpAll(() async {
      appData = await getAppData();
      await appData.delete(recursive: true);

      config = File("${appData.path}${sep}config.json");
    });

    // Deletes application's data directory to release storage space.
    // You SHOULD (un)comment this block when writing tests, as any data written / read from files will be lost after
    // tests execution.
    // /*
    tearDownAll(() async {
      await appData.delete(recursive: true);
    });
    // */

    test(".load() on the first run should create application's data directory.", () async {
      await app.load();
      final exists = await app.appData.exists();

      expect(exists, true);
    });

    test(".load() after the first run should have created default 'config.json'.", () async {
      final exists = await config.exists();

      expect(exists, true);
      final data = await config.readAsString();
      final json = jsonDecode(data);

      // expect(json["version"], "1.0.0");
      expect(json["is_first_run"], true);
      expect(json["issues"], -1);
    });

    test(".setFirstRun() should disable isFirstRun state and update 'config.json'.", () async {
      await app.setFirstRun();

      expect(app.config.isFirstRun, false);
      final data = await config.readAsString();
      final json = jsonDecode(data);

      expect(json["is_first_run"], false);
    });

    test(".setIssues(4) should update issues state and update 'config.json'.", () async {
      await app.setIssues(4);

      expect(app.config.issues, 4);
      final data = await config.readAsString();
      final json = jsonDecode(data);

      expect(json["issues"], 4);
    });

    test(".getProgram('Git') while program is not defined should return <null>.", () async {
      final path = app.getProgram("Git");

      expect(path, null);
    });

    test(".defineProgram('Git', '/home/git/') should set program, path and update 'config.json'.", () async {
      await app.defineProgram("Git", "/home/git");

      final path = app.getProgram("Git");

      expect(path, "/home/git");
      final data = await config.readAsString();
      final json = jsonDecode(data);
      final programs = Map<String, String>.from(json["programs"]);

      expect(programs["git"], "/home/git");
    });

    test(".removeProgram('Git') while program is set should remove entry, return true and update 'config.json'.",
        () async {
      final isRemoved = await app.removeProgram("Git");

      expect(isRemoved, true);
      final path = app.getProgram("Git");

      expect(path, null);
      final data = await config.readAsString();
      final json = jsonDecode(data);
      final programs = Map<String, String>.from(json["programs"]);

      expect(programs["git"], null);
    });

    test(".removeProgram('Git') while program is not set should return false.", () async {
      final isRemoved = await app.removeProgram("Git");

      expect(isRemoved, false);
    });

    test(".load() subsequent call return previous state from 'config.json'.", () async {
      await app.load();

      expect(app.config.isFirstRun, false);
      expect(app.config.issues, 4);
    });
  });
}
