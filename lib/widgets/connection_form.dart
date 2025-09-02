import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ConnectionForm extends StatelessWidget {
  final TextEditingController hostController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final VoidCallback? onChanged;

  const ConnectionForm({
    super.key,
    required this.hostController,
    required this.portController,
    required this.usernameController,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppConstants.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.connectionDetails,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            TextFormField(
              controller: hostController,
              decoration: const InputDecoration(
                labelText: AppStrings.hostLabel,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.computer),
              ),
              onChanged: (_) => onChanged?.call(),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.hostRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.defaultSpacing),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.usernameLabel,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (_) => onChanged?.call(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.usernameRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.defaultSpacing),
                Expanded(
                  child: TextFormField(
                    controller: portController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.portLabel,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged?.call(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.portRequired;
                      }
                      final port = int.tryParse(value.trim());
                      if (port == null || port < 1 || port > 65535) {
                        return AppStrings.portInvalid;
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
    );
  }
}