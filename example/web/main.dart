import 'package:busslina_dart_web_framework/lib.dart';

import 'package:web/web.dart';

void main() {
  MyRootComponent()
      .mount((document.querySelector('#app_root')! as HTMLElement)..fullSize());
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
      HeaderComponent().asRichNode,
      DomNode(HTMLLabelElement()..text = 'Hello World'),
    ];
  }
}

class HeaderComponent extends Component {
  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      DomNode(
        HTMLHeadingElement.h1()
          ..text = 'Busslina Dart Web Framework'
          ..textAlignCenter(),
      )
    ];
  }
}
