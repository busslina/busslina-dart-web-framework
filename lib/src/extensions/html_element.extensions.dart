import 'package:web/web.dart';

extension HTMLElementStyleExtension on HTMLElement {
  void fullSize() => style
    ..width = '100%'
    ..height = '100%';

  void textAlignCenter() => style.textAlign = 'center';
}
