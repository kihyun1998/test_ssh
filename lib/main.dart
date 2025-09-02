import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'ssh_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SSH Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SshConnectionPage(),
    );
  }
}

class SshConnectionPage extends StatefulWidget {
  const SshConnectionPage({super.key});

  @override
  State<SshConnectionPage> createState() => _SshConnectionPageState();
}

class _SshConnectionPageState extends State<SshConnectionPage> {
  final _formKey = GlobalKey<FormState>();
  final _hostController = TextEditingController(text: '192.168.136.135');
  final _portController = TextEditingController(text: '22');
  final _usernameController = TextEditingController(text: 'root');
  final _passwordController = TextEditingController();

  String? _keyFilePath;
  bool _useKeyAuth = false;
  bool _isConnecting = false;

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectKeyFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _keyFilePath = result.files.single.path;
      });
    }
  }

  Future<void> _connectSFTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_useKeyAuth && _keyFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an SSH key file')),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    try {
      final host = _hostController.text.trim();
      final port = int.parse(_portController.text.trim());
      final username = _usernameController.text.trim();

      if (_useKeyAuth) {
        await SshService.connectSFTPWithKey(
          host: host,
          port: port,
          username: username,
          keyPath: _keyFilePath!,
        );
      } else {
        await SshService.connectSFTPWithPassword(
          host: host,
          port: port,
          username: username,
          password: _passwordController.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Opening SFTP...')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('SFTP connection failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> _connect() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_useKeyAuth && _keyFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an SSH key file')),
      );
      return;
    }

    setState(() {
      _isConnecting = true;
    });

    try {
      final host = _hostController.text.trim();
      final port = int.parse(_portController.text.trim());
      final username = _usernameController.text.trim();

      if (_useKeyAuth) {
        await SshService.connectWithKey(
          host: host,
          port: port,
          username: username,
          keyPath: _keyFilePath!,
        );
      } else {
        await SshService.connectWithPassword(
          host: host,
          port: port,
          username: username,
          password: _passwordController.text,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Opening Terminal...')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Connection failed: $e')));
      }
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
        title: const Text('SSH Client'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connection Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hostController,
                          decoration: const InputDecoration(
                            labelText: 'Host/IP Address',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.computer),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a host';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter username';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _portController,
                                decoration: const InputDecoration(
                                  labelText: 'Port',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.numbers),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Enter port';
                                  }
                                  final port = int.tryParse(value.trim());
                                  if (port == null ||
                                      port < 1 ||
                                      port > 65535) {
                                    return 'Invalid port';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Authentication',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Use SSH Key Authentication'),
                          subtitle: Text(
                            _useKeyAuth
                                ? 'SSH key authentication selected'
                                : 'Password authentication selected',
                          ),
                          value: _useKeyAuth,
                          onChanged: (value) {
                            setState(() {
                              _useKeyAuth = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_useKeyAuth) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _keyFilePath != null
                                      ? 'Key: ${_keyFilePath!.split('/').last}'
                                      : 'No key file selected',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _selectKeyFile,
                                icon: const Icon(Icons.folder_open),
                                label: const Text('Select Key'),
                              ),
                            ],
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Enter your password',
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: _useKeyAuth
                                ? null
                                : (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter password';
                                    }
                                    return null;
                                  },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isConnecting ? null : _connect,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: _isConnecting
                            ? const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Connecting...'),
                                ],
                              )
                            : const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.terminal, size: 24),
                                  SizedBox(height: 8),
                                  Text('SSH Connect'),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isConnecting ? null : _connectSFTP,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          textStyle: const TextStyle(fontSize: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.folder_open, size: 24),
                            SizedBox(height: 8),
                            Text('SFTP Connect'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
