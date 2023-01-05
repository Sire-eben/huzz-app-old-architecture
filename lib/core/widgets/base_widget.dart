import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T? model, Widget? child)? builder;
  final T? model;
  final Widget? child;
  final void Function(T)? onModelReady;
  final bool? singleInstanceModel;

  const BaseWidget.value({super.key,
    @required this.builder,
    @required this.model,
    this.child,
    this.onModelReady,
  }) : singleInstanceModel = true;

  const BaseWidget({
    Key? key,
    this.builder,
    this.model,
    this.child,
    this.onModelReady,
  })  : singleInstanceModel = false,
        super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T? model;

  @override
  void initState() {
    model = widget.model;

    if (widget.onModelReady != null) widget.onModelReady!(model!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.singleInstanceModel!
        ? ChangeNotifierProvider<T>.value(
            value: model!,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Consumer<T?>(
                builder: widget.builder!,
                child: widget.child,
              ),
            ),
          )
        : ChangeNotifierProvider<T>(
            create: (context) => model!,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Consumer<T>(
                builder: widget.builder!,
                child: widget.child,
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
