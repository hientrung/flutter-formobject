import 'dart:async';

import 'expression.dart';
import './fovalidator.dart';

///Type suppoerted create a field
enum FOFieldType {
  string,
  int,
  double,
  bool,
  datetime,
  object,
  list,
  expression,
}

///Field validation status
enum FOValidStatus {
  invalid,
  valid,
  validating,
  pending,
}

///Callback function for something changed
typedef FOChangedHandler<T> = void Function(T value);

///Subscription callback function, can unsubscription in later
class FOSubscription<T> {
  final List<FOSubscription<T>> _sources;
  final FOChangedHandler<T> handler;
  FOSubscription(this._sources, this.handler) {
    _sources.add(this);
  }
  void dispose() => _sources.remove(this);
}

///Base class for a field value with validation status
abstract class FOField {
  ///Field name
  final String name;

  ///Field type
  final FOFieldType type;

  ///Meta to create field
  final Map<String, dynamic> meta;

  ///Subscriptions on value changed
  final subscriptions = <FOSubscription>[];

  ///Subscriptions on validation status changed
  final statusSubscriptions = <FOSubscription<FOValidStatus>>[];

  ///Current validate function
  late final FOValidator? validator;

  ///Field parent
  final FOField? parent;
  FOValidStatus _status = FOValidStatus.pending;
  String _fullName = '';
  String? _error;
  final _depends = <FOField, FOSubscription>{};
  Future<String?>? _validating;

  FOField({
    this.parent,
    required this.name,
    required this.type,
    required this.meta,
  }) {
    validator = FOValidator.fromJson(this, meta);
    //validate on changed value
    if (validator != null) {
      onChanged((_) {
        _doValidate();
      });
    } else if (!hasChild) {
      _status = FOValidStatus.valid;
    }
    //combine full name
    var names = <String>[name];
    var p = parent;
    while (p != null && p.name.isNotEmpty) {
      names.insert(0, p.name);
      p = p.parent;
    }
    _fullName = names.join('.');
  }

  ///Register a callback function on value changed
  FOSubscription onChanged(FOChangedHandler handler) =>
      FOSubscription(subscriptions, handler);

  ///Register a callback function on validation status changed
  FOSubscription<FOValidStatus> onStatusChanged(
          FOChangedHandler<FOValidStatus> handler) =>
      FOSubscription<FOValidStatus>(statusSubscriptions, handler);

  ///Notify subscriptions that value changed
  void notify() {
    if (subscriptions.isEmpty) return;
    final val = value;
    for (var it in subscriptions) {
      it.handler(val);
    }
  }

  ///Notify subscriptions that validation status changed
  void notifyStatus() {
    for (var it in statusSubscriptions) {
      it.handler(_status);
    }
  }

  ///Get current value of field
  ///
  ///Inherited class should implement and call super before return value
  dynamic get value {
    _addDepend();
  }

  ///Set current value of field
  set value(dynamic val);

  ///Reset field value and validation status to 'pending'
  ///
  ///Inherited class should implement and call super to reset validation status
  void reset() {
    if (_status != FOValidStatus.pending) {
      _status = FOValidStatus.pending;
      notifyStatus();
    }
  }

  ///Check field value has changed or not
  bool get hasChange;

  void _doValidate() {
    final oldStatus = _status;
    final oldError = _error;
    _validating?.ignore();
    _status = FOValidStatus.validating;

    late FutureOr<String?> res;
    final newDepends = contextDepends(() {
      res = validator!.validate(value);
    });
    _updateDepends(newDepends);

    void completed(String? res) {
      if (res != null && customError != null) {
        _error = customError!(this, res);
      } else {
        _error = res;
      }
      _status = res == null ? FOValidStatus.valid : FOValidStatus.invalid;
      _validating = null;
    }

    if (res is Future<String?>) {
      _validating = res as Future<String?>;
      if (oldStatus != FOValidStatus.validating) notifyStatus();
      _validating!.then((val) {
        completed(val);
        notifyStatus();
      });
    } else {
      completed(res as String?);
      if (_status != oldStatus || _error != oldError) {
        notifyStatus();
      }
    }
  }

  void _updateDepends(List<FOField> newDepends) {
    //remove old
    final removed =
        _depends.entries.where((it) => !newDepends.contains(it.key)).toList();
    for (var it in removed) {
      it.value.dispose();
      _depends.remove(it.key);
    }
    //add new subscription
    for (var it in newDepends) {
      if (!_depends.containsKey(it)) {
        _depends[it] = it.onChanged((_) {
          _doValidate();
        });
      }
    }
  }

  void _addDepend() {
    final cur = Zone.current['FOFieldDepends'];
    final caller = Zone.current['FOFieldCaller'];
    if (cur != null &&
        caller != null &&
        this != caller &&
        cur is List<FOField> &&
        !cur.contains(this)) {
      cur.add(this);
    }
  }

  ///Validate field value. Return true if it's valid
  bool validate() {
    if (_status == FOValidStatus.pending && validator != null) {
      _doValidate();
    } else if (_status == FOValidStatus.pending) {
      _status = FOValidStatus.valid;
    }
    if (hasChild) {
      for (var it in childs) {
        it.validate();
      }
    }
    return isValid;
  }

  ///The current fields depend on items in list to get value or validate
  Iterable<FOField> get depends => _depends.keys;

  ///Current validation status is valid or not
  bool get isValid {
    if (_status == FOValidStatus.pending) validate();
    if (!hasChild) return _status == FOValidStatus.valid;
    if (_status != FOValidStatus.valid) return false;
    return childs.every((it) => it.isValid);
  }

  ///Current validation status
  FOValidStatus get status => _status;

  ///Return name path of field, ex: Property1.Child1.Lead....
  String get fullName => _fullName;

  ///Get current error message if field is not valid
  String? get error {
    if (_status == FOValidStatus.pending) validate();
    return _error;
  }

  ///Determine this field has contains child field, like as 'list', 'object' field
  bool get hasChild => false;

  ///Get child field by index (list) or by name (object)
  FOField operator [](dynamic index) =>
      throw '"$fullName" is not support childs field';

  ///Get list of child fields
  Iterable<FOField> get childs =>
      throw '"$fullName" is not support childs field';

  ///Evaluate an expression with this field context
  dynamic eval(String expression) {
    return evaluate(this, expression);
  }

  ///Run in zone context to get depends
  List<FOField> contextDepends(void Function() run) {
    final List<FOField> lst = [];
    runZonedGuarded(
      run,
      (error, stack) => throw error.toString(),
      zoneValues: {
        'FOFieldDepends': lst,
        'FOFieldCaller': this,
      },
    );
    return lst;
  }

  ///Release all subscriptions
  void dispose() {
    subscriptions.clear();
    statusSubscriptions.clear();
    for (var it in _depends.values) {
      it.dispose();
    }
    _depends.clear();
  }

  ///Convert field to json
  dynamic toJson();

  ///Custom error message return by validation. Used to localize in client side
  static String Function(FOField field, String error)? customError;

  ///Custom error message return by validation for 'object', 'list'.
  /// Used to localize in client side
  static String Function(List<String> errors)? customErrors;
}
