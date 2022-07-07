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
          'rules': [
            {'type': 'required', 'message': 'value required'}
          ]
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
            'rules': [
              {'type': 'required', 'message': 'Required'}
            ]
          },
          'email': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Required'},
              {'type': 'email', 'message': 'Invalid email'}
            ]
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
            'rules': [
              {'type': 'required', 'message': 'Name required'}
            ]
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
            'rules': [
              {'type': 'required', 'message': 'Name required'}
            ]
          },
          'email': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'required'}
            ]
          }
        }
      }
    });
    FOField.customError = null;
    FOField.customErrors = (errors) => errors.join('<br/>');
    expect(f.error, 'Name required<br/>required');
  });

  test('Check list int', () {
    var f = FOForm({
      'data': [1, 2, 3],
      'meta': {
        ':root': {
          'type': 'list',
          'itemType': {'type': 'int'},
          'rules': [
            {'type': 'range', 'message': 'invalid length', 'min': 4},
          ]
        }
      }
    });
    expect(f.isValid, false);
    f.addItem(4);
    expect(f.isValid, true);
  });

  test('Check list object', () {
    var f = FOForm({
      'data': {
        'name': 'Tester',
        'items': [
          {'task': 'Step 1', 'status': 'passed', 'checked': true},
          {'task': 'Step 2', 'status': 'doing', 'checked': false},
          {'task': '', 'status': 'invalid', 'checked': false},
        ]
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'Tester',
        },
        'Tester': {
          'name': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Required'}
            ]
          },
          'items': {
            'type': 'list',
            'itemType': {'type': 'object', 'objectType': 'Task'}
          },
        },
        'Task': {
          'task': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Required'}
            ]
          },
          'status': {'type': 'string'},
          'checked': {'type': 'bool'},
        }
      }
    });

    expect(f.isValid, false);
    f['items'][2]['task'].value = 'Testing';
    expect(f.isValid, true);
    print(f.value);
  });

  test('Check nested list, object', () {
    var f = FOForm({
      'data': [
        [
          {'name': 'A'},
          {'name': 'B'}
        ],
        [
          {'name': '1'},
          {'name': '2'},
          {'name': null}
        ],
      ],
      'meta': {
        ':root': {
          'type': 'list',
          'itemType': {
            'type': 'list',
            'itemType': {'type': 'object', 'objectType': 'Test'}
          },
        },
        'Test': {
          'name': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Name required'}
            ]
          }
        }
      }
    });
    expect(f.isValid, false);
    f[1][2]['name'].value = 'ASDF';
    expect(f.isValid, true);
  });

  test('Validate equal', () {
    final f = FOForm({
      'data': {
        'password': 'asdf',
        'confirm': null,
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'Root',
        },
        'Root': {
          'password': {'type': 'string'},
          'confirm': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Required'},
              {
                'type': 'equal',
                'message': 'Not match',
                'expression': '^.password'
              }
            ]
          }
        }
      }
    });
    expect(f.isValid, false);
    f['confirm'].value = 'test';
    expect(f.isValid, false);
    f['confirm'].value = 'asdf';
    expect(f.isValid, true);
  });

  test('Validate expression', () {
    final f = FOForm({
      'data': {
        'password': 'asdf',
        'confirm': null,
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'Root',
          'rules': [
            {
              'type': 'expression',
              'message': 'invalid',
              'expression': 'password == confirm'
            }
          ]
        },
        'Root': {
          'password': {'type': 'string'},
          'confirm': {
            'type': 'string',
            'rules': [
              {'type': 'required', 'message': 'Required'},
            ]
          }
        }
      }
    });
    expect(f.isValid, false);
    expect(f.error, 'invalid; Required');
    f['confirm'].value = 'test';
    expect(f.isValid, false);
    expect(f.error, 'invalid');
    f['confirm'].value = 'asdf';
    expect(f.isValid, true);
  });

  test('Validate with condition', () {
    final f = FOForm({
      'data': {
        'type': 1,
        'desc': '',
      },
      'meta': {
        ':root': {
          'type': 'object',
          'objectType': 'Root',
        },
        'Root': {
          'type': {'type': 'int'},
          'desc': {
            'type': 'string',
            'rules': [
              {
                'type': 'required',
                'message': 'Required',
                'condition': '^.type == 3'
              }
            ]
          }
        }
      }
    });
    expect(f.isValid, true);
    f['type'].value = 3;
    expect(f.isValid, false);
    f['desc'].value = 'asdf';
    expect(f.isValid, true);
  });
}
