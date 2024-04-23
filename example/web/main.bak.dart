import 'dart:async';

import 'package:web/web.dart';

void main() {
  final rootDiv = document.querySelector('#app_root')!;

  Node? child;

  Timer.periodic(const Duration(seconds: 1), (_) {
    final newNode = HTMLLabelElement();
    newNode.text = 'Text set at ${DateTime.now()}';

    if (child == null) {
      rootDiv.appendChild(newNode);
    } else {
      rootDiv.replaceChild(newNode, child!);
    }

    child = newNode;
  });
}
