/// Data of [Semantic Versioning] with [major], [minor] and [patch] numbers.
///
/// Use [SemVer.parse] to create a [SemVer] using a [String] with format "X.Y.Z".
class SemVer {
  static final regexp = RegExp(r"[0-9]+\.[0-9]+\.[0-9]+");

  const SemVer(this.major, [this.minor = 0, this.patch = 0]);

  final int major;
  final int minor;
  final int patch;

  @override
  String toString() {
    return "$major.$minor.$patch";
  }

  factory SemVer.parse(final String version) {
    int? first = version.indexOf(".");
    int? second = version.indexOf(".", first + 1);

    if (first == -1) {
      first = null;
    }
    if (second == -1) {
      second = null;
    }
    final major = version.substring(0, first);

    if (first == null) {
      return SemVer(int.parse(major), 0, 0);
    }
    final minor = version.substring(first + 1, second);

    if (second == null) {
      return SemVer(int.parse(major), int.parse(minor), 0);
    }
    final patch = version.substring(second + 1);

    return SemVer(int.parse(major), int.parse(minor), int.parse(patch));
  }

  bool operator >=(SemVer other) {
    final deltaMajor = major - other.major;
    final deltaMinor = minor - other.minor;
    final deltaPatch = patch - other.patch;

    if (deltaMajor < 0) {
      return false;
    } else if (deltaMajor > 0) {
      return true;
    }
    if (deltaMinor < 0) {
      return false;
    } else if (deltaMinor > 0) {
      return true;
    }
    if (deltaPatch < 0) {
      return false;
    }
    return true;
  }

  bool operator <(SemVer other) {
    return !(this >= other);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemVer &&
          runtimeType == other.runtimeType &&
          major == other.major &&
          minor == other.minor &&
          patch == other.patch;

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;
}
