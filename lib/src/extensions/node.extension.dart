import 'package:busslina_dart_web_framework/lib.dart';
import 'package:web/web.dart';

extension NodeExtension on Node {
  RichNode get asRichNode => DomNode(this);
}
