// Simple memory test that continually allocates memory until OOM or crash

import 'dart:io';

import 'package:heap_test/util.dart';

void main() {
  final listOfLists = List<List<Object>>(1024 * 1024);
  int allocationCount = 0;
  print('');
  while (true) {
    for (int count = 0; count < 100; ++count) {
      listOfLists[allocationCount] = List<Object>(1024 * 1024);
      ++allocationCount;
      showProgress('$allocationCount');
    }
    sleep(const Duration(milliseconds: 50));
  }
}
