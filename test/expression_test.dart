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
          {'name': 'Tool', 'price': 10},
        ]
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
        },
        'Department': {
          'person': {'type': 'int'},
        },
        'Product': {
          'name': {'type': 'string'},
          'price': {'type': 'double'},
        }
      }
    });
  }

  test('Constant expr', () {
    final f = createForm();
    expect(f.eval('1+2*3'), 7);
    expect(f.eval('true ? 1+3 : 2*3'), 4);
    expect(f.eval('(1+2)*3 > 10'), false);
  });
}
