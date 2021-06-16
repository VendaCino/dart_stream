part of '../dart_stream.dart';
abstract class BaseIterator<T> {
  static const int DISTINCT = 0x00000001;
  static const int ORDERED = 0x00000010;

  static const int SORTED = 0x00000004;
  static const int SIZED = 0x00000040;
  static const int IMMUTABLE = 0x00000400;

  T next();

  bool done = false;

  int characteristics() {
    return 0;
  }

  int getExactSizeIfKnown() {
    return (characteristics() & SIZED) == 0 ? -1 : estimateSize();
  }

  int estimateSize() {
    return -1;
  }

  forEachRemaining(JConsumer<T> action) {
    while (!done) {
      T now = next();
      action(now);
    }
  }
}

class _ArrayIterator<T> extends BaseIterator<T> {
  late List<T> data;
  late int origin;
  late int fence;

  _ArrayIterator(List<T> array) {
    this.data = array;
    this.origin = 0;
    this.fence = this.data.length;
    this.done = this.origin >= this.fence;
  }

  T next() {
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
  int estimateSize() {
    return data.length;
  }
}

class _IteratorIterator<T> extends BaseIterator<T> {

  Iterator<T> iterator;
  late T value;

  _IteratorIterator(this.iterator) {
    this.done = !this.iterator.moveNext();
    if(!this.done) value = iterator.current;
  }

  T next() {
    var value = this.value;
    this.done = !this.iterator.moveNext();
    if(!this.done) this.value = iterator.current;
    return value;
  }
}

class _ValueIterator<T> extends BaseIterator<T> {
  T value;

  _ValueIterator(this.value) {
    this.done = false;
  }

  T next() {
    this.done = true;
    return this.value;
  }

  @override
  int characteristics() {
    return BaseIterator.SIZED;
  }

  @override
  int estimateSize() {
    return 1;
  }
}

class _EmptyIterator<T> extends BaseIterator<T> {

  _EmptyIterator() {
    this.done = true;
  }

  T next() {
    throw "No Value";
  }
  @override
  int characteristics() {
    return BaseIterator.SIZED;
  }

  @override
  int estimateSize() {
    return 0;
  }
}
