part of '../dart_stream.dart';

class _OpFlagInfo {
  final int bitPosition;
  final int set;
  final int clear;
  final int preserve;

  const _OpFlagInfo(this.bitPosition, this.set, this.clear, this.preserve);

  bool isKnown(int flags) {
    return (flags & preserve) == set;
  }

  bool isCleared(int flags) {
    return (flags & preserve) == clear;
  }

  bool isPreserved(int flags) {
    return (flags & preserve) == preserve;
  }

}

class _OpFlag {
  static const _OpFlagInfo DISTINCT = _OpFlagInfo(0, 1, 2, 3);
  static const _OpFlagInfo SORTED = _OpFlagInfo(2, 4, 8, 12);
  static const _OpFlagInfo SHORT_CIRCUIT = _OpFlagInfo(4, 16, 32, 48);
  static const _OpFlagInfo SIZED = _OpFlagInfo(6, 64, 128, 192);

  static int combineOpFlags(int newFlag, int prevFlag) {
    if (newFlag == 0) return prevFlag;
    var clearOldBit = ~((FLAG_MASK_IS & newFlag) << 1) | ((FLAG_MASK_NOT & newFlag) >> 1);
    return (prevFlag & clearOldBit) | newFlag;
  }

  static const int FLAG_MASK_IS = 85; //  0b01010101
  static const int FLAG_MASK_NOT = 170; //0b10101010
  static const int IS_DISTINCT = 1; //0b1
  static const int NOT_DISTINCT = 2; //0b10
  static const int IS_SORTED = 4; //0b100
  static const int NOT_SORTED = 8; //0b1000
  static const int IS_SHORT_CIRCUIT = 16; //0b10000
  // static const int NOT_SHORT_CIRCUIT = 32; //0b100000
  static const int IS_SIZED = 64; //0b1000000
  static const int NOT_SIZED = 128; //0b10000000


}
