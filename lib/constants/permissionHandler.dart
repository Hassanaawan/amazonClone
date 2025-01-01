import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<void> requestAllPermissions(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.location,
      Permission.storage,
      Permission.phone,
      Permission.sms,
      Permission.bluetooth,
    ].request();

    // Handle denied or restricted permissions
    statuses.forEach((permission, status) {
      if (status.isPermanentlyDenied) {
        _showSettingsDialog(context, permission.toString());
      }
    });
  }

  void _showSettingsDialog(BuildContext context, String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: Text(
            "The $permission permission is permanently denied. Please enable it from settings."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Go to Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
