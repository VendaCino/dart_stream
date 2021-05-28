//
//import 'package:flutter_test/flutter_test.dart';
//import 'package:dart_stream/dart_stream.dart';
//import './test_define.dart';
//void main(){
//test('groupBy', () {
//
//    var data = [
//        {firstName: "Peter", lastName: "Parker"},
//        {firstName: "Sandra", lastName: "Parker"},
//        {firstName: "John", lastName: "Doe"}
//    ];
//
//    var map = DartStream.of(data)
//        .groupBy((obj) {
//            return obj["lastName"];
//        });
//
//    expect(map.hasOwnProperty("Parker"), equals( true));
//    expect(map.hasOwnProperty("Doe"), equals( true));
//    expect(map["Parker"].length, equals( 2));
//    expect(map["Doe"].length, equals( 1));
//    expect(map["Parker"][0], equals( data[0]));
//    expect(map["Parker"][1], equals( data[1]));
//    expect(map["Doe"][0], equals( data[2]));
//
//});
//test('groupBy path', () {
//
//    var data = [
//        {firstName: "Peter", lastName: "Parker"},
//        {firstName: "Sandra", lastName: "Parker"},
//        {firstName: "John", lastName: "Doe"}
//    ];
//
//    var map = DartStream.of(data)
//        .groupBy("lastName");
//
//    expect(map.hasOwnProperty("Parker"), equals( true));
//    expect(map.hasOwnProperty("Doe"), equals( true));
//    expect(map["Parker"].length, equals( 2));
//    expect(map["Doe"].length, equals( 1));
//    expect(map["Parker"][0], equals( data[0]));
//    expect(map["Parker"][1], equals( data[1]));
//    expect(map["Doe"][0], equals( data[2]));
//
//});
//test( 'groupBy empty',() {
//
//    var map = DartStream.of([])
//        .groupBy((obj) {
//            return obj["lastName"];
//        });
//
//    expect(Object.keys(map).length, equals( 0));
//
//});
//
//}
