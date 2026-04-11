import 'package:isar/isar.dart';

/// A utility to generate deterministic Isar IDs from string UUIDs.
/// FastHash is recommended by Isar for primary keys derived from strings.
class HashHelper {
  /// Hashes a string string to a 64-bit integer fast hash.
  static int fastHash(String string) {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
