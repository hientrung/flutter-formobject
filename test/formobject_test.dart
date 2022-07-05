// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

import 'package:formobject/formobject.dart';

void main() {
  test('Validate async', () async {
    var vdASync = FOValidator((val) {
      return Future.delayed(
        const Duration(seconds: 1),
        () => val == 'a' ? 'invalid' : null,
      );
    });
    var vd = FOValidator.all([vdASync, FOValidator.required('required')]);
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
          'required': 'value required',
        }
      }
    });
    f.getProperty('').onChanged((val) => print(val));
    expect(f.isValid, true);
    expect(f.value, 'testing');
    f.getProperty<String>('').value = null;
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
      },
      'meta': {
        ':root': {
          'type': 'object',
          'valueType': 'person',
        },
        'person': {
          'name': {
            'type': 'string',
            'required': 'Required',
          },
          'email': {
            'type': 'string',
            'required': 'Required',
            'email': 'Invalid email',
          }
        }
      }
    });
    expect(f.isValid, false);
    expect(f.hasChange, false);
    print(f.value);
  });
}
