import 'package:flutter/material.dart';

class DragSelectNotifier extends ValueNotifier<Offset?> {
  DragSelectNotifier() : super(null);
}

class _DragSelectScope extends InheritedWidget {
  const _DragSelectScope({
    required this.notifier,
    required super.child,
  });

  final DragSelectNotifier notifier;

  static DragSelectNotifier? of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_DragSelectScope>()?.notifier;

  @override
  bool updateShouldNotify(_DragSelectScope oldWidget) =>
      notifier != oldWidget.notifier;
}

class DragToSelectRegion extends StatefulWidget {
  const DragToSelectRegion({
    super.key,
    required this.child,
    this.dragThreshold = 4.0,
  });

  final Widget child;
  final double dragThreshold;

  @override
  State<DragToSelectRegion> createState() => _DragToSelectRegionState();
}

class _DragToSelectRegionState extends State<DragToSelectRegion> {
  final _notifier = DragSelectNotifier();
  Offset? _startPosition;
  bool _isDragging = false;

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    _startPosition = event.position;
    _isDragging = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_startPosition == null) return;

    if (!_isDragging) {
      final delta = (event.position - _startPosition!).distance;
      if (delta < widget.dragThreshold) return;
      _isDragging = true;
    }

    _notifier.value = event.position;
  }

  void _onPointerUp(PointerUpEvent event) {
    _startPosition = null;
    if (_isDragging) {
      _notifier.value = null;
      _isDragging = false;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _startPosition = null;
    _notifier.value = null;
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    return _DragSelectScope(
      notifier: _notifier,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: widget.child,
      ),
    );
  }
}

class Selectable extends StatefulWidget {
  const Selectable({
    super.key,
    required this.child,
    required this.onSelectionChanged,
  });

  final Widget child;
  final ValueChanged<bool> onSelectionChanged;

  @override
  State<Selectable> createState() => _SelectableState();
}

class _SelectableState extends State<Selectable> {
  final _key = GlobalKey();
  DragSelectNotifier? _notifier;
  bool _wasSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newNotifier = _DragSelectScope.of(context);

    if (newNotifier != _notifier) {
      _notifier?.removeListener(_onDragChanged);
      _notifier = newNotifier;
      _notifier?.addListener(_onDragChanged);
    }
  }

  @override
  void dispose() {
    _notifier?.removeListener(_onDragChanged);
    super.dispose();
  }

  void _onDragChanged() {
    final dragRect = _notifier?.value;

    if (dragRect == null) {
      _wasSelected = false;
      return;
    }

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;

    final topLeft = renderBox.localToGlobal(Offset.zero);
    final myRect = topLeft & renderBox.size;
    final isSelected = myRect.contains(dragRect);

    if (isSelected != _wasSelected) {
      _wasSelected = isSelected;
      widget.onSelectionChanged(isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
