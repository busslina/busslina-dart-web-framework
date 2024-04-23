import 'dart:async';

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
    final expandedMode = use.data(true);

    // use.callonce(() {
    //   Timer(const Duration(seconds: 15), () {
    //     expandedMode.value = false;
    //   });
    // });

    return [
      Header(
        expandedMode: expandedMode.value,
      ).richNode,
    ];
  }
}

class Header extends Component {
  Header({
    required this.expandedMode,
  }) : super(key: 'header');

  final bool expandedMode;

  @override
  String get name => 'Header';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
    // Expanded mode
    if (expandedMode) {
      final counter = use.data(1);

      use.effect(
        () {
          return Timer.periodic(const Duration(seconds: 10), (_) {
            counter.value++;
          }).cancel;
        },
        [],
      );

      return [
        _InnerHeader(count: counter.value).richNode,
      ];
    }

    // Collapsed mode
    return [
      (HTMLHeadingElement.h1()..text = 'Collapsed').richNode,
    ];
  }
}

class _InnerHeader extends Component {
  _InnerHeader({
    required this.count,
  }) : super(key: 'inner-header');

  final int count;

  @override
  String get name => 'Inner header';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
    // final counter = use.data(1);

    // use.effect(
    //   () {
    //     return Timer.periodic(const Duration(seconds: 10), (_) {
    //       counter.value++;
    //     }).cancel;
    //   },
    //   [],
    // );

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

      // Counter
      (HTMLLabelElement()
            ..text = 'Count: $count'
            ..textAlignCenter())
          .richNode,
    ];
  }
}
