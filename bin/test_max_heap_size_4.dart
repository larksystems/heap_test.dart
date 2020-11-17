// Same as test #2 except achieving a steady add/remove state near 32 GiB
// so that it will churn memory for a long time

import 'dart:io';

import 'package:heap_test/util.dart';

final memory = <String, Map<String, String>>{};
int numAdded = 0;
int numRemoved = 0;

void main() {
  print('');
  while (true) {
    for (int count = 0; count < 100; ++count) {
      if (numAdded < 47000) {
        addToMemory();
        addToMemory();
      }
      addToMemory();
      removeFromMemory();
    }
    sleep(const Duration(milliseconds: 1));
  }
}

void addToMemory() {
  var map = memory.putIfAbsent(randomString(), () => {});
  var size = 5 + random.nextInt(15);
  for (int count = 0; count < size; ++count) {
    map[randomString()] = randomString();
  }
  map['data'] = '0' * 1024 * 1024;
  ++numAdded;
  showAddRemoveProgress();
}

void removeFromMemory() {
  int index = random.nextInt(memory.length);
  memory.remove(memory.keys.elementAt(index));
  ++numRemoved;
  showAddRemoveProgress();
}

void showAddRemoveProgress() {
  showProgress('added $numAdded, removed $numRemoved');
}
