//
//import 'package:flutter_test/flutter_test.dart';
//import 'package:dart_stream/dart_stream.dart';
//import './test_define.dart';
//void main(){
//test('input array', () {
//
//    var input = [1, 2, 3];
//    var result = DartStream.of(input).toArray();
//    expect(result.length, equals( 3));
//    expect(result[0], equals( 1));
//    expect(result[1], equals( 2));
//    expect(result[2], equals( 3));
//
//});
//test('input undefined', () {
//
//    var result = DartStream.of(undefined).toArray();
//    expect(result.length, equals( 0));
//
//});
//test('input null', () {
//
//    var result = DartStream.of(null).toArray();
//    expect(result.length, equals( 0));
//
//});
//test('input makeshift iterator', () {
//
//  function iter(){
//    var index = 0;
//
//    return {
//       next: function(){
//           if (index >= 10) return;
//           return { value: index++, done: (index >= 10) };
//       }
//    };
//  }
//
//  var input = iter();
//  var result = DartStream.of(input)
//    .filter(function(i) {
//        return i % 2;
//    })
//    .takeWhile(function(i) {
//        return i < 7;
//    })
//    .toArray();
//
//  expect(result.length, equals( 3));
//  expect(result[0], equals( 1));
//  expect(result[1], equals( 3));
//  expect(result[2], equals( 5));
//
//});
//test('input stream iterator', () {
//
//  var input = Stream.of(1, 2, 3, 4, 5).iterator();
//  var result = DartStream.of(input)
//    .filter(function(i) {
//        return i % 2;
//    })
//    .toArray();
//
//  expect(result.length, equals( 3));
//  expect(result[0], equals( 1));
//  expect(result[1], equals( 3));
//  expect(result[2], equals( 5));
//
//});
//test('input object', () {
//
//    var input = {
//        foo: 1, bar: 2, foobar: 3
//    };
//
//    var result = DartStream.of(input).toArray();
//    expect(result.length, equals( 3));
//    expect(result[0], equals( 1));
//    expect(result[1], equals( 2));
//    expect(result[2], equals( 3));
//
//});
//test('input string', () {
//
//    var result = DartStream.of("abcd")
//        .filter((c) {
//            return c !== 'b';
//        })
//        .map((c) {
//            return c.toUpperCase();
//        })
//        .joining();
//
//    expect(result, equals( "ACD"));
//
//});
//test('from array', () {
//
//    var input = [1, 2, 3];
//    var result = Stream.from(input).toArray();
//    expect(result.length, equals( 3));
//    expect(result[0], equals( 1));
//    expect(result[1], equals( 2));
//    expect(result[2], equals( 3));
//
//});
//test('from undefined', () {
//
//    var result = Stream.from(undefined).toArray();
//    expect(result.length, equals( 0));
//
//});
//test('from null', () {
//
//    var result = Stream.from(null).toArray();
//    expect(result.length, equals( 0));
//
//});
//test('from object', () {
//
//    var input = {
//        foo: 1, bar: 2, foobar: 3
//    };
//
//    var result = Stream.from(input).toArray();
//    expect(result.length, equals( 3));
//    expect(result[0], equals( 1));
//    expect(result[1], equals( 2));
//    expect(result[2], equals( 3));
//
//});
//test('from string', () {
//
//    var result = Stream.from("abcd")
//        .filter((c) {
//            return c !== 'b';
//        })
//        .map((c) {
//            return c.toUpperCase();
//        })
//        .joining();
//
//    expect(result, equals( "ACD"));
//
//});
//test('of', () {
//
//    var result = Stream.of(1, 2, 3, 4)
//        .filter((num) {
//            return num % 2 === 1;
//        })
//        .map((num) {
//            return "odd" + num;
//        })
//        .toArray();
//
//    expect(result.length, equals( 2));
//    expect(result[0], equals( "odd1"));
//    expect(result[1], equals( "odd3"));
//
//});
//test('empty', () {
//
//    var result = Stream.empty().toArray();
//    expect(result.length, equals( 0));
//
//});
//test('range', () {
//
//    var result = Stream.range(0, 4).toArray();
//    expect(result.length, equals( 4));
//    expect(result[0], equals( 0));
//    expect(result[1], equals( 1));
//    expect(result[2], equals( 2));
//    expect(result[3], equals( 3));
//
//});
//test('rangeClosed', () {
//
//    var result = Stream.rangeClosed(0, 4).toArray();
//    expect(result.length, equals( 5));
//    expect(result[0], equals( 0));
//    expect(result[1], equals( 1));
//    expect(result[2], equals( 2));
//    expect(result[3], equals( 3));
//    expect(result[4], equals( 4));
//
//});
//test('generate', () {
//
//    var result = Stream
//        .generate(Math.random)
//        .limit(10)
//        .toArray();
//
//    expect(result.length, equals( 10));
//
//});
//test( 'iterate',() {
//
//    var result = Stream
//        .iterate(1, (seed) {
//            return seed * 2;
//        })
//        .limit(11)
//        .toArray();
//
//    expect(result.length, equals( 11));
//    expect(result[0], equals( 1));
//    expect(result[1], equals( 2));
//    expect(result[2], equals( 4));
//    expect(result[3], equals( 8));
//    expect(result[4], equals( 16));
//    expect(result[5], equals( 32));
//    expect(result[6], equals( 64));
//    expect(result[7], equals( 128));
//    expect(result[8], equals( 256));
//    expect(result[9], equals( 512));
//    expect(result[10], equals( 1024));
//
//});
//
//}
