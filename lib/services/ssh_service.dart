import 'dart:io';
import '../models/ssh_connection.dart';
import 'script_service.dart';
import 'terminal_service.dart';

class SshService {
  static Future<void> connectSsh(SshConnection connection) async {
    if (!connection.isValid) {
      throw Exception('Invalid connection parameters');
    }

    late final File scriptFile;
    
    switch (connection.authType) {
      case AuthType.password:
        scriptFile = await ScriptService.createSshPasswordScript(connection);
        break;
      case AuthType.key:
        scriptFile = await ScriptService.createSshKeyScript(connection);
        break;
    }

    await TerminalService.executeScript(scriptFile.path);
    ScriptService.scheduleScriptCleanup(scriptFile.path);
  }

  static Future<void> connectSftp(SshConnection connection) async {
    if (!connection.isValid) {
      throw Exception('Invalid connection parameters');
    }

    late final File scriptFile;
    
    switch (connection.authType) {
      case AuthType.password:
        scriptFile = await ScriptService.createSftpPasswordScript(connection);
        break;
      case AuthType.key:
        scriptFile = await ScriptService.createSftpKeyScript(connection);
        break;
    }

    await TerminalService.executeScript(scriptFile.path);
    ScriptService.scheduleScriptCleanup(scriptFile.path);
  }

  static Future<bool> validateConnection(SshConnection connection) async {
    return connection.isValid && await TerminalService.isTerminalAvailable();
  }
}