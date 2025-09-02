import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'SSH Client';
  static const int defaultPort = 22;
  static const String defaultHost = '';
  static const String defaultUsername = '';
  
  // UI Constants
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const double defaultSpacing = 16.0;
  static const double cardSpacing = 24.0;
  
  // Button styles
  static const double buttonIconSize = 24.0;
  static const EdgeInsets buttonPadding = EdgeInsets.all(16.0);
  static const TextStyle buttonTextStyle = TextStyle(fontSize: 16);
  
  // Colors
  static const Color sshButtonColor = Colors.blue;
  static const Color sftpButtonColor = Colors.green;
  static const Color buttonTextColor = Colors.white;
  
  // Script cleanup delay
  static const int scriptCleanupDelaySeconds = 3;
  
  // File extensions
  static const List<String> sshKeyExtensions = [
    'pem', 'key', 'pub', 'ppk', 'openssh'
  ];
}

class AppStrings {
  static const String connectionDetails = 'Connection Details';
  static const String authentication = 'Authentication';
  static const String hostLabel = 'Host/IP Address';
  static const String usernameLabel = 'Username';
  static const String portLabel = 'Port';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String useKeyAuth = 'Use SSH Key Authentication';
  static const String keyAuthSelected = 'SSH key authentication selected';
  static const String passwordAuthSelected = 'Password authentication selected';
  static const String selectKey = 'Select Key';
  static const String sshConnect = 'SSH Connect';
  static const String sftpConnect = 'SFTP Connect';
  static const String connecting = 'Connecting...';
  
  // Validation messages
  static const String hostRequired = 'Please enter a host';
  static const String usernameRequired = 'Please enter username';
  static const String passwordRequired = 'Please enter password';
  static const String portRequired = 'Enter port';
  static const String portInvalid = 'Invalid port';
  static const String keyRequired = 'Please select an SSH key file';
  
  // Status messages
  static const String openingTerminal = 'Opening Terminal...';
  static const String openingSftp = 'Opening SFTP...';
  static const String connectionFailed = 'Connection failed';
  static const String sftpConnectionFailed = 'SFTP connection failed';
  static const String noKeySelected = 'No key file selected';
}