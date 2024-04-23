import 'package:busslina_dart_web_framework/lib.dart';

import 'package:web/web.dart';

void main() {
  RootC()
      .mount((document.querySelector('#app_root')! as HTMLElement)..fullSize());
}

class RootC extends RootComponent {
  RootC() {
    node
      ..style.backgroundColor = 'red'
      ..fullSize();
  }

  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      HeaderC().richNode,
    ];
  }
}

class HeaderC extends Component {
  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      _InnerHeaderC().richNode,
    ];
  }
}

class _InnerHeaderC extends Component {
  @override
  Iterable<RichNode> build(ComponentHandle use) => [
        // Title
        (HTMLHeadingElement.h1()
              ..text = 'Busslina Dart Web Framework'
              ..textAlignCenter())
            .richNode,

        // Subtitle
        (HTMLHeadingElement.h3()
              ..text = 'Using ReArch'
              ..textAlignCenter())
            .richNode,
      ];
}
