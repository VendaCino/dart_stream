
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
void main(){
test('average', () {

    var result = DartStream.of([1, 2, 3, 4]).average();
    expect(result, equals( 2.5));

});
test('average empty', () {
    var result = DartStream.of<int>([]).average();
    expect(result, equals( null));
});
test( 'average via path (empty)',() {

    var result = DartStream
        .empty<int>()
        .average();
    expect(result, equals( null));
});

}
