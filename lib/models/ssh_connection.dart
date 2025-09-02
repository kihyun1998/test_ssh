enum AuthType {
  password,
  key,
}

enum ConnectionType {
  ssh,
  sftp,
}

class SshConnection {
  final String host;
  final int port;
  final String username;
  final String? password;
  final String? keyPath;
  final AuthType authType;

  const SshConnection({
    required this.host,
    required this.port,
    required this.username,
    this.password,
    this.keyPath,
    required this.authType,
  });

  bool get isValid {
    if (host.trim().isEmpty || username.trim().isEmpty) {
      return false;
    }
    
    if (port < 1 || port > 65535) {
      return false;
    }

    switch (authType) {
      case AuthType.password:
        return password != null && password!.isNotEmpty;
      case AuthType.key:
        return keyPath != null && keyPath!.isNotEmpty;
    }
  }

  String get displayKeyName {
    if (keyPath == null) return 'No key selected';
    return 'Key: ${keyPath!.split('/').last}';
  }

  SshConnection copyWith({
    String? host,
    int? port,
    String? username,
    String? password,
    String? keyPath,
    AuthType? authType,
  }) {
    return SshConnection(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      keyPath: keyPath ?? this.keyPath,
      authType: authType ?? this.authType,
    );
  }

  @override
  String toString() {
    return 'SshConnection(host: $host, port: $port, username: $username, authType: $authType)';
  }
}