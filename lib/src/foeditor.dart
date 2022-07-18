import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formobject/formobject.dart';

///Function creator an editor
typedef FOEditorCreator = FOEditorBase Function(FOField field);

///Register editor
const registerEditor = FOEditorBase.register;

///Editor for a field
const editorFor = FOEditorBase.editor;

///A base class for editor
abstract class FOEditorBase extends StatelessWidget {
  final FOField field;

  const FOEditorBase({
    super.key,
    required this.field,
  });

  ///Get help string from meta
  String? get help => field.meta['help'];

  ///Get caption string from meta or field's name
  String get caption => field.meta['caption'] ?? _getCaption();

  String _getCaption() {
    final n = field.name
        .replaceAll('_', ' ')
        .replaceAllMapped(
            RegExp('[A-Z]'), (m) => ' ${m.group(0)!.toLowerCase()}')
        .trim();
    return n[0].toUpperCase() + n.substring(1);
  }

  ///Editor template registered
  static final Map<String, FOEditorCreator> templates = {};

  ///Register an editor
  static void register(Map<String, FOEditorCreator> sources) =>
      templates.addAll(sources);

  ///Get editor for a field
  ///Lookup editor base on priority of parameter [template], meta 'template',
  ///field's full name, field's name, and field's type
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

///Default editor for form
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

///Default editor for field 'object'
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

///Default editor for field 'list'
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

///Default editor for a property
class FOEditorProperty extends FOEditorBase {
  ///Widget builder return an editor used to edit value
  final Widget Function(BuildContext context, FOEditorProperty editor) builder;

  const FOEditorProperty({
    required super.field,
    required this.builder,
    super.key,
  });

  bool get isRequired =>
      (field.meta['rules'] as List<dynamic>?)
          ?.any((it) => it['type'] == 'required') ??
      false;

  String? get hint => field.meta['hint'];

  @override
  Widget build(BuildContext context) => builder(context, this);

  factory FOEditorProperty.string(
    FOField field, {
    bool obscureText = false,
  }) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => FOTextField(
        field: ed.field,
        obscureText: obscureText,
        caption: ed.caption,
        requiredMark: ed.isRequired,
        hint: ed.hint,
        help: ed.help,
        formatter: (value) => value == null ? '' : value.toString(),
        parser: (text) => text,
      ),
    );
  }

  factory FOEditorProperty.int(FOField field) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => FOTextField(
        field: ed.field,
        caption: ed.caption,
        requiredMark: ed.isRequired,
        formatter: (value) => value == null ? '' : value.toString(),
        parser: (text) => int.tryParse(text),
        hint: ed.hint,
        help: ed.help,
        keyboardType: TextInputType.number,
        inputFormatter: FilteringTextInputFormatter.digitsOnly,
      ),
    );
  }

  factory FOEditorProperty.double(FOField field) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => FOTextField(
        field: ed.field,
        caption: ed.caption,
        requiredMark: ed.isRequired,
        formatter: (value) => value == null ? '' : value.toString(),
        parser: (text) => double.tryParse(text),
        hint: ed.hint,
        help: ed.help,
        keyboardType: TextInputType.number,
        inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
      ),
    );
  }

  factory FOEditorProperty.date(FOField field) {
    return FOEditorProperty(
      field: field,
      builder: (ctx, ed) => FOTextField(
        field: ed.field,
        caption: ed.caption,
        requiredMark: ed.isRequired,
        formatter: (value) =>
            value == null ? '' : value.toString().substring(0, 10),
        parser: (text) {
          if (text.isEmpty) return null;
          try {
            final d = DateTime.parse(text);
            if (d.isAfter(DateTime(1900)) && d.isBefore(DateTime(3000))) {
              return d;
            }
            // ignore: empty_catches
          } catch (ex) {}
          return null;
        },
        hint: ed.hint ?? 'yyyy-mm-dd',
        help: ed.help,
        inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
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

class FOTextField extends StatefulWidget {
  final FOField field;
  final String? help;
  final String? hint;
  final String caption;
  final TextInputFormatter? inputFormatter;
  final String Function(dynamic value) formatter;
  final dynamic Function(String text) parser;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool requiredMark;

  const FOTextField({
    super.key,
    required this.field,
    required this.caption,
    required this.formatter,
    required this.parser,
    this.help,
    this.hint,
    this.inputFormatter,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.requiredMark = false,
  });

  @override
  State<StatefulWidget> createState() => _FOTextFieldState();
}

class _FOTextFieldState extends State<FOTextField> {
  late final TextEditingController controller;
  FOSubscription? sub;

  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: widget.formatter(widget.field.value));
    subscribe();
  }

  @override
  void didUpdateWidget(covariant FOTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.field != oldWidget.field) {
      setState(() {
        controller.text = widget.formatter(widget.field.value);
        subscribe();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FOObserverStatus(
      field: widget.field,
      builder: (ctx, err) => TextField(
        controller: controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          label: widget.requiredMark
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.caption),
                    Text(
                      '*',
                      style: TextStyle(color: Theme.of(ctx).errorColor),
                    )
                  ],
                )
              : Text(widget.caption),
          hintText: widget.hint,
          helperText: widget.help,
          errorText: err,
          suffixIcon: widget.suffixIcon,
        ),
        obscureText: widget.obscureText,
        inputFormatters: [
          if (widget.inputFormatter != null) widget.inputFormatter!,
        ],
        onChanged: (value) => widget.field.value = widget.parser(value),
      ),
    );
  }

  void subscribe() {
    unsubscribe();
    sub = widget.field.onChanged((value) {
      final s = widget.formatter(value);
      if (controller.text != s) controller.text = s;
    });
  }

  void unsubscribe() {
    sub?.dispose();
  }

  @override
  void dispose() {
    unsubscribe();
    controller.dispose();
    super.dispose();
  }
}
