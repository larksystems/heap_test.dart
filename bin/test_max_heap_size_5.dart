// Simple memory test that reads from a file and allocates memory.
// In the process, it also discards some allocated memory
// to better exercise the GC.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:heap_test/util.dart';

final tmpFile = File('${Platform.script.path}.tmp');
final memory = <String, Map<String, dynamic>>{};
int numAdded = 0;
int numRemoved = 0;

void main() async {
  await createTmpFileIfDoesNotExist();

  int filePos = 0;
  List<int> recordFilePos(List<int> bytes) {
    filePos += bytes.length;
    return bytes;
  }

  const header = 'line # : File pos, map size, added, removed';
  print('                           $header');
  print('...');
  int lineNum = 0;
  StreamSubscription<String> subscription;
  void processLine(String line) async {
    // Pause the stream until the entry has been processed
    subscription.pause();

    await processEntry(line);
    ++lineNum;
    var progress = '$filePos, ${memory.length}, $numAdded, $numRemoved';
    showProgress('processing line $lineNum : $progress ...');

    subscription.resume();
  }

  subscription = tmpFile
      .openRead()
      .map(recordFilePos)
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .listen(processLine);
  var finished = Completer();
  subscription.onDone(() {
    print('processing complete');
    finished.complete();
  });
  await finished.future;
}

/// Create a temporary file to read from if it does not already exist
Future createTmpFileIfDoesNotExist() async {
  if (tmpFile.existsSync()) return;
  var tmpFilePath = tmpFile.path;
  print('Creating file: $tmpFilePath');
  var tmpSink = tmpFile.openWrite();
  for (int count = 0; count < 56000; ++count) {
    if (count % 100 == 0)
      showProgress('Creating file (line $count): $tmpFilePath');
    var now = DateTime.now().toIso8601String();
    tmpSink.writeln(json.encode({"datetime": now, "count": count}));
  }
  await tmpSink.close();
  showProgress('File created: $tmpFilePath');
}

void processEntry(String line) {
  var data = json.decode(line);
  memory[randomString()] = data;
  for (int count = 0; count < 100; ++count) {
    addToMemory();
    addToMemory();
    addToMemory();
    removeFromMemory();
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
}
