
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('map num array', () {

    var data = [1, 2, 3, 4];

    var result = DartStream.of(data)
        .map((num) {
            return "obj" + num.toString();
        })
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 'obj1'));
    expect(result[1], equals( 'obj2'));
    expect(result[2], equals( 'obj3'));
    expect(result[3], equals( 'obj4'));

    // assert original data is untouched
    expect(data.length, equals( 4));
    expect(data[0], equals( 1));
    expect(data[1], equals( 2));
    expect(data[2], equals( 3));
    expect(data[3], equals( 4));

});
test('map object array', () {

    var data = [Obj1(1), Obj1(2), Obj1(3), Obj1(4)];

    var result = DartStream.of(data)
        .map((obj) {
            return Obj2(obj.a, obj.a);
        })
        .toList();

    expect(result.length, equals( 4));
    expect(result[0].b, equals( 1));
    expect(result[1].b, equals( 2));
    expect(result[2].b, equals( 3));
    expect(result[3].b, equals( 4));

    // assert original data is untouched
    expect(data.length, equals( 4));
    expect(data[0].a, equals( 1));
    expect(data[1].a, equals( 2));
    expect(data[2].a, equals( 3));
    expect(data[3].a, equals( 4));

});
test('map empty array', () {

    var result = DartStream.of([])
        .map((num) {
            return "obj" + num;
        })
        .toList();

    expect(result.length, equals( 0));

});
test('map with null', () {

    var data = [1, null, null, 4];

    var result = DartStream.of(data)
        .map((val) {
            return "map_" + (val==null?"null":val.toString());
        })
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 'map_1'));
    expect(result[1], equals( 'map_null'));
    expect(result[2], equals( 'map_null'));
    expect(result[3], equals( 'map_4'));

    // assert original data is untouched
    expect(data.length, equals( 4));
    expect(data[0], equals( 1));
    expect(data[1], equals( null));
    expect(data[2], equals( null));
    expect(data[3], equals( 4));

});
test('map via path (depth 1)', () {

    var data = [Obj1(1), Obj1(2), Obj1(3), Obj1(4)];

    var result = DartStream.of(data)
        .map((e)=>e.a)
        .toList();

    expect(result.length, equals( 4));
    expect(result[0], equals( 1));
    expect(result[1], equals( 2));
    expect(result[2], equals( 3));
    expect(result[3], equals( 4));

    // assert original data is untouched
    expect(data.length, equals( 4));
    expect(data[0].a, equals( 1));
    expect(data[1].a, equals( 2));
    expect(data[2].a, equals( 3));
    expect(data[3].a, equals( 4));

});

}
