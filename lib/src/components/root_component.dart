part of 'component.dart';

class RootComponent extends Component {
  RootComponent(this.children) {
    if (_instantiated) {
      throw ('RootComponent already created');
    }

    _instantiated = true;
  }

  static bool _instantiated = false;

  Iterable<RichNode> children;

  final _capsuleContainer = CapsuleContainer();

  @override
  Iterable<RichNode> build(ComponentHandle use) => children;

  void mount(Node mountPoint) {
    _parentNode = mountPoint;
    mountPoint.appendChild(_parentNode);
  }
}
