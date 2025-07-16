import 'dart:async';

import 'package:flutter/material.dart';

mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<R?> withLoading<R>(FutureOr<R> Function() callback) async {
    if (isLoading.value) return null;

    isLoading.value = true;
    try {
      return await callback();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }
}
