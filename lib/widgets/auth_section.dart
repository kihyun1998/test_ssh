import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/ssh_connection.dart';
import '../utils/constants.dart';

class AuthSection extends StatelessWidget {
  final TextEditingController passwordController;
  final AuthType authType;
  final String? keyFilePath;
  final Function(AuthType) onAuthTypeChanged;
  final Function(String) onKeyFileSelected;
  final VoidCallback? onChanged;

  const AuthSection({
    super.key,
    required this.passwordController,
    required this.authType,
    required this.keyFilePath,
    required this.onAuthTypeChanged,
    required this.onKeyFileSelected,
    this.onChanged,
  });

  Future<void> _selectKeyFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      onKeyFileSelected(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppConstants.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.authentication,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            SwitchListTile(
              title: const Text(AppStrings.useKeyAuth),
              subtitle: Text(
                authType == AuthType.key
                    ? AppStrings.keyAuthSelected
                    : AppStrings.passwordAuthSelected,
              ),
              value: authType == AuthType.key,
              onChanged: (value) {
                onAuthTypeChanged(value ? AuthType.key : AuthType.password);
                onChanged?.call();
              },
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            if (authType == AuthType.key) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      keyFilePath != null
                          ? 'Key: ${keyFilePath!.split('/').last}'
                          : AppStrings.noKeySelected,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _selectKeyFile,
                    icon: const Icon(Icons.folder_open),
                    label: const Text(AppStrings.selectKey),
                  ),
                ],
              ),
            ] else ...[
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: AppStrings.passwordLabel,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  hintText: AppStrings.passwordHint,
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onChanged: (_) => onChanged?.call(),
                validator: authType == AuthType.key
                    ? null
                    : (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.passwordRequired;
                        }
                        return null;
                      },
              ),
            ],
          ],
        ),
      ),
    );
  }
}