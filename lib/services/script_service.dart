import 'dart:io';
import '../models/ssh_connection.dart';
import '../utils/constants.dart';

class ScriptService {
  static Future<File> createSshPasswordScript(SshConnection connection) async {
    final tempDir = Directory.systemTemp;
    final scriptFile = File('${tempDir.path}/ssh_connect.exp');
    
    final expectScript = '''#!/usr/bin/expect
spawn ssh -o StrictHostKeyChecking=no ${connection.username}@${connection.host} -p ${connection.port}
expect "password:" { send "${connection.password}\\r" }
interact
''';

    await scriptFile.writeAsString(expectScript);
    await Process.run('chmod', ['+x', scriptFile.path]);
    
    return scriptFile;
  }

  static Future<File> createSshKeyScript(SshConnection connection) async {
    final tempDir = Directory.systemTemp;
    final scriptFile = File('${tempDir.path}/ssh_key_connect.sh');
    
    final shellScript = '''#!/bin/bash
ssh -i "${connection.keyPath}" -o StrictHostKeyChecking=no ${connection.username}@${connection.host} -p ${connection.port}
''';

    await scriptFile.writeAsString(shellScript);
    await Process.run('chmod', ['+x', scriptFile.path]);
    
    return scriptFile;
  }

  static Future<File> createSftpPasswordScript(SshConnection connection) async {
    final tempDir = Directory.systemTemp;
    final scriptFile = File('${tempDir.path}/sftp_connect.exp');
    
    final expectScript = '''#!/usr/bin/expect
spawn sftp -o StrictHostKeyChecking=no -P ${connection.port} ${connection.username}@${connection.host}
expect "password:" { send "${connection.password}\\r" }
interact
''';

    await scriptFile.writeAsString(expectScript);
    await Process.run('chmod', ['+x', scriptFile.path]);
    
    return scriptFile;
  }

  static Future<File> createSftpKeyScript(SshConnection connection) async {
    final tempDir = Directory.systemTemp;
    final scriptFile = File('${tempDir.path}/sftp_key_connect.sh');
    
    final shellScript = '''#!/bin/bash
sftp -i "${connection.keyPath}" -o StrictHostKeyChecking=no -P ${connection.port} ${connection.username}@${connection.host}
''';

    await scriptFile.writeAsString(shellScript);
    await Process.run('chmod', ['+x', scriptFile.path]);
    
    return scriptFile;
  }

  static void scheduleScriptCleanup(String scriptPath) {
    Process.start('bash', [
      '-c', 
      'sleep ${AppConstants.scriptCleanupDelaySeconds}; rm -f $scriptPath'
    ]);
  }
}