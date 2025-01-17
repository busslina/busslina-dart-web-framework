import 'dart:async';

import 'package:busslina_dart_web_framework/lib.dart';
import 'package:rearch/rearch.dart';

import 'package:web/web.dart';

void main() {
  Root().mount(
    (document.querySelector('#app_root')! as HTMLElement)..fullSize(),
  );
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
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      Header().richNode,
    ];
  }
}

class Header extends Component {
  Header() : super(key: 'header');

  @override
  String get name => 'Header';

  @override
  Iterable<RichNode> build(ComponentHandle use) {
    final counter = use.data(1);

    print('Count: ${counter.value}');

    use.effect(
      () {
        return Timer.periodic(const Duration(seconds: 5), (_) {
          counter.value++;
        }).cancel;
      },
      [],
    );

    return [
      // Title
      (HTMLHeadingElement.h1()
            ..text = 'Busslina Dart Web Framework'
            ..textAlignCenter())
          .richNode,

      _InnerHeader(count: counter.value).richNode,
    ];
  }
}

class _InnerHeader extends Component {
  _InnerHeader({
    required this.count,
  }) : super(key: 'inner-header');

  final int count;

  @override
  List<Object?> get props => [
        ...super.props,
        count,
      ];

  @override
  String get name => 'Inner header';

  @override
  Iterable<RichNode> build(ComponentHandle use) {
    return [
      // Subtitle
      (HTMLHeadingElement.h3()
            ..text = 'Using ReArch'
            ..textAlignCenter())
          .richNode,

      // Counter
      (HTMLLabelElement()
            ..text = 'Count: $count'
            ..textAlignCenter()
            ..block())
          .richNode,
    ];
  }
}
