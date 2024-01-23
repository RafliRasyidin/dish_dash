import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? onResume;
  final AsyncCallback? suspendingCallback;

 LifecycleEventHandler({
    this.onResume,
    this.suspendingCallback,
  });

 @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (onResume != null) {
          await onResume!();
        }
        break;
      default:
        if (suspendingCallback != null) {
          await suspendingCallback!();
        }
        break;
    }
  }
}