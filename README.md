Dart Stream
=====================
A collection util inspired by java streams
<br>

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/VendaCino/dart_stream/main/LICENSE)


### Show Case
<img alt="loading" src="https://raw.githubusercontent.com/VendaCino/dart_stream/main/doc/assets/example.gif" >

### Example

```dart
import 'package:dart_stream/dart_stream.dart';

void main() {
  print(DartStream.of([1, 2, 3]).map((t) => t - 1).allMatch((t) => t > 0));
  print([1, 2, 3].toStream().map((t) => t - 1).toList());
}
```

### Todo List
- [ ] : shuffle
- [ ] : reverse
- [ ] : takeWhile
- [ ] : dropWhile

### License

The MIT License, see [LICENSE](https://github.com/VendaCino/dart_stream/raw/main/LICENSE).