// Same as test #2 except adding an element of async behavior

import 'dart:io';

import 'package:heap_test/util.dart';

final memory = <String, Map<String, String>>{};
int numAdded = 0;
int numRemoved = 0;

void main() async {
  print('');
  while (true) {
    for (int count = 0; count < 100; ++count) {
      await addToMemory();
      await addToMemory();
      Future.delayed(Duration(milliseconds: 1)).then(addToMemory);
      Future.delayed(Duration(milliseconds: 2)).then(removeFromMemory);
    }
    await Future.delayed(Duration(milliseconds: 10));
  }
}

Future addToMemory([_]) async {
  var map = memory.putIfAbsent(randomString(), () => {});
  var size = 5 + random.nextInt(15);
  for (int count = 0; count < size; ++count) {
    map[randomString()] = randomString();
  }
  map['data'] = '0' * 1024 * 1024;
  ++numAdded;
  showAddRemoveProgress();
}

Future removeFromMemory([_]) async {
  int index = random.nextInt(memory.length);
  int half = memory.length ~/ 2;
  if (index > half) {
    index = index % half;
    memory.remove(memory.keys.elementAt(index));
  } else {
    var map = memory[memory.keys.elementAt(index)];
    if (map.isNotEmpty) map.remove(map.keys.first);
  }
  ++numRemoved;
  showAddRemoveProgress();
}

void showAddRemoveProgress() {
  showProgress('added $numAdded, removed $numRemoved');
}
