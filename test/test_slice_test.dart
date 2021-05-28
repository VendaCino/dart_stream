
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('slice', () {

    var result = DartStream.of([1, 2, 3, 4])
        .slice(1, 3)
        .toList();

    expect(result.length, equals( 2));
    expect(result[0], equals( 2));
    expect(result[1], equals( 3));

});
test('slice empty', () {

    var result = DartStream.of([])
        .slice(1, 2)
        .toList();

    expect(result.length, equals( 0));

});
test('slice high', () {

    var result = DartStream.of([1, 2, 3, 4])
        .slice(10, 10)
        .toList();

    expect(result.length, equals( 0));

});

}
