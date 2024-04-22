import 'package:busslina_dart_web_framework/lib.dart';
import 'package:rearch/rearch.dart';
import 'package:web/web.dart';

part 'rearch.dart';
part 'rich_node.dart';
part 'root_component.dart';

abstract class Component implements ComponentSideEffectApi {
  Component();

  bool __assembled = false;
  bool _mounted = false;

  late final Component _parent;
  late final CapsuleContainer _capsuleContainer;

  /// The node in which this component will be appended as a child.
  late final Node _parentNode;

  RichNode get asRichNode => ComponentNode(_parent, this);

  final _sideEffectData = <Object?>[];

  final _disposeListeners = <SideEffectApiCallback>{};

  /// Represents a [Set] of functions that remove a dependency on a [Capsule].
  final _dependencyDisposers = <void Function()>{};

  /// Clears out the [Capsule] dependencies of this [Component].
  void _clearDependencies() {
    for (final dispose in _dependencyDisposers) {
      dispose();
    }
    _dependencyDisposers.clear();
  }

  /// Assembles this component in the widget tree via his parent.
  void _assemble(Component parent) {
    if (__assembled) {
      throw 'Already assembled';
    }

    _parent = parent;
    _capsuleContainer = parent._capsuleContainer;

    __assembled = true;
  }

  // Node build(ComponentHandle use);
  Iterable<RichNode> build(ComponentHandle use);

  /// Mount component in DOM
  void _mount() {
    if (_mounted) {
      throw 'Already mounted';
    }

    for (final node in build(_componentHandle)) {
      node.mount(this);
    }

    _mounted = true;
  }

  @override
  void rebuild(
      [void Function(void Function() cancelRebuild)? sideEffectMutation]) {
    // TODO: implement rebuild
  }

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      _disposeListeners.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      _disposeListeners.remove(callback);

  @override
  void runTransaction(void Function() sideEffectTransaction) {
    // TODO: implement runTransaction
  }

  // ComponentTreeController componentTreeCapsule(CapsuleHandle use) {
  //   return ComponentTreeController();
  // }

  ComponentHandle get _componentHandle => _ComponentHandleImpl(
        this,
        _capsuleContainer,
      );
}

class ComponentTreeController {
  ComponentTreeController();
}
