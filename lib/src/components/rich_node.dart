part of 'component.dart';

/// Represents a node in the [Component] tree.
sealed class RichNode {
// sealed class RichNode with EquatableMixin {
  RichNode();

  bool get isComponent => this is ComponentNode;

  bool get isDom => this is DomNode;

  ComponentNode get asComponent => this as ComponentNode;

  DomNode get asDom => this as DomNode;

  String get name => isComponent
      ? asComponent.component.name
      : asDom.node.runtimeType.toString();

  String get typeAsString => isComponent ? 'Component' : 'DOM';

  // void mount(Component parent);

  // void unmount(Component parent);

  void _setParent(Component parent) {
    if (isComponent) {
      asComponent.component._parent = parent;
    } else {
      asDom._parent = parent;
    }
  }
}

/// Represents a [Component] node in the Component tree.
class ComponentNode extends RichNode {
  ComponentNode(this.component);

  final Component component;

  @override
  List<Object?> get props => [component];

  // @override
  // void mount(Component parent) {
  //   component._mount(parent);
  // }

  // @override
  // void unmount(Component parent) {
  //   component._unmount();
  // }
}

/// Represents a leaf HTML node.
class DomNode extends RichNode {
  DomNode(this.node);

  final Node node;

  late Component _parent;

  @override
  List<Object?> get props => [node];

  // @override
  // void mount(Component parent) {
  //   parent.node.appendChild(node);
  // }

  // @override
  // void unmount(Component parent) {
  //   parent.node.removeChild(node);
  // }
}
