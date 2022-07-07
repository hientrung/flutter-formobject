// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:formobject/formobject.dart';

void main() {
  createForm() {
    return FOForm({
      'data': {
        'name': 'Tester',
        'age': 30,
        'department': {'person': 10},
        'items': [
          {'name': 'Tool', 'price': 10, 'amount': 2},
        ],
        'total': 20
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'Root',
        },
        'Root': {
          'name': {'type': 'string'},
          'age': {'type': 'int'},
          'department': {'type': 'object', 'objectType': 'Department'},
          'items': {
            'type': 'list',
            'itemType': {'type': 'object', 'objectType': 'Product'}
          },
          'total': {'type': 'double'},
        },
        'Department': {
          'person': {'type': 'int'},
        },
        'Product': {
          'name': {'type': 'string'},
          'price': {'type': 'double'},
          'amount': {'type': 'double'},
        }
      }
    });
  }

  test('Constant expr', () {
    final f = createForm();
    expect(f.eval('1 +2* 3'), 7);
    expect(f.eval('true ? 1+3 : 2*3'), 4);
    expect(f.eval('(1+2)*3 > 10'), false);
    expect(f.eval('"A" + "B" == "AB"'), true);
  });

  test('Property expression', () {
    final f = createForm();
    expect(f.eval('name == "Tester"'), true, reason: 'name');
    expect(f.eval("name == 'Tester'"), true, reason: 'name2');
    expect(f.eval('age < 50'), true, reason: 'age');
    expect(f.eval('this.age < 50'), true, reason: 'this.age');
    expect(f['department'].eval('^.age < 50'), true,
        reason: 'department ^.age');
  });

  test('List expression', () {
    final f = createForm();
    expect(f.eval('items[price<20].exist()'), true, reason: '1');
    expect(f['items'].eval('this[price<20].exist()'), true, reason: '2');
    expect(f.eval('items[].sum(price*amount) == total'), true, reason: '3');
    expect(f['items'].eval('this[].exist()'), true, reason: '4');
    expect(f['items'].eval('this[].first().name == "Tool"'), true, reason: '5');
    expect(
        f['items'].eval('this[^.name == "Tester" && price < 20].count() == 1'),
        true,
        reason: '6');
    expect(
        f['items'][0].eval('^[price*amount<=^.total].count() == ^[].count()'),
        true,
        reason: '7');
  });

  test('Nested list expression', () {
    var f = FOForm({
      'data': [
        [
          {'value': 1},
          {'value': 2},
        ],
        [
          {'value': 3},
          {'value': 4},
        ],
      ],
      'meta': {
        ':root': {
          'type': 'list',
          'itemType': {
            'type': 'list',
            'itemType': {'type': 'object', 'objectType': 'Item'}
          },
        },
        'Item': {
          'value': {'type': 'int'}
        }
      }
    });
    expect(f.eval('this[].sum(this[].sum(value))'), 10);
    expect(f.eval('this[this[value>10].exist()].exist()'), false);
    expect(f.eval('this[this[value<3].exist()].sum(this[].sum(value))'), 3);
  });
}
