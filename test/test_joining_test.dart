
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('joining', () {

    var result = DartStream.of(['1', '2', '3', '4']).joining();
    expect(result, equals( "1234"));

});
test('joining empty', () {

    var result = DartStream.of<String>([]).joining();
    expect(result, equals( ""));

});
test('joining with delimiter', () {

    var result = DartStream.of(['1', '2', '3', '4'])
        .joining(',');
    expect(result, equals( "1,2,3,4"));

});
test( 'joining empty with options',() {

    var result = DartStream.of<String>([])
        .joining(',');
    expect(result, equals( ""));

});

}
