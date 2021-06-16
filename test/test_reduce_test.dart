
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('reduce', () {

    var result = DartStream.of([1, 2, 3, 4])
        .reduce<int>(1000, (identity, num) {
            return identity + num;
        });
    expect(result, equals( 1010));

});
test('reduce empty', () {

    var result = DartStream.of<int>([])
        .reduce<int>(1000, (identity, num) {
            return identity + num;
        });
    expect(result, equals( 1000));

});
test('reduce first', () {

    var result = DartStream.of([1, 2, 3, 4])
        .reduce0((identity, num) {
            return identity * num;
        });
    expect(result, equals( 24));

});
test( 'reduce first empty',() {

    var result = DartStream.of([])
        .reduce0((identity, num) {
            return identity * num;
        });
    expect(result, equals( null));

});

}
