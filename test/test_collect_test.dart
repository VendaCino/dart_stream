
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';
void main(){
test('collect', () {

    var result = DartStream.of([1, 2, 3, 4]).collect<String,String>(SimpleCollector<int, String,String>(
        supplier: () {
            return "Data: ";
        },
        accumulator: (val, num) {
            return val + num.toString() + " ";
        },
        finisher: (val) {
            return val + "!";
        }
    ));

    expect(result, equals( "Data: 1 2 3 4 !"));

});
test('collect without finisher', () {

    var result = DartStream.of([1, 2, 3, 4]).collect<String,String>(SimpleCollector<int, String,String>(
        supplier: () {
            return "Data: ";
        },
        accumulator: (val, num) {
            return val + num.toString() + " ";
        }
    ));

    expect(result, equals( "Data: 1 2 3 4 "));

});
test( 'collect empty',() {

    var result = DartStream.of<int>([]).collect<String,String>(SimpleCollector<int, String,String>(
        supplier: () {
            return "Data: ";
        },
        accumulator: (val, num) {
            return val + num.toString() + " ";
        },
        finisher: (val) {
            return val + "!";
        }
    ));

    expect(result, equals( "Data: !"));

});

}
