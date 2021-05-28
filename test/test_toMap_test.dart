
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_stream/dart_stream.dart';
import './test_define.dart';

class _Person{
    String firstName;
    String lastName;

    _Person(this.firstName, this.lastName);

}

void main(){
test('toMap', () {

    var data = [
        _Person('Peter', 'Parker'),
        _Person('John', 'Doe')
    ];


    var map = DartStream.of(data)
        .toMap((e)=>e.firstName,(e)=>e);

    expect(map.containsKey("Parker"), equals( false));
    expect(map.containsKey("Doe"), equals( false));
    expect(map["Parker"], equals(null));
    expect(map["Doe"], equals( null));

});
test('toMap path', () {

    var data = [
        _Person('Peter', 'Parker'),
        _Person('John', 'Doe')
    ];

    var map = DartStream.of(data)
        .toMap((e)=>e.lastName,(e)=>e);

    expect(map.containsKey("Parker"), equals( true));
    expect(map.containsKey("Doe"), equals( true));
    expect(map["Parker"], equals( data[0]));
    expect(map["Doe"], equals( data[1]));

});
test('toMap empty', () {

    var map = DartStream.of<_Person>([])
        .toMap((e)=>e.firstName,(e)=>e);

    expect(map.length, equals( 0));

});
test('toMap duplicate key', () {

    var data = [
        _Person('Peter', 'Parker'),
        _Person('Sandra', 'Parker'),
        _Person('John', 'Doe')
    ];

    throwsA(() {
        DartStream.of(data)
            .toMap((e)=>e.lastName,(e)=>e);
    });

});
test( 'toMap duplicate key merge',() {

    var data = [
        _Person('Peter', 'Parker'),
        _Person('Sandra', 'Parker'),
        _Person('John', 'Doe')
    ];

    var map = DartStream.of(data)
        .toMap((e)=>e.lastName,(e)=>e,(o1,o2)=>o1);

    expect(map.containsKey("Parker"), equals( true));
    expect(map.containsKey("Doe"), equals( true));
    expect(map["Parker"], equals( data[0]));
    expect(map["Doe"], equals( data[2]));

});

}
