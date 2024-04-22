part of 'component.dart';

sealed class RichNode {
  RichNode();

  bool get isComponent => this is ComponentNode;

  bool get isDom => this is DomNode;

  void mount(Component parent);
}

class ComponentNode extends RichNode {
  ComponentNode(this.component);

  final Component component;

  @override
  void mount(Component parent) {
    component._mount();
  }
}

class DomNode extends RichNode {
  DomNode(this.node);

  final Node node;

  @override
  void mount(Component parent) {
    parent._parentNode.appendChild(node);
  }
}
