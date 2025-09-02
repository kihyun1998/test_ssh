import 'dart:io';

class SshService {
  static Future<void> connectWithPassword({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    final sshCommand = 'ssh -o StrictHostKeyChecking=no $username@$host -p $port';
    
    await _openTerminalWithCommand(sshCommand);
  }

  static Future<void> connectWithKey({
    required String host,
    required int port,
    required String username,
    required String keyPath,
  }) async {
    final sshCommand = 'ssh -i "$keyPath" -o StrictHostKeyChecking=no $username@$host -p $port';
    
    await _openTerminalWithCommand(sshCommand);
  }

  static Future<void> _openTerminalWithCommand(String command) async {
    try {
      final result = await Process.run(
        'osascript',
        [
          '-e',
          '''
        tell application "Terminal"
            activate
            do script "$command"
          end tell
          '''
        ],
      );
      
      if (result.exitCode != 0) {
        throw Exception('AppleScript failed: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('Failed to open Terminal: $e');
    }
  }
}