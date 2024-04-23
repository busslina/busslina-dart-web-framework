import 'package:busslina_dart_web_framework/lib.dart';
import 'package:rearch/rearch.dart';

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
  String get name => 'Root';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
    return [
      Header().richNode,
    ];
  }
}

class Header extends Component {
  @override
  String get name => 'Header';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
    return [
      _InnerHeader().richNode,
    ];
  }
}

class _InnerHeader extends Component {
  @override
  String get name => 'Inner header';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
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
