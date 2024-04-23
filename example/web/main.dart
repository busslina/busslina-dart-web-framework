import 'package:busslina_dart_web_framework/lib.dart';

import 'package:web/web.dart';

void main() {
  Root()
      .mount((document.querySelector('#app_root')! as HTMLElement)..fullSize());
}

class Root extends RootComponent {
  Root() {
    node
      ..style.backgroundColor = 'red'
      ..fullSize();
  }

  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      Header().richNode,
    ];
  }
}

class Header extends Component {
  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      _InnerHeader().richNode,
    ];
  }
}

class _InnerHeader extends Component {
  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
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
}
