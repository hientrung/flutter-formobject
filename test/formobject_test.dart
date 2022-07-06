// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

import 'package:formobject/formobject.dart';

void main() {
  test('Validate async', () async {
    var field = FOProperty(
      name: 'test',
      type: FOFieldType.string,
      meta: {},
      initValue: 'ASDF',
    );
    var vdASync = FOValidator(field, (val) {
      return Future.delayed(
        const Duration(seconds: 1),
        () => val == 'a' ? 'invalid' : null,
      );
    }, null);
    var vd = FOValidator.all(field, [
      vdASync,
      FOValidator.required(field, 'required', null),
    ]);
    var s = await vd.validate('a');
    expect(s, 'invalid');
    s = await vd.validate('b');
    expect(s, null);
    s = await vd.validate('');
    expect(s, 'required');
  });

  test('Root is string', () {
    var f = FOForm({
      'data': 'testing',
      'meta': {
        ':root': {
          'type': 'string',
          'required': {'message': 'value required'},
        }
      }
    });
    f.onChanged((val) => print(val));
    expect(f.isValid, true);
    expect(f.value, 'testing');
    f.value = null;
    expect(f.isValid, false);
  });

  test('Root is datetime', () {
    var f = FOForm({
      'data': DateTime.now(),
      'meta': {
        ':root': {
          'type': 'datetime',
        }
      }
    });
    expect(f.isValid, true);
  });

  test('Root is object', () {
    var f = FOForm({
      'data': {
        'name': 'Trung',
        'email': null,
        'address': {
          'city': 'Ho Chi Minh',
        },
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'person',
        },
        'person': {
          'name': {
            'type': 'string',
            'required': {'message': 'Required'},
          },
          'email': {
            'type': 'string',
            'required': {'message': 'Required'},
            'email': {'message': 'Invalid email'},
          },
          'address': {
            'type': 'object',
            'objectType': 'address',
          },
        },
        'address': {
          'city': {
            'type': 'string',
          }
        }
      }
    });
    expect(f.isValid, false);
    expect(f.hasChange, false);
    f['email'].value = 'test@test.com';
    expect(f.isValid, true);
    f.value = {
      'address': {'city': 'Ha Noi'}
    };
    expect(f['address']['city'].value, 'Ha Noi');
    expect(f.value['address']['city'], 'Ha Noi');
    var sub = f.onChanged((value) {
      print('changed raised');
      expect(value['address']['city'], 'Test');
    });
    f['address']['city'].value = 'Test';
    sub.dispose();
    print(f.value);
  });

  test('Check field error', () {
    var f = FOForm({
      'data': {'name': ''},
      'meta': {
        ':root': {'type': 'object', 'objectType': 'rootType'},
        'rootType': {
          'name': {
            'type': 'string',
            'required': {'message': 'Name required'}
          }
        }
      }
    });
    expect(f.error, 'Name required');
    FOField.customError = (field, error) => '${field.name} should required';
    f['name'].value = null;
    expect(f.error, 'name should required');
    f.dispose();
  });

  test('Check object errors', () {
    var f = FOForm({
      'data': {'name': ''},
      'meta': {
        ':root': {'type': 'object', 'objectType': 'rootType'},
        'rootType': {
          'name': {
            'type': 'string',
            'required': {'message': 'Name required'}
          },
          'email': {
            'type': 'string',
            'required': {'message': 'required'}
          }
        }
      }
    });
    FOField.customErrors = (errors) => errors.join('<br/>');
    expect(f.error, 'Name required<br/>required');
  });
}
