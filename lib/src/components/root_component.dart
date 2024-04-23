part of 'component.dart';

abstract class RootComponent extends Component {
  RootComponent() {
    if (_instantiated) {
      throw ('RootComponent already created');
    }

    _instantiated = true;

    _capsuleContainer = CapsuleContainer();
  }

  static bool _instantiated = false;

  late final Node mountPoint;

  @override
  bool get rootNode => true;

  @override
  Node get _parentNode => mountPoint;

  void mount(Node mountPoint) {
    this.mountPoint = mountPoint;
    _mount(this);
    // _capsuleContainer.read(_mountChildrenCapsule);
  }
}
