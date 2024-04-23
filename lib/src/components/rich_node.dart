part of 'component.dart';

/// Represents a node in the [Component] tree.
sealed class RichNode {
  RichNode();

  bool get isComponent => this is ComponentNode;

  bool get isDom => this is DomNode;

  void mount(Component parent);

  void unmount(Component parent);
}

/// Represents a [Component] node in the Component tree.
class ComponentNode extends RichNode {
  ComponentNode(this.component);

  final Component component;

  @override
  void mount(Component parent) {
    component._mount(parent);
  }

  @override
  void unmount(Component parent) {
    component._unmount();
  }
}

/// Represents a leaf HTML node.
class DomNode extends RichNode {
  DomNode(this.node);

  final Node node;

  @override
  void mount(Component parent) {
    parent.node.appendChild(node);
  }

  @override
  void unmount(Component parent) {
    parent.node.removeChild(node);
  }
}
