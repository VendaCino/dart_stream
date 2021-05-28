
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('distinct', () {

    var result = DartStream.of([1, 3, 3, 1])
        .distinct()
        .toList();

    expect(result.length, equals( 2));
    expect(result[0], equals( 1));
    expect(result[1], equals( 3));

});
test( 'distinct empty',() {

    var result = DartStream.of([])
        .distinct()
        .toList();

    expect(result.length, equals( 0));

});

}
