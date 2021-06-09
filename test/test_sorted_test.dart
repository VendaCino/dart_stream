
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('sorted', () {

    var result = DartStream.of([4, 1, 3, 2])
        .sorted()
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

});
test('sorted (comparator)', () {

    var result = DartStream.of([4, 1, 3, 2])
        .sorted((num1, num2) {
            if (num1 == num2) return 0;
            return num1 < num2 ? 1 : -1;
        })
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 4));
    expect(result[1], equals( 3));
    expect(result[2], equals( 2));
    expect(result[3], equals( 1));

});
test('sorted empty', () {

    var result = DartStream.of([])
        .sorted()
        .toList();

    expect(result.length, equals( 0));

});
test( 'sorted by path',() {

    var data = [Obj1(4), Obj1(1), Obj1(3), Obj1(2)];
    var result = DartStream.of(data)
        .sorted((e1,e2)=>e1.a-e2.a)
        .toList();

    expect(result.length, equals( 4));
    expect(result[0].a, equals( 1));
    expect(result[1].a, equals( 2));
    expect(result[2].a, equals( 3));
    expect(result[3].a, equals( 4));

    // assert input data is untouched
    expect(data.length, equals( 4));
    expect(data[0].a, equals( 4));
    expect(data[1].a, equals( 1));
    expect(data[2].a, equals( 3));
    expect(data[3].a, equals( 2));

});
test('sorted twice', () {

    var result = DartStream.of([4, 1, 3, 2])
        .sorted((e1,e2)=>e2-e1)
        .sorted()
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

});
}
