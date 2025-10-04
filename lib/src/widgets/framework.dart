import 'package:flutter/material.dart';

abstract class FkStatelessWidget extends Widget {
  const FkStatelessWidget({super.key});

  @override
  Element createElement() => FkStatelessElement(this);

  Widget build(BuildContext context);
}

abstract class FkStatefulWidget extends Widget {
  const FkStatefulWidget({super.key});

  @override
  Element createElement() => FkStatefulElement(this);

  FkState createState();
}

abstract class FkState<T extends FkStatefulWidget> {
  FkStatefulElement? _element;

  T? _widget;
  T get widget => _widget!;

  void initState() {}

  void dispose() {}

  void setState(void Function() fn) {
    fn.call();
    _element!.markNeedsBuild();
  }

  Widget build(BuildContext context);
}

class FkStatelessElement extends ComponentElement {
  FkStatelessElement(super.widget);

  @override
  Widget build() {
    return (widget as FkStatelessWidget).build(this);
  }
}

class FkStatefulElement extends ComponentElement {
  FkStatefulElement(FkStatefulWidget widget)
    : _state = widget.createState(),
      super(widget) {
    _state._element = this;
    _state._widget = widget;
  }

  final FkState _state;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);

    _state.initState();
  }

  @override
  void unmount() {
    _state.dispose();

    super.unmount();
  }

  @override
  Widget build() => _state.build(this);
}
