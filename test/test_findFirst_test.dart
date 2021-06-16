
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('findFirst', () {

    var result = DartStream.of([1, 2, 3, 4])
        .filter((num) {
            return num % 2 == 0;
        })
        .findFirst();

    expect(result, equals( 2));

});
test('findFirst empty', () {

    var result = DartStream.of([]).findFirst();
    expect(result, equals( null));

});
test( 'findFirst object',() {

    var result = DartStream.one(Obj2(1, 2)).findFirst();
    expect(result!.a, equals( 1));

});

}
