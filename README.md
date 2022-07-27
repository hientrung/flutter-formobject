Solution transferring, update data between server and client written for Dart client

## Features

- A dynamic object to update form data, avoid use encode/decode json object
- Built-in validation and meta data of object to create editor
- Register editor widget template used to edit value of object
- Simple expression parser used for advanced validation, calculated field

## Usage

- Create a form object base on a json data. The json should contains 2 keys: meta, data
  - data: the value of data
  - meta: config field type, validation rules, and some properties used to create editor
- Create editor for form or for a specific field
- Example

```dart
  //create form object base on json mockup or from request
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

  //create widget editor for form
  FOEditorForm(form: register);
  //or create widget editor for a field
  editorFor(register['name']);
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
  - range: the number or object.length should be in a range [min-max]. Optional config key 'min' or 'max' but can not ignored both
  - email: the value must be an email address
  - match: the value must match a regular expression that config in key 'pattern'
  - equal: the value must equal with a result of evaluate expression string that config in key 'expression'
  - expression: Validate value by an expression that has result value is not null, not empty string, not zero or must be true. Require config key 'expression'
  - service: Validate value by an async process. Require implement function Validator.requestHandler to handle caller for async process. Required config key 'url', optional 'fieldNames', 'debounce'
    - url: the url service to call validate in server side
    - fieldNames: additional fields will be used in validation caller 'requestHandler' in parameter 'data'. Fields lookup base on current field or closest 'object' field
    - debounce: the number of second to delay before call validate

### Expression

- An expression should be evaluate base on a FOField object. So it used in 'condition' of validation; in 'expression' of validation rule 'equal', 'expression'; in field's method 'eval'; in 'expression' of calculated field
- Number operators: + - \* / % ^
- Comparison operators : > < >= <= == != && || !
- Bool constants: true, false
- Null constant: null
- Number constant: interger (123) or double (123.0)
- String constant: use single or double quotes, 'abc' or "abc"
- Date constant: use literal # and must match ISO 8601 format, ex: #2021-12-31#, #2021-12-31 23:30:00#
- Group expression: (....)
- Nested field: use dot literal, ex: Address.Province
- Aggregate expression: use operator [] to filter items in list then call a aggregate function base on these filtered items, the syntax like this: `<expression>[<condition>].<aggregate>`
  - expression: it should be return a 'list'
  - condition: an expression used to evaluate for each item in list, to filter items in list. It will be get all items if condition ignored (ex: Items[])
  - aggregate: supported aggregate functions
    - exist(): return true if found first item match condition
    - first(): return first item match condition
    - count(): return number of items match condition
    - sum(expression): return summary value of expression values evaluate on filtered items
    - avg(expression): return average value of expression values evaluate on filtered items
- Use keyword 'this' to get current field context
- Use operator '^' to get parent of current field context, or parent field contains list if it used in condition of aggregate expression
- Example expression on Order object that get how many items have price great than average price

```string
Items[Price > ^.Items[].avg(Price)].count()
```

### Editor template

- Register widget editor via function `registerEditor`. Built-in editors for all field types (string, int, bool,...). It can override default editor for type or define new editor by field name
- Get editor for a form object use `FOEditorForm` or for a specific field in form use `editorFor`. The editor template will be lookup via `name` in registered template follow by priority: template in parameter of `editorFor`, full name of field in form object, name of field, type of field
