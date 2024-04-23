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
    final loading = use(_loadingCapsule);

    // Expanded mode
    if (expandedMode) {
      final counter = use.data(1);

      use.effect(
        () {
          return Timer.periodic(const Duration(seconds: 15), (_) {
            counter.value++;
            // print('Counter: ${counter.value}');
            // rebuilder();
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

        (HTMLLabelElement()
              ..text = 'Loading 1: ${loading.value}'
              ..textAlignCenter())
            .richNode,

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
  // TODO: implement props
  List<Object?> get props => [
        ...super.props,
        count,
      ];

  @override
  String get name => 'Inner header';

  @override
  Iterable<RichNode> build(CapsuleHandle use) {
    final loading = use(_loadingCapsule);
    // final counter = use.data(1);

    // use.effect(
    //   () {
    //     return Timer.periodic(const Duration(seconds: 10), (_) {
    //       counter.value++;
    //     }).cancel;
    //   },
    //   [],
    // );

    // if (count == 3) {
    //   loading.value = true;
    // }

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

      (HTMLLabelElement()
            ..text = 'Loading 2: ${loading.value}'
            ..textAlignCenter()
            ..block())
          .richNode,
    ];
  }
}

ValueWrapper<bool> _loadingCapsule(CapsuleHandle use) => use.data(false);
