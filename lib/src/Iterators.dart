part of '../dart_stream.dart';

abstract class BaseIterator<T> {
  static const int DISTINCT = 0x00000001;
  static const int ORDERED = 0x00000010;

  static const int SORTED = 0x00000004;
  static const int SIZED = 0x00000040;
  static const int IMMUTABLE = 0x00000400;

  T next();

  bool done = false;
  bool toNil = false;

  int characteristics() {
    return 0;
  }

  int getExactSizeIfKnown() {
    return (characteristics() & SIZED) == 0 ? -1 : estimateSize();
  }

  estimateSize() {
    return -1;
  }

  forEachRemaining(Consumer<T> action) {
    while (!done) {
      T now = next();
      if (!toNil) action(now);
      else break;
    }
  }
}

class ArrayIterator<T> extends BaseIterator<T> {
  List<T> data;
  int origin;
  int fence;

  ArrayIterator(List<T> array) {
    this.data = array ?? [];
    this.origin = 0;
    this.fence = this.data.length;
  }

  T next() {
    if (this.origin >= this.fence) {
      done = true;
      toNil = true;
      return null;
    }
    try {
      return this.data[this.origin];
    } finally {
      this.origin++;
      if (this.origin >= this.fence) done = true;
    }
  }

  @override
  int characteristics() {
    return BaseIterator.SIZED;
  }

  @override
  estimateSize() {
    return data?.length??-1;
  }
}

class IteratorIterator<T> extends BaseIterator<T> {
  Iterator<T> iterator;

  IteratorIterator(Iterator<T> iterator) {
    this.iterator = iterator;
  }

  T next() {
    if (this.iterator.moveNext()) {
      return iterator.current;
    } else {
      done = true;
      toNil = true;
      return null;
    }
  }
}

class ValueIterator<T> extends BaseIterator<T> {
  T value;

  ValueIterator(this.value) {
    this.done = false;
  }

  T next() {
    if (!this.done) {
      this.done = true;
      return this.value;
    }
    toNil = true;
    return null;
  }

  @override
  int characteristics() {
    return BaseIterator.SIZED;
  }

  @override
  estimateSize() {
    return 1;
  }
}

class EmptyIterator<T> extends BaseIterator<T> {
  T value;

  EmptyIterator() {
    this.done = true;
  }

  T next() {
    toNil = true;
    return null;
  }
  @override
  int characteristics() {
    return BaseIterator.SIZED;
  }

  @override
  estimateSize() {
    return 0;
  }
}
