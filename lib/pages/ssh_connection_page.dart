import 'package:flutter/material.dart';
import '../models/ssh_connection.dart';
import '../services/ssh_service.dart';
import '../widgets/connection_form.dart';
import '../widgets/auth_section.dart';
import '../widgets/connection_buttons.dart';
import '../utils/constants.dart';

class SshConnectionPage extends StatefulWidget {
  const SshConnectionPage({super.key});

  @override
  State<SshConnectionPage> createState() => _SshConnectionPageState();
}

class _SshConnectionPageState extends State<SshConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController(text: AppConstants.defaultHost);
  final _portController = TextEditingController(text: AppConstants.defaultPort.toString());
  final _usernameController = TextEditingController(text: AppConstants.defaultUsername);
  final _passwordController = TextEditingController();

  AuthType _authType = AuthType.password;
  String? _keyFilePath;
  bool _isConnecting = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  SshConnection get _currentConnection => SshConnection(
    host: _hostController.text.trim(),
    port: int.tryParse(_portController.text.trim()) ?? AppConstants.defaultPort,
    username: _usernameController.text.trim(),
    password: _authType == AuthType.password ? _passwordController.text : null,
    keyPath: _authType == AuthType.key ? _keyFilePath : null,
    authType: _authType,
  );

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _handleConnection(ConnectionType connectionType) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final connection = _currentConnection;
    if (!connection.isValid) {
      if (_authType == AuthType.key && _keyFilePath == null) {
        _showSnackBar(AppStrings.keyRequired);
      }
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    try {
      switch (connectionType) {
        case ConnectionType.ssh:
          await SshService.connectSsh(connection);
          _showSnackBar(AppStrings.openingTerminal);
          break;
        case ConnectionType.sftp:
          await SshService.connectSftp(connection);
          _showSnackBar(AppStrings.openingSftp);
          break;
      }
    } catch (e) {
      final errorMessage = connectionType == ConnectionType.ssh
          ? '${AppStrings.connectionFailed}: $e'
          : '${AppStrings.sftpConnectionFailed}: $e';
      _showSnackBar(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: AppConstants.defaultPadding,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConnectionForm(
                  hostController: _hostController,
                  portController: _portController,
                  usernameController: _usernameController,
                ),
                const SizedBox(height: AppConstants.defaultSpacing),
                AuthSection(
                  passwordController: _passwordController,
                  authType: _authType,
                  keyFilePath: _keyFilePath,
                  onAuthTypeChanged: (authType) {
                    setState(() {
                      _authType = authType;
                    });
                  },
                  onKeyFileSelected: (keyPath) {
                    setState(() {
                      _keyFilePath = keyPath;
                    });
                  },
                ),
                const SizedBox(height: AppConstants.cardSpacing),
                ConnectionButtons(
                  isConnecting: _isConnecting,
                  onSshConnect: () => _handleConnection(ConnectionType.ssh),
                  onSftpConnect: () => _handleConnection(ConnectionType.sftp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}