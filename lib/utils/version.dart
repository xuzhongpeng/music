class Version {
  static final RegExp _versionRegex =
      new RegExp(r"^([\d.]+)(-([0-9A-Za-z\-.]+))?(\+([0-9A-Za-z\-.]+))?$");
  static final RegExp _buildRegex = new RegExp(r"^[0-9A-Za-z\-.]+$");
  static final RegExp _preReleaseRegex = new RegExp(r"^[0-9A-Za-z\-]+$");

  final int major;

  final int minor;

  final int patch;

  final String build;

  final List<String> _preRelease;

  List<String> get preRelease => new List<String>.from(_preRelease);

  Version(this.major, this.minor, this.patch,
      {List<String> preRelease: const <String>[], this.build: ""})
      : _preRelease = preRelease {
    if (this.major == null) throw new ArgumentError("major must not be null");
    if (this.minor == null) throw new ArgumentError("minor must not be null");
    if (this.patch == null) throw new ArgumentError("patch must not be null");
    if (this._preRelease == null)
      throw new ArgumentError("preRelease must not be null");
    for (int i = 0; i < _preRelease.length; i++) {
      if (_preRelease[i] == null ||
          _preRelease[i].toString().trim().length == 0)
        throw new ArgumentError(
            "preRelease semgents must not be null or empty");
      // Just in case
      _preRelease[i] = _preRelease[i].toString();
      if (!_preReleaseRegex.hasMatch(_preRelease[i]))
        throw new FormatException(
            "preRelease segments must only contain [0-9A-Za-z-]");
    }
    if (this.build == null) throw new ArgumentError("build must not be null");
    if (this.build.length > 0 && !_buildRegex.hasMatch(this.build)) {
      throw new FormatException("build must only contain [0-9A-Za-z-.]");
    }

    if (major < 0 || minor < 0 || patch < 0) {
      throw new ArgumentError("Version numbers must be greater than 0");
    }
    if (major == 0 && minor == 0 && patch == 0) {
      throw new ArgumentError(
          "At least one component of the version number must be greater than 0");
    }
  }
  bool operator >(dynamic o) => o is Version && _compare(this, o) > 0;
  static Version parse(String versionString) {
    if (versionString?.trim()?.isEmpty ?? true)
      throw new FormatException("Cannot parse empty string into version");

    if (!_versionRegex.hasMatch(versionString))
      throw new FormatException("Not a properly formatted version string");

    final Match m = _versionRegex.firstMatch(versionString);
    final String version = m.group(1);

    int major, minor, patch;
    final List<String> parts = version.split(".");
    major = int.parse(parts[0]);
    if (parts.length > 1) {
      minor = int.parse(parts[1]);
      if (parts.length > 2) {
        patch = int.parse(parts[2]);
      }
    }
    final String preReleaseString = m.group(3) ?? "";
    List<String> preReleaseList = <String>[];
    if (preReleaseString.trim().length > 0)
      preReleaseList = preReleaseString.split(".");

    final String build = m.group(5) ?? "";

    return new Version(major ?? 0, minor ?? 0, patch ?? 0,
        build: build, preRelease: preReleaseList);
  }

  static int _compare(Version a, Version b) {
    if (a.major > b.major) return 1;
    if (a.major < b.major) return -1;

    if (a.minor > b.minor) return 1;
    if (a.minor < b.minor) return -1;

    if (a.patch > b.patch) return 1;
    if (a.patch < b.patch) return -1;

    if (a.preRelease.isEmpty) {
      if (b.preRelease.isEmpty) {
        return 0;
      } else {
        return 1;
      }
    } else if (b.preRelease.isEmpty) {
      return -1;
    } else {
      int preReleaseMax = a.preRelease.length;
      if (b.preRelease.length > a.preRelease.length) {
        preReleaseMax = b.preRelease.length;
      }

      for (int i = 0; i < preReleaseMax; i++) {
        if (b.preRelease.length <= i) {
          return 1;
        } else if (a.preRelease.length <= i) {
          return -1;
        }

        if (a.preRelease[i] == b.preRelease[i]) continue;

        final bool aNumeric = _isNumeric(a.preRelease[i]);
        final bool bNumeric = _isNumeric(b.preRelease[i]);

        if (aNumeric && bNumeric) {
          final double aNumber = double.parse(a.preRelease[i]);
          final double bNumber = double.parse(b.preRelease[i]);
          if (aNumber > bNumber) {
            return 1;
          } else {
            return -1;
          }
        } else if (bNumeric) {
          return 1;
        } else if (aNumeric) {
          return -1;
        } else {
          return a.preRelease[i].compareTo(b.preRelease[i]);
        }
      }
    }
    return 0;
  }

  static bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
