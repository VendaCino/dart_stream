
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('min', () {

    var result = DartStream.of([1, 2, 3, 4]).min();
    expect(result, equals( 1));

});
test('min empty', () {

    var result = DartStream.of([]).min();
    expect(result, equals( null));

});
test('min (comparator)', () {

    var result = DartStream.of([1, 2, 3, 4])
        .min((a, b) {
            if (a == b) return 0;
            if (a > b) return -1;
            return 1;
        });

    expect(result, equals( 4));

});

}
