import 'dart:io';

class TerminalService {
  static Future<void> executeScript(String scriptPath) async {
    try {
      final result = await Process.run('osascript', [
        '-e',
        '''
        tell application "Terminal"
            activate
            do script "$scriptPath"
          end tell
          ''',
      ]);

      if (result.exitCode != 0) {
        throw Exception('AppleScript failed: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('Failed to open Terminal: $e');
    }
  }

  static Future<bool> isTerminalAvailable() async {
    try {
      final result = await Process.run('osascript', [
        '-e',
        'tell application "System Events" to (name of processes) contains "Terminal"'
      ]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }
}