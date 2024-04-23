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

  @override
  bool get rootNode => true;

  void mount(Node mountPoint) {
    _parentNode = mountPoint;
    _mount(this);
  }
}
