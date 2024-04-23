part of 'component.dart';

abstract class RootComponent extends Component {
  RootComponent({super.key = 'root'}) {
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
    print('ROOT -- 1');
    this.mountPoint = mountPoint;
    // _mount(this);
    // _capsuleContainer.read(_mountChildrenCapsule);
    // _capsuleContainer.read(buildComponentCapsule);
    print('ROOT -- 2');
    final capsule = _capsuleContainer.read(getComponentCapsule)(richNode);
    _capsuleContainer.read(capsule);
    print('ROOT -- 3');
  }
}
