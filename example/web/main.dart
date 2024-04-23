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
  Iterable<RichNode> build(CapsuleHandle use) {
    // final loading = use(_loadingCapsule);

    final counter = use.data(1);

    use.effect(
      () {
        return Timer.periodic(const Duration(seconds: 15), (_) {
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

      // (HTMLLabelElement()
      //       ..text = 'Loading 1: ${loading.value}'
      //       ..textAlignCenter())
      //     .richNode,

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

    return [
      // Subtitle
      (HTMLHeadingElement.h3()
            ..text = 'Using ReArch'
            ..textAlignCenter()
            ..onMouseEnter.listen((event) {
              loading.value = true;
            })
            ..onMouseOut.listen((event) {
              loading.value = false;
            }))
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
