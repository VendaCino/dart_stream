//
//import 'package:flutter_test/flutter_test.dart';
//import 'package:dart_stream/dart_stream.dart';
//import './test_define.dart';
//void main(){
//test('partitionBy predicate', () {
//
//    var data = [
//        {firstName: "Peter", lastName: "Parker"},
//        {firstName: "Sandra", lastName: "Parker"},
//        {firstName: "John", lastName: "Doe"}
//    ];
//
//    var result = DartStream.of(data)
//        .partitionBy((person) {
//            return person.lastName === 'Parker';
//        });
//
//    expect(result[true].length, equals( 2));
//    expect(result[false].length, equals( 1));
//    expect(result[true][0], equals( data[0]));
//    expect(result[true][1], equals( data[1]));
//    expect(result[false][0], equals( data[2]));
//
//});
//test('partitionBy sample object', () {
//
//    var data = [
//        {firstName: "Peter", lastName: "Parker"},
//        {firstName: "Sandra", lastName: "Parker"},
//        {firstName: "John", lastName: "Doe"}
//    ];
//
//    var result = DartStream.of(data)
//        .partitionBy({lastName: 'Parker'});
//
//    expect(result[true].length, equals( 2));
//    expect(result[false].length, equals( 1));
//    expect(result[true][0], equals( data[0]));
//    expect(result[true][1], equals( data[1]));
//    expect(result[false][0], equals( data[2]));
//
//});
//test('partitionBy regexp', () {
//
//    var result = DartStream.of(["a1", "a2", "b1"])
//        .partitionBy(/a.*/);
//
//    expect(result[true].length, equals( 2));
//    expect(result[false].length, equals( 1));
//    expect(result[true][0], equals( "a1"));
//    expect(result[true][1], equals( "a2"));
//    expect(result[false][0], equals( "b1"));
//
//});
//test('partitionBy predicate empty', () {
//
//    var result = DartStream.of([])
//        .partitionBy((person) {
//            return person.lastName === 'Parker';
//        });
//
//    expect(result[true].length, equals( 0));
//    expect(result[false].length, equals( 0));
//
//});
//test('partitionBy size', () {
//
//    var data = Stream
//        .range(0, 25)
//        .toArray();
//
//    var result = DartStream.of(data)
//        .partitionBy(10);
//
//    expect(result.length, equals( 3));
//    expect(result[0].length, equals( 10));
//    expect(result[1].length, equals( 10));
//    expect(result[2].length, equals( 5));
//
//    for (var i = 0; i < result.length; i++) {
//        var partition = result[i];
//        for (var j = 0; j < partition.length; j++) {
//            var obj = partition[j];
//            expect(obj, equals( j + (i * 10)));
//        }
//    }
//
//});
//test( 'partitionBy size empty',() {
//
//    var result = DartStream.of([])
//        .partitionBy(10);
//
//    expect(Object.keys(result).length, equals( 0));
//
//});
//
//}
