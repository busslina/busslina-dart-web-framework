import 'package:rearch/rearch.dart';
import 'package:web/web.dart';

part 'rearch.dart';
part 'rich_node.dart';
part 'root_component.dart';

abstract class Component implements ComponentSideEffectApi {
  Component();

  bool _mounted = false;

  /// Set on [_mount] except for the root component.
  late final CapsuleContainer _capsuleContainer;

  /// Parent component. Set on [_mount].
  late final Component _parent;

  Node get _parentNode => _parent.node;

  /// The node in which this component will be appended as a child.
  // late final Node _parentNode;

  /// The HTML Div node that will contain this [Component] children.
  final node = HTMLDivElement();

  RichNode get richNode => ComponentNode(this);

  final _sideEffectData = <Object?>[];

  final _disposeListeners = <SideEffectApiCallback>{};

  /// Represents a [Set] of functions that remove a dependency on a [Capsule].
  final _dependencyDisposers = <void Function()>{};

  bool get rootNode => false;

  /// Clears out the [Capsule] dependencies of this [Component].
  void _clearDependencies() {
    for (final dispose in _dependencyDisposers) {
      dispose();
    }
    _dependencyDisposers.clear();
  }

  // Node build(ComponentHandle use);
  Iterable<RichNode> build(ComponentHandle use);

  /// Mounts this component in the widget tree via his parent.
  void _mount(Component parent) {
    if (_mounted) {
      throw 'Already mounted';
    }

    _parent = parent;

    if (!rootNode) {
      _capsuleContainer = parent._capsuleContainer;
    }

    _parentNode.appendChild(node);

    for (final richNode in build(_componentHandle)) {
      richNode.mount(this);
    }

    _mounted = true;
  }

  // void Function(Component) _renderCapsule(ComponentHandle use) {
  //   final a = use.value<Component, >();

  //   final firstBuild = use.previous(false) ?? true;

  //   final childNodes = build(use);

  //   return (parent) {};
  // }

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
