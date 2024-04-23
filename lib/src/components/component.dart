import 'package:equatable/equatable.dart';
import 'package:rearch/rearch.dart';
import 'package:web/web.dart';

part 'rearch.dart';
part 'rich_node.dart';
part 'root_component.dart';

abstract class Component with EquatableMixin implements ComponentSideEffectApi {
// abstract class Component implements ComponentSideEffectApi {
  Component({
    required this.key,
  });

  final String key;

  String get name;

  final debugId = DateTime.now().microsecondsSinceEpoch;

  bool _mounted = false;

  bool _unmounted = false;

  bool _disposed = false;

  /// Set on [_mount] except for the root component.
  late final CapsuleContainer _capsuleContainer;

  /// Parent component. Set on [_mount].
  // late final Component _parent;
  late Component _parent;

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

  @override
  List<Object?> get props => [key];

  /// Clears out the [Capsule] dependencies of this [Component].
  void _clearDependencies() {
    for (final dispose in _dependencyDisposers) {
      dispose();
    }
    _dependencyDisposers.clear();
  }

  Iterable<RichNode> build(CapsuleHandle use);

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

  void _dispose() {
    if (!_unmounted) {
      throw 'Cannot dispose before unmount';
    }

    if (_disposed) {
      throw 'Already disposed';
    }

    for (final listener in _disposeListeners) {
      listener();
    }

    _clearDependencies();

    // Clean up after any side effects to avoid possible leaks
    _disposeListeners.clear();

    _disposed = true;
  }

  @override
  void rebuild([
    void Function(void Function() cancelRebuild)? sideEffectMutation,
  ]) {
    if (sideEffectMutation != null) {
      var isCanceled = false;
      sideEffectMutation(() => isCanceled = true);
      if (isCanceled) return;
    }

    // if (!_mountingChildrenCapsule) {
    //   _mountChildrenCapsule(_componentHandle);
    // }
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
}

Capsule<void> Function(RichNode) getRichNodeCapsule(
  CapsuleHandle use,
) {
  final componentCapsules = use.value(<RichNode, Capsule<void>>{});

  return (component) => componentCapsules.putIfAbsent(
      component,
      () => (use) {
            // (A) Component node
            if (component.isComponent) {
              return use(getComponentCapsule)(component.asComponent.component)(
                use,
              );
            }

            // (B) DOM node
            else {
              return use(getDomCapsule)(component.asDom)(use);
            }
          });
}

Capsule<void> Function(Component) getComponentCapsule(
  CapsuleHandle use,
) {
  final componentCapsules = use.value(<Component, Capsule<void>>{});

  return (component) => componentCapsules.putIfAbsent(
      component,
      () => (use) {
            // final firstBuild = use.previous(false) ?? true;

            void debug(String msg) =>
                print('Capsule (Component) -- ${component.name} -- $msg');

            // Rebuilding on parent rebuild
            if (!component.rootNode) {
              use(getRichNodeCapsule)(component._parent.richNode);
            }

            final parentNode = component._parentNode;
            // final previousParentNode = use.previous(parentNode);
            // final parentEquals = parentNode.isEqualNode(previousParentNode);

            final node = component.node;
            // final previousNode = use.previous(node);
            // final equals = node.isEqualNode(previousNode);

            // debug('Equals I: ${parentNode.isEqualNode(previousParentNode)}');
            // debug('Equals II: $equals');

            // if (firstBuild) {
            //   debug('1');
            //   parentNode.appendChild(node);
            // } else if (!equals) {
            //   if (parentEquals) {
            //     debug('2');
            //     parentNode.replaceChild(node, previousNode!);
            //   } else {
            //     debug('3');
            //     previousParentNode!.removeChild(previousNode!);
            //     parentNode.appendChild(node);
            //   }
            // }

            use.effect(
              () {
                parentNode.appendChild(node);
                return () => parentNode.removeChild(node);
              },
            );

            final children = use(component.build);

            debug('Children: ${children.length}');

            for (final child in children) {
              child._setParent(component);
              use(getRichNodeCapsule)(child)(use);
            }
          });
}

Capsule<void> Function(DomNode) getDomCapsule(
  CapsuleHandle use,
) {
  final domCapsules = use.value(<DomNode, Capsule<void>>{});

  return (dom) => domCapsules.putIfAbsent(
      dom,
      () => (use) {
            // final firstBuild = use.previous(false) ?? true;

            void debug(String msg) =>
                print('Capsule (${dom.typeAsString}) -- ${dom.name} -- $msg');

            final current = dom.asDom;

            // final parentNode = current._parent.node;
            // final previousParentNode = use.previous(parentNode);
            // final parentEquals = parentNode.isEqualNode(previousParentNode);

            final node = current.node;
            // final previousNode = use.previous(node);
            // final equals = node.isEqualNode(previousNode);

            // debug('Previous: $previousNode');
            // debug('Current: $node');
            // debug('Equals I: $parentEquals');
            // debug('Equals II: $equals');

            // previousParentNode?.removeChild(previousNode!);
            // current._parent.node.appendChild(node);

            // if (firstBuild) {
            //   debug('1');
            //   current._parent.node.appendChild(node);
            // } else if (!equals) {
            //   if (parentEquals) {
            //     debug('2');
            //     current._parent.node.replaceChild(node, previousNode!);
            //   } else {
            //     debug('3');
            //     previousParentNode!.removeChild(previousNode!);
            //     current._parent.node.appendChild(node);
            //   }
            // }

            use.effect(
              () {
                current._parent.node.appendChild(node);
                return () => current._parent.node.removeChild(node);
              },
            );
          });
}
