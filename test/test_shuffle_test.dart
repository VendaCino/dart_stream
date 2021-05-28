//
//import 'package:flutter_test/flutter_test.dart';
//import 'package:dart_stream/dart_stream.dart';
//import './test_define.dart';
//void main(){
//test( 'shuffle num array',() {
//
//    var data = [1, 2, 3, 4, 5];
//
//    var result = DartStream.of(data)
//        .shuffle()
//        .toArray();
//
//    expect(result.length, equals( data.length));
//    assert.ok(result.indexOf(1) > -1);
//    assert.ok(result.indexOf(2) > -1);
//    assert.ok(result.indexOf(3) > -1);
//    assert.ok(result.indexOf(4) > -1);
//    assert.ok(result.indexOf(5) > -1);
//
//    // assert original data is untouched
//    expect(data.length, equals( 5));
//    expect(data[0], equals( 1));
//    expect(data[1], equals( 2));
//    expect(data[2], equals( 3));
//    expect(data[3], equals( 4));
//    expect(data[4], equals( 5));
//
//});
//
//}
