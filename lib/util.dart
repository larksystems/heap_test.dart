import 'dart:io';
import 'dart:math';

/// Moves the cursor up by the specified number of lines without changing columns.
/// If the cursor is already on the top line, ANSI.SYS ignores this sequence.
/// see https://github.com/timsneath/dart_console/blob/master/lib/src/ansi.dart
void cursorUp() => stdout.write('\x1b[A');

/// Clears all characters from the cursor position to the end of the line
/// including the character at the cursor position.
/// see https://github.com/timsneath/dart_console/blob/master/lib/src/ansi.dart
void eraseLine() => stdout.write('\x1b[2K');

final random = Random();
final stopwatch = Stopwatch()..start();

String randomString() {
  var buf = StringBuffer('random-string-');
  var len = random.nextInt(100);
  for (int count = 0; count < len; ++count) {
    buf.writeCharCode(32 + random.nextInt(0x7F - 32));
  }
  return buf.toString();
}

void showProgress(String text) {
  cursorUp();
  eraseLine();
  print('${stopwatch.elapsed} : $text ...');
}
