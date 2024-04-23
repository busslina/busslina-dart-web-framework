import 'package:busslina_dart_web_framework/lib.dart';

extension ComponentExtension on Component {
  void debug(String msg) => print('($name) -- $msg');
}
