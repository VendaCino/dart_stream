part of '../dart_stream.dart';

class _StreamOpFlagType {
  final int bitPosition;
  final int set;
  final int clear;
  final int preserve;

  const _StreamOpFlagType(this.bitPosition, this.set, this.clear, this.preserve);

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

class _StreamOpFlag {
  static const _StreamOpFlagType DISTINCT = _StreamOpFlagType(0, 1, 2, 3);
  static const _StreamOpFlagType SORTED = _StreamOpFlagType(2, 4, 8, 12);
  static const _StreamOpFlagType ORDERED = _StreamOpFlagType(4, 16, 32, 48);
  static const _StreamOpFlagType SIZED = _StreamOpFlagType(6, 64, 128, 192);
  static const _StreamOpFlagType SHORT_CIRCUIT = _StreamOpFlagType(24, 16777216, 33554432, 50331648);

  static int getMask(int flags) {
    return (flags == 0)
        ? FLAG_MASK
        : ~(flags | ((FLAG_MASK_IS & flags) << 1) | ((FLAG_MASK_NOT & flags) >> 1));
  }

  static int combineOpFlags(int prevCombOpFlags, int newStreamOrOpFlags) {
    return (prevCombOpFlags & _StreamOpFlag.getMask(newStreamOrOpFlags)) | newStreamOrOpFlags;
  }

  static const int FLAG_MASK = 50331903; //0b11000000000000000011111111
  static const int FLAG_MASK_IS = 85; //0b1010101
  static const int FLAG_MASK_NOT = 170; //0b10101010
  static const int INITIAL_OPS_VALUE = 255; //0b11111111
  static const int IS_DISTINCT = 1; //0b1
  static const int NOT_DISTINCT = 2; //0b10
  static const int IS_SORTED = 4; //0b100
  static const int NOT_SORTED = 8; //0b1000
  static const int IS_ORDERED = 16; //0b10000
  static const int NOT_ORDERED = 32; //0b100000
  static const int IS_SIZED = 64; //0b1000000
  static const int NOT_SIZED = 128; //0b10000000
  static const int IS_SHORT_CIRCUIT = 16777216; //0b1000000000000000000000000

}
