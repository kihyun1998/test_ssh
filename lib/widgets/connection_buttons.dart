import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ConnectionButtons extends StatelessWidget {
  final bool isConnecting;
  final VoidCallback onSshConnect;
  final VoidCallback onSftpConnect;

  const ConnectionButtons({
    super.key,
    required this.isConnecting,
    required this.onSshConnect,
    required this.onSftpConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isConnecting ? null : onSshConnect,
            style: ElevatedButton.styleFrom(
              padding: AppConstants.buttonPadding,
              textStyle: AppConstants.buttonTextStyle,
              backgroundColor: AppConstants.sshButtonColor,
              foregroundColor: AppConstants.buttonTextColor,
            ),
            child: isConnecting
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppConstants.buttonTextColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(AppStrings.connecting),
                    ],
                  )
                : const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.terminal, size: AppConstants.buttonIconSize),
                      SizedBox(height: 8),
                      Text(AppStrings.sshConnect),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: AppConstants.defaultSpacing),
        Expanded(
          child: ElevatedButton(
            onPressed: isConnecting ? null : onSftpConnect,
            style: ElevatedButton.styleFrom(
              padding: AppConstants.buttonPadding,
              textStyle: AppConstants.buttonTextStyle,
              backgroundColor: AppConstants.sftpButtonColor,
              foregroundColor: AppConstants.buttonTextColor,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.folder_open, size: AppConstants.buttonIconSize),
                SizedBox(height: 8),
                Text(AppStrings.sftpConnect),
              ],
            ),
          ),
        ),
      ],
    );
  }
}