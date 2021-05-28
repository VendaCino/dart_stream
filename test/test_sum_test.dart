
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('sum', () {

    var result = DartStream.of([1, 2, 3, 4]).sum();
    expect(result, equals( 10));

});
test('sum empty', () {

    var result = DartStream.of<int>([]).sum();
    expect(result, equals( 0));

});
test( 'sum via path',() {
    var result = DartStream.of([Obj1(1), Obj1(2), Obj1(3)]).map((t) => t.a).sum();
    expect(result, equals( 6));
});

}
