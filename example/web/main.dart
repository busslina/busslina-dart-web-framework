import 'package:busslina_dart_web_framework/lib.dart';

import 'package:web/web.dart';

void main() {
  final rootComponent = MyRootComponent();

  rootComponent.mount(document.querySelector('#app_root')!);
}

class MyRootComponent extends RootComponent {
  MyRootComponent() {
    node
      ..style.backgroundColor = 'red'
      ..fullSize();
  }

  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      DomNode(HTMLLabelElement()..text = 'Hello World'),
    ];
  }
}
