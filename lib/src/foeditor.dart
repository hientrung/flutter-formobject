import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formobject/formobject.dart';

typedef FOEditorCreator = FOEditorBase Function(FOField field);

const registerEditor = FOEditorBase.register;

const editorFor = FOEditorBase.editor;

abstract class FOEditorBase extends StatelessWidget {
  final FOField field;

  const FOEditorBase({
    super.key,
    required this.field,
  });

  String? get help => field.meta['help'];
  String get caption => field.meta['caption'] ?? _getCaption();

  String _getCaption() {
    final n = field.name
        .replaceAll('_', ' ')
        .replaceAllMapped(
            RegExp('[A-Z]'), (m) => ' ${m.group(0)!.toLowerCase()}')
        .trim();
    return n[0].toUpperCase() + n.substring(1);
  }

  static final Map<String, FOEditorCreator> templates = {};

  static void register(Map<String, FOEditorCreator> sources) =>
      templates.addAll(sources);

  static Widget editor(FOField field, [String? template]) {
    if (templates.isEmpty) _defaultRegister();
    final arr = <String>{
      if (template != null) template,
      if (field.meta['template'] != null) field.meta['template'],
      field.fullName,
      field.name,
      field.type.name
    };
    FOEditorCreator? tmpl;
    for (var n in arr) {
      tmpl = templates[n];
      if (tmpl != null) break;
    }
    if (tmpl == null) {
      throw 'Not found editor template: ${arr.join(', ')}';
    }
    return tmpl(field);
  }

  static void _defaultRegister() {
    register({
      'string': (field) => FOEditorProperty.string(field),
      'int': ((field) => FOEditorProperty.int(field)),
      'double': ((field) => FOEditorProperty.double(field)),
      'password': (field) => FOEditorProperty.string(
            field,
            obscureText: true,
          ),
      'datetime': ((field) => FOEditorProperty.date(field)),
      'bool': ((field) => FOEditorProperty.bool(field)),
      'expression': (field) => FOEditorProperty.expression(field),
      'object': (field) => FOEditorObject(field: field),
      'list': (field) => FOEditorList(field: field),
    });
  }
}

class FOEditorForm extends StatelessWidget {
  final FOForm form;

  const FOEditorForm({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: form.childs.map((e) => editorFor(e)).toList(),
    );
  }
}

class FOEditorObject extends FOEditorBase {
  const FOEditorObject({super.key, required super.field})
      : assert(field is FOObject);

  @override
  Widget build(Object context) {
    final lst = field.childs.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.name != 'list-item')
          Text(
            caption,
            style: const TextStyle(inherit: true, fontWeight: FontWeight.bold),
            textScaleFactor: 1.2,
          ),
        ...lst.map((e) => editorFor(e))
      ],
    );
  }
}

class FOEditorList extends FOEditorBase {
  const FOEditorList({super.key, required super.field});

  @override
  Widget build(BuildContext context) {
    return FOObserverValue(
      field: field,
      builder: (ctx, _) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption,
            style: const TextStyle(inherit: true, fontWeight: FontWeight.bold),
            textScaleFactor: 1.2,
          ),
          ...field.childs.map((e) => editorFor(e)),
        ],
      ),
    );
  }
}

class FOEditorProperty extends FOEditorBase {
  final Widget Function(BuildContext context, FOEditorProperty editor) builder;
  final VoidCallback? onDispose;

  const FOEditorProperty({
    required super.field,
    required this.builder,
    super.key,
    this.onDispose,
  });

  bool get isRequired =>
      (field.meta['rules'] as List<dynamic>?)
          ?.any((it) => it['type'] == 'required') ??
      false;

  String? get holder => field.meta['holder'];

  String? get hint => field.meta['hint'];

  @override
  Widget build(BuildContext context) => builder(context, this);

  factory FOEditorProperty.string(
    FOField field, {
    bool obscureText = false,
  }) {
    final ctrl = TextEditingController(text: field.value);
    final sub = field.onChanged((value) {
      if (ctrl.text != value) ctrl.text = value;
    });
    return FOEditorProperty(
      field: field,
      onDispose: () => sub.dispose(),
      builder: (ctx, ed) => FOObserverStatus(
        field: ed.field,
        builder: (ctx, err) => TextField(
          controller: ctrl,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: ed.hint,
            helperText: ed.help,
            labelText: ed.caption,
            errorText: err,
          ),
          onChanged: (v) => ed.field.value = v,
        ),
      ),
    );
  }

  factory FOEditorProperty.int(FOField field) {
    final ctrl = TextEditingController(
        text: field.value == null ? '' : field.value.toString());
    final sub = field.onChanged((value) {
      final s = value == null ? '' : value.toString();
      if (ctrl.text != s) ctrl.text = s;
    });
    return FOEditorProperty(
      field: field,
      onDispose: () => sub.dispose(),
      builder: (ctx, ed) => FOObserverStatus(
        field: ed.field,
        builder: (ctx, err) => TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: ed.hint,
            helperText: ed.help,
            labelText: ed.caption,
            errorText: err,
          ),
          onChanged: (v) => ed.field.value = int.tryParse(v),
        ),
      ),
    );
  }

  factory FOEditorProperty.double(FOField field) {
    final ctrl = TextEditingController(
        text: field.value == null ? '' : field.value.toString());
    final sub = field.onChanged((value) {
      final s = value == null ? '' : value.toString();
      if (ctrl.text != s) ctrl.text = s;
    });
    return FOEditorProperty(
      field: field,
      onDispose: () => sub.dispose(),
      builder: (ctx, ed) => FOObserverStatus(
        field: ed.field,
        builder: (ctx, err) => TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))
          ],
          decoration: InputDecoration(
            hintText: ed.hint,
            helperText: ed.help,
            labelText: ed.caption,
            errorText: err,
          ),
          onChanged: (v) => ed.field.value = double.tryParse(v),
        ),
      ),
    );
  }

  factory FOEditorProperty.date(FOField field) {
    final ctrl = TextEditingController(
        text:
            field.value == null ? '' : field.value.toString().substring(0, 10));
    final sub = field.onChanged((value) {
      final s = value == null ? '' : value.toString().substring(0, 10);
      if (ctrl.text != s) ctrl.text = s;
    });
    return FOEditorProperty(
      field: field,
      onDispose: () => sub.dispose(),
      builder: (ctx, ed) => FOObserverStatus(
        field: ed.field,
        builder: (ctx, err) => TextField(
          controller: ctrl,
          keyboardType: TextInputType.datetime,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))
          ],
          decoration: InputDecoration(
            hintText: ed.hint ?? 'yyyy-mm-dd',
            helperText: ed.help,
            labelText: ed.caption,
            errorText: err,
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () async {
                final d = await showDatePicker(
                  context: ctx,
                  initialDate: ed.field.value ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(3000),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  initialDatePickerMode: DatePickerMode.day,
                );
                if (d != null) ed.field.value = d;
              },
            ),
          ),
          onChanged: (v) {
            if (v.isEmpty) ed.field.value = null;
            try {
              final d = DateTime.parse(v);
              if (d.isAfter(DateTime(1900)) && d.isBefore(DateTime(3000))) {
                ed.field.value = d;
              }
              // ignore: empty_catches
            } catch (ex) {}
          },
        ),
      ),
    );
  }

  factory FOEditorProperty.bool(FOField field) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FOObserverValue(
                field: ed.field,
                builder: (ctx, val) => Checkbox(
                  value: val ?? false,
                  onChanged: (val) => ed.field.value = val ?? false,
                ),
              ),
              GestureDetector(
                child: Text(ed.caption),
                onTap: () => ed.field.value = !(ed.field.value ?? false),
              )
            ],
          ),
          FOObserverStatus(
              field: ed.field,
              builder: (ctx, err) {
                if (err == null) return const SizedBox();
                return Text(
                  err,
                  textScaleFactor: 0.9,
                  style: TextStyle(color: Theme.of(ctx).errorColor),
                );
              })
        ],
      ),
    );
  }

  factory FOEditorProperty.expression(FOField field) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => FOObserverWidget(
        listenOn: field.onChanged,
        initValue: field.value,
        builder: (context, value) =>
            Text(value == null ? '' : value.toString()),
      ),
    );
  }
}

class FOObserverWidget<T, S> extends StatefulWidget {
  final FOSubscription<S> Function(FOChangedHandler<S>) listenOn;
  final Widget Function(BuildContext context, T value) builder;
  final T initValue;
  final T Function(S value)? parser;
  final int debounce;

  const FOObserverWidget({
    super.key,
    required this.listenOn,
    required this.builder,
    required this.initValue,
    this.parser,
    this.debounce = 0,
  });

  @override
  State<StatefulWidget> createState() => _FOObserverWidgetState<T, S>();
}

class _FOObserverWidgetState<T, S> extends State<FOObserverWidget<T, S>> {
  FOSubscription<S>? sub;
  late T value;
  late T oldValue;
  bool changing = false;
  Timer? timerAsync;
  Timer? timerUpdate;

  @override
  void initState() {
    super.initState();
    subscribe();
  }

  @override
  void didUpdateWidget(covariant FOObserverWidget<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenOn != oldWidget.listenOn) {
      subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value);

  void update() {
    if (oldValue == value) return;
    setState(() {
      oldValue = value;
    });
  }

  void subscribe() {
    unsubscribe();
    value = widget.initValue;
    oldValue = value;
    sub = widget.listenOn((val) {
      value = widget.parser != null ? widget.parser!(val) : val as T;
      timerAsync ??= Timer(Duration.zero, () {
        if (widget.debounce == 0) {
          update();
        } else {
          timerUpdate?.cancel();
          timerUpdate = Timer(Duration(milliseconds: widget.debounce), () {
            update();
            timerUpdate = null;
          });
        }
        timerAsync = null;
      });
    });
  }

  void unsubscribe() {
    sub?.dispose();
    timerAsync?.cancel();
    timerAsync = null;
    timerUpdate?.cancel();
    timerUpdate = null;
  }

  @override
  void dispose() {
    unsubscribe();
    super.dispose();
  }
}

class FOObserverStatus extends FOObserverWidget<String?, FOValidStatus> {
  final FOField field;

  FOObserverStatus({
    super.key,
    required this.field,
    required super.builder,
    super.debounce,
  }) : super(
          listenOn: field.onStatusChanged,
          initValue: null,
          parser: (stt) => stt == FOValidStatus.pending ? null : field.error,
        );
}

class FOObserverValue extends FOObserverWidget {
  final FOField field;

  FOObserverValue({
    super.key,
    required this.field,
    required super.builder,
    super.debounce,
  }) : super(
          listenOn: field.onChanged,
          initValue: field.value,
        );
}
