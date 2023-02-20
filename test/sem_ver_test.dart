import 'package:gd/sem_ver.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("SemVer", () {
    test(".toString() while instantiated with SemVer(1, 2, 3) should return '1.2.3'.", () {
      final version = SemVer(1, 2, 3);

      expect("$version", "1.2.3");
    });

    group(".operator >=(other)", () {
      final a = SemVer(1);

      test("1.0.0 >= 1.0.0 should return true.", () {
        expect(a >= SemVer(1), true);
      });

      test("1.0.0 >= 1.0.1 should return false.", () {
        expect(a >= SemVer(1, 0, 1), false);
      });

      test("1.0.0 >= 1.1.0 should return false.", () {
        expect(a >= SemVer(1, 1), false);
      });

      test("1.0.0 >= 2.0.0 should return false.", () {
        expect(a >= SemVer(2), false);
      });

      test("1.0.0 >= 0.9.9 should return true.", () {
        expect(a >= SemVer(0, 9, 9), true);
      });

      test("1.0.0 >= 0.8.1 should return true.", () {
        expect(a >= SemVer(0, 8, 1), true);
      });

      test("1.0.0 >= 0.0.0 should return true.", () {
        expect(a >= SemVer(0, 0, 0), true);
      });
    });

    group(".operator <(other)", () {
      final a = SemVer(1);

      test("1.0.0 < 1.0.0 should return false.", () {
        expect(a < SemVer(1), false);
      });

      test("1.0.0 < 1.0.1 should return true.", () {
        expect(a < SemVer(1, 0, 1), true);
      });

      test("1.0.0 < 1.1.0 should return true.", () {
        expect(a < SemVer(1, 1, 0), true);
      });

      test("1.0.0 < 2.0.0 should return true.", () {
        expect(a < SemVer(2, 0, 0), true);
      });

      test("1.0.0 < 0.9.9 should return false.", () {
        expect(a < SemVer(0, 9, 9), false);
      });

      test("1.0.0 < 0.8.1 should return false.", () {
        expect(a < SemVer(0, 8, 1), false);
      });

      test("1.0.0 < 0.0.1 should return false.", () {
        expect(a < SemVer(0, 0, 1), false);
      });
    });

    group(".operator ==(other)", () {
      final a = SemVer(1);

      test("1.0.0 == 1.0.0 should return true.", () {
        expect(a == SemVer(1), true);
      });

      test("1.0.0 == 1.1.0 should return false.", () {
        expect(a == SemVer(1, 1), false);
      });

      test("1.0.0 == 1.0.1 should return false.", () {
        expect(a == SemVer(1, 0, 1), false);
      });

      test("1.0.0 == 2.0.0 should return false.", () {
        expect(a == SemVer(2), false);
      });
    });

    group(".parse()", () {
      test(".parse('') should throw FormatException.", () {
        expect(
          () => SemVer.parse(""),
          throwsA(const TypeMatcher<FormatException>()),
        );
      });

      test(".parse('A') should throw FormatException.", () {
        expect(
          () => SemVer.parse("A"),
          throwsA(const TypeMatcher<FormatException>()),
        );
      });

      test(".parse('1') should return SemVer(1, 0, 0).", () {
        final version = SemVer.parse("1");

        expect(version, SemVer(1));
      });

      test(".parse('2.5') should return SemVer(2, 5, 0).", () {
        final version = SemVer.parse("2.5");

        expect(version, SemVer(2, 5));
      });

      test(".parse('0.98.5') should return SemVer(0, 98, 5).", () {
        final version = SemVer.parse("0.98.5");

        expect(version, SemVer(0, 98, 5));
      });
    });
  });
}
