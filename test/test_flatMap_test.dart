
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('flatMap num array', () {

    var data = [1, 2, 3];

    var result = DartStream.of(data)
        .flatMap((num) {
            return DartStream.of([num, num]);
        })
        .toList();

    expect(result.length, equals( 6));
    expect(result[0], equals( 1));
    expect(result[1], equals( 1));
    expect(result[2], equals( 2));
    expect(result[3], equals( 2));
    expect(result[4], equals( 3));
    expect(result[5], equals( 3));

    // assert original data is untouched
    expect(data.length, equals( 3));
    expect(data[0], equals( 1));
    expect(data[1], equals( 2));
    expect(data[2], equals( 3));

});
test('flatMap object array', () {

    var data = [Obj1(1), Obj1(2), Obj1(3), Obj1(4)];

    var result = DartStream.of(data)
        .flatMap((obj) {
            return DartStream.of([Obj2(0, obj.a), Obj2(0, obj.a)]);
        })
        .toList();

    expect(result.length, equals( 8));
    expect(result[0].b, equals( 1));
    expect(result[1].b, equals( 1));
    expect(result[2].b, equals( 2));
    expect(result[3].b, equals( 2));
    expect(result[4].b, equals( 3));
    expect(result[5].b, equals( 3));
    expect(result[6].b, equals( 4));
    expect(result[7].b, equals( 4));

    // assert original data is untouched
    expect(data.length, equals( 4));
    expect(data[0].a, equals( 1));
    expect(data[1].a, equals( 2));
    expect(data[2].a, equals( 3));
    expect(data[3].a, equals( 4));

});
test('flatMap empty array', () {

    var result = DartStream.of([])
        .flatMap((num) {
            return DartStream.of([num, num]);
        })
        .toList();

    expect(result.length, equals( 0));

});
test('flatMap no array return', () {

    var result = DartStream.of([1, 2, 3])
        .flatMap((num) {
            return DartStream.one(num.toString());
        })
        .toList();

    expect(result.length, equals( 3));
    expect(result[0], equals( "1"));
    expect(result[1], equals( "2"));
    expect(result[2], equals( "3"));

});
test('flatMap returns object', () {

    var result = DartStream.of([1])
        .flatMap((num) {
            return DartStream.one(Obj2(num, num));
        })
        .toList();

    expect(result.length, equals( 2));
    expect(result[0], equals( 1));
    expect(result[1], equals( 1));

});



}
