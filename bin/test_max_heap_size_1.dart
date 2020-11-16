// dart --old-gen-heap-size=60000 run bin/test_max_heap_size.dart

import 'dart:io';

import '../lib/util.dart';

void main() {
  final stopwatch = Stopwatch()..start();
  final listOfLists = List<List<Object>>(1024 * 1024);
  int allocationCount = 0;
  print('');
  while (true) {
    for (int count = 0; count < 100; ++count) {
      listOfLists[allocationCount] = List<Object>(1024 * 1024);
      ++allocationCount;
      cursorUp();
      eraseLine();
      print('${stopwatch.elapsed} -- $allocationCount');
    }
    sleep(const Duration(milliseconds: 50));
  }
}
