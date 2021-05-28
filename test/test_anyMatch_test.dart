import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';

class _Temp {
    int a;
    int b;

    _Temp(this.a, this.b);
}

void main() {
    test('anyMatch true', () {
        var result = DartStream.of([1, 2, 3, 4]).anyMatch((num) {
            return num == 4;
        });
        expect(result, equals(true));
    });
    test('anyMatch false', () {
        var result = DartStream.of([1, 2, 3, 4]).anyMatch((num) {
            return num == 5;
        });
        expect(result, equals(false));
    });
    test('anyMatch empty', () {
        var result = DartStream.of([]).anyMatch((num) {
            return num > 1;
        });
        expect(result, equals(false));
    });
    test('anyMatch regexp true', () {
        var result = DartStream.of(["a1", "a2", "a3"]).anyMatch((e) => e.startsWith("a"));
        expect(result, equals(true));
    });
    test('anyMatch regexp false', () {
        var result = DartStream.of(["b1", "b2", "b3"]).anyMatch((e) => e.startsWith("a"));
        expect(result, equals(false));
    });
    test('anyMatch regexp empty', () {
        var result = DartStream.of([]).anyMatch((e) => e.startsWith("a"));
        expect(result, equals(false));
    });

    test('anyMatch sample true', () {
        var result = DartStream.of([_Temp(1, 5), _Temp(2, 5), _Temp(3, 5)]).anyMatch((e) => e.b == 5);
        expect(result, equals(true));
    });
    test('anyMatch sample false', () {
        var result = DartStream.of([_Temp(1, 5), _Temp(2, 5), _Temp(3, 5)]).anyMatch((e) => e.a == 4);
        expect(result, equals(false));
    });
    test('anyMatch sample empty', () {
        var result = DartStream.of([]).anyMatch((_) => false);
        expect(result, equals(false));
    });


}
