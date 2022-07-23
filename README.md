Solution transferring, update data between server and client written for Dart client

## Features

- A dynamic object to update form data, avoid use encode/decode json object
- Built-in validation and meta data of object
- Editor widget template for object
- Simple expression parser

## Usage

- Create a form object base on a json data. The json should contains 2 keys: meta, data
  - data: the value of data
  - meta: config field type, validation rules, and some properties used to create editor
- Example

```dart
  final register = FOForm({
    'data': {'name': '', 'password': '', 'confirm': ''},
    'meta': {
      ':root': {'type': 'object', 'objectType': 'Root'},
      'Root': {
        'name': {'type': 'string', 'rules': [
             {'type': 'required', 'message': 'Required'}
         ]},
        'password': {'type': 'string', 'rules': [
             {'type': 'required', 'message': 'Required'}
         ]},
         'confirm': {'type': 'string', 'rules': [
             {'type': 'required', 'message': 'Required'},
             {'type': 'equal', 'message': 'Not matched', 'expression': '^.password'}
         ]},
     }
   }
  });
```

- In meta data, it should has a key ':root' that it's first key entered to create fields and other keys is config meta for an object type
- Built-in type: string, int, double, bool, datetime, object, list, expression. They are create fields with value type string?, int?, double?, DateTime?. See more FOProperty
- The object field has type 'object', and meta 'objectType': 'Type name'. The 'Type name' will be used to find meta in form json to create nested fields. See more FOObject
- The list field has type 'list', and all child items should be same type that defined in meta 'itemType': {'type': ....}. The type of child item can be all supported above types. See more FOList
- The calculated field has type 'expression', and has meta 'expression' is a expression string used to calculate its value. The expression evaluated base on parent field context. See more FOExpression and expression syntax in below
- Example list person

```dart
final persons = FOForm({
    'data': [],
    'meta': {
        ':root': { 'type': 'list', 'itemType': {'type': 'object', 'objectType': 'Person'}},
        'Person': {
            'firstName': {'type': 'string'},
            'lastName': {'type': 'string'},
            'fullName': {'type': 'expression', 'expression': 'firstName + " " + lastName'}
        }
    }
});
```

- Example nested list

```dart
final items = FOForm({
    'data': [],
    'meta': {
        ':root': {
            'type': 'list',
            'itemType': {
                'type': 'list',
                'itemType': {'type': 'string'}
            }
        }
    }
});
```

### Built-in validation

- Config validation rules for each field in meta json with key 'rules'. It's an array with each item has properties to setup rule:
  - type: required, the rule type
  - message: required, the error message used if value is invalid
  - condition: optional, the expression string used to check before run validate
  - other config depend on rule type
- Example

```dart
final name = FOForm({
    'data': '',
    'meta': {
        ':root': {
            'type': 'string',
            'rules': [
                {'type': 'required', 'message': 'Required'}
            ]
        }
    }
})
```

- Rule type:
  - required: the value must be not null, not empty string, not equal 0
  - requiredTrue: the value must be equal true
  - range: the number or object.length should be in a range [min-max]. Optional config 'min', 'max' but can not both
  - email: the value must be an email address
  - match: the value must match a regular expression that config in key 'pattern'
  - equal: the value must equal with a result of evaluate expression string that config in key 'expression'
  - expression: Vaidate value by an expression that has result value is not null, not empty string, not zero or must be true. Require config key 'expression'
  - service: Validate value by an async process. Require implement function Validator.requestHandler to handle caller for async process. Required config key 'url', optional 'fieldNames', 'debounce'
    - fieldNames: extra field name and value used to validate value
    - debounce: the number of second to delay before call validate
