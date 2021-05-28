
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('forEach', () {

    var data = [];

    DartStream.of([1, 2, 3, 4])
        .forEach((num) {
            data.add(num);
        });

    expect(data.length, equals( 4));
    expect(data[0], equals( 1));
    expect(data[1], equals( 2));
    expect(data[2], equals( 3));
    expect(data[3], equals( 4));

});
test('forEach empty', () {

    var called = false;

    DartStream.of([])
        .forEach((t) {
            called = true;
        });

    expect(called, equals( false));

});

}
