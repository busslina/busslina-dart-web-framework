import 'package:equatable/equatable.dart';
import 'package:rearch/rearch.dart';
import 'package:web/web.dart';

part 'rearch.dart';
part 'rich_node.dart';
part 'root_component.dart';

// typedef ComponentBuilder = Component Function({
//   required String parentKey,
// });

abstract class Component with EquatableMixin implements ComponentSideEffectApi {
// abstract class Component implements ComponentSideEffectApi {
  Component({
    required String parentKey,
    required String key,
  })  : _parentKey = parentKey,
        _key = key {
    _debug('Constructor');
  }

  final String _parentKey;
  final String _key;

  String get name;

  final debugId = DateTime.now().microsecondsSinceEpoch;

  String get key => '$_parentKey$_key';

  // bool _mounted = false;

  // bool _unmounted = false;

  // bool _disposed = false;

  /// Set on [_mount] except for the root component.
  late final CapsuleContainer _capsuleContainer;

  /// Parent component. Set on [_mount].
  // late final Component _parent;
  late Component _parent;

  Node get _parentNode => _parent.node;

  /// The node in which this component will be appended as a child.
  // late final Node _parentNode;

  /// The HTML Div node that will contain this [Component] children.
  late final node = HTMLDivElement()..id = '\$component\$-$name';

  RichNode get richNode => ComponentNode(this);

  final _sideEffectData = <Object?>[];

  final _disposeListeners = <SideEffectApiCallback>{};

  /// Represents a [Set] of functions that remove a dependency on a [Capsule].
  final _dependencyDisposers = <void Function()>{};

  bool get rootNode => false;

  @override
  List<Object?> get props => [key];

  /// Clears out the [Capsule] dependencies of this [Component].
  void _clearDependencies() {
    for (final dispose in _dependencyDisposers) {
      dispose();
    }
    _dependencyDisposers.clear();
  }

  Iterable<RichNode> build(ComponentHandle use);

  /// Mounts this component in the widget tree via his parent.
  // void _mount(Component parent) {
  //   debug('_mount()');

  //   if (_mounted) {
  //     throw 'Already mounted';
  //   }

  //   if (_unmounted) {
  //     throw 'Cannot mount. already unmounted';
  //   }

  //   _parent = parent;

  //   if (!rootNode) {
  //     _capsuleContainer = parent._capsuleContainer;
  //   }

  //   _render();

  //   _mounted = true;
  // }

  // void _render() {
  //   _parentNode.appendChild(node);
  //   // _capsuleContainer.read(_mountChildrenCapsule);
  //   _mountChildrenCapsule(_componentHandle);
  // }

  // bool _mountingChildrenCapsule = false;

  // void _mountChildrenCapsule(CapsuleHandle use) {
  // void _mountChildrenCapsule(ComponentHandle use) {
  //   _mountingChildrenCapsule = true;
  //   // _needsRebuild = false;

  //   debug('_mountChildrenCapsule() -- 1');

  //   final children = build(use);
  //   final prevChildren = use.previous(children);

  //   debug(
  //       '_mountChildrenCapsule() -- 2 -- ${children.length} -- ${prevChildren?.length}');

  //   // Unmounting previous children
  //   if (prevChildren != null) {
  //     for (final child in prevChildren) {
  //       child.unmount(this);
  //     }
  //   }

  //   debug('_mountChildrenCapsule() -- 3');

  //   // Mounting children
  //   for (final child in children) {
  //     child.mount(this);
  //   }

  //   debug('_mountChildrenCapsule() -- 4');

  //   _mountingChildrenCapsule = false;
  // }

  // void _unmount() {
  //   debug('_unmount()');

  //   if (!_mounted) {
  //     throw 'Not mounted yet';
  //   }

  //   if (_unmounted) {
  //     throw 'Already unmounted';
  //   }

  //   _parentNode.removeChild(node);

  //   _mounted = false;
  //   _unmounted = true;

  //   _dispose();
  // }

  // void _dispose() {
  //   if (!_unmounted) {
  //     throw 'Cannot dispose before unmount';
  //   }

  //   if (_disposed) {
  //     throw 'Already disposed';
  //   }

  //   for (final listener in _disposeListeners) {
  //     listener();
  //   }

  //   _clearDependencies();

  //   // Clean up after any side effects to avoid possible leaks
  //   _disposeListeners.clear();

  //   _disposed = true;
  // }

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (sideEffectMutation != null) {
      var isCanceled = false;
      sideEffectMutation(() => isCanceled = true);
      if (isCanceled) return;
    }

    print('Component.rebuild() -- $name -- _rendering: $_rendering');

    if (!_rendering) _render();

    // _render();

    // _capsuleContainer.read(getRichNodeCapsule)();

    // getRichNodeCapsule(_componentHandle)(richNode);

    // if (!_mountingChildrenCapsule) {
    //   _mountChildrenCapsule(_componentHandle);
    // }

    // final container = _capsuleContainer;

    // container.runTransaction(() {
    //   container._sideEffectMutationsToCallInTxn!.add(() {
    //     var isCanceled = false;
    //     sideEffectMutation?.call(() => isCanceled = true);
    //     return isCanceled ? null : this;
    //   });
    // });
  }

  @override
  void registerDispose(SideEffectApiCallback callback) =>
      _disposeListeners.add(callback);

  @override
  void unregisterDispose(SideEffectApiCallback callback) =>
      _disposeListeners.remove(callback);

  @override
  void runTransaction(void Function() sideEffectTransaction) =>
      _capsuleContainer.runTransaction(sideEffectTransaction);

  late final _componentHandle = _ComponentHandleImpl(
    this,
    _capsuleContainer,
  );

  void _debug(String msg) => print('Component -- $name -- $msg');

  bool _rendering = false;

  void _render() {
    _rendering = true;
    _renderCapsule(_componentHandle);
    _rendering = false;
  }

  void _renderCapsule(ComponentHandle use) {
    final firstBuild = use.previous(false) ?? true;

    _debug('_renderCapsule() -- firstBuild: $firstBuild');

    final parentNode = _parentNode;

    // Mounting self node
    use.effect(
      () {
        parentNode.appendChild(node);
        return () => parentNode.removeChild(node);
      },
    );

    // Building children
    for (final childNode in build(use)) {
      childNode._setParent(this);

      // Child component (recursive, uses own handle)
      if (childNode.isComponent) {
        final childComponent = (childNode.asComponent.component
          .._capsuleContainer = _capsuleContainer);

        getComponentCapsule(use)(childComponent)(
            childComponent._componentHandle);
      }

      // Child DOM
      else {
        _debug('_renderCapsule() -- DOM child');
        _renderDomChildCapsule(use)(childNode.asDom)(use);
      }
    }
  }

  ComponentCapsule<void> Function(DomNode) _renderDomChildCapsule(
      ComponentHandle use) {
    final domChildCapsules = use.value(<DomNode, ComponentCapsule<void>>{});

    return (domNode) => domChildCapsules.putIfAbsent(
        domNode,
        () => (use) {
              final firstBuild = use.previous(false) ?? true;

              _debug(
                  '_renderDomChildCapsule() -- $domNode -- firstBuild: $firstBuild');

              final parentNode = domNode._parent.node;
              final node = domNode.node;

              use.effect(
                () {
                  parentNode.appendChild(node);
                  return () => parentNode.removeChild(node);
                },
              );
            });
  }
}

/// Global.
ComponentCapsule<void> Function(Component) getComponentCapsule(
  ComponentHandle use,
) {
  final componentCapsules = use.value(<Component, ComponentCapsule<void>>{});

  return (component) => componentCapsules.putIfAbsent(
      component,
      () => (use) {
            // Rebuilding on parent rebuild
            if (!component.rootNode) {
              getComponentCapsule(use)(component._parent);
            }

            component._render();
          });
}
