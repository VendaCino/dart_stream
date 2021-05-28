
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('max', () {

    var result = DartStream.of([1, 2, 3, 4]).max();
    expect(result, equals( 4));

});
test('max empty', () {

    var result = DartStream.of([]).max();
    expect(result, equals( null));

});
test('max (comparator)', () {

    var result = DartStream.of([1, 2, 3, 4])
        .max((a, b) {
            if (a == b) return 0;
            if (a > b) return -1;
            return 1;
        });
    expect(result, equals( 1));

});


}
