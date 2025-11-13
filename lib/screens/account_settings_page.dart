// lib/screens/account_settings_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingsPage extends StatefulWidget {
  final String currentDisplayName;
  final String currentLocation;

  const AccountSettingsPage({
    Key? key,
    this.currentDisplayName = '',
    this.currentLocation = '',
  }) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentDisplayName);
    _locationController = TextEditingController(text: widget.currentLocation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();
    final newLocation = _locationController.text.trim();

    setState(() => _saving = true);

    String message = "Settings saved";

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update Firebase display name if different
        if (newName.isNotEmpty && newName != user.displayName) {
          await user.updateDisplayName(newName);
          // reload user so further reads get new value
          await user.reload();
          message = "Name updated";
        }
      } else {
        // No firebase user — just show saved message
        message = "Settings saved locally";
      }

      // In a real app you might store location in your DB or SharedPreferences.
      // For now we just return a success message.

      if (!mounted) return;
      Navigator.of(context).pop(message);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving settings: $e")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Display Name",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return "Please enter a name";
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Location",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _saveSettings,
                      child: _saving
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text("Save"),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Note: Display name will be updated in Firebase Auth if you are signed in. Location is not persisted by default.",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
