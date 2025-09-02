import 'dart:io';

class SshService {
  static Future<void> connectWithPassword({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    // Create a temporary expect script file
    final tempDir = Directory.systemTemp;
    final scriptFile = File('${tempDir.path}/ssh_connect.exp');
    
    final expectScript = '''#!/usr/bin/expect
spawn ssh -o StrictHostKeyChecking=no $username@$host -p $port
expect "password:" { send "$password\\r" }
interact
''';

    await scriptFile.writeAsString(expectScript);
    await Process.run('chmod', ['+x', scriptFile.path]);

    await _openTerminalWithCommand(scriptFile.path);
    
    // Start a background process to delete the file after delay
    Process.start('bash', ['-c', 'sleep 3; rm -f ${scriptFile.path}']);
  }

  static Future<void> connectWithKey({
    required String host,
    required int port,
    required String username,
    required String keyPath,
  }) async {
    final sshCommand =
        'ssh -i "$keyPath" -o StrictHostKeyChecking=no $username@$host -p $port';

    await _openTerminalWithCommand(sshCommand);
  }

  static Future<void> _openTerminalWithCommand(String command) async {
    try {
      final result = await Process.run('osascript', [
        '-e',
        '''
        tell application "Terminal"
            activate
            do script "$command"
          end tell
          ''',
      ]);

      if (result.exitCode != 0) {
        print("${result.stderr}");
        throw Exception('AppleScript failed: ${result.stderr}');
      }
    } catch (e) {
      throw Exception('Failed to open Terminal: $e');
    }
  }
}
