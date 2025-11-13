// lib/screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account_settings_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    // set status bar icons to light for the gradient
    final overlayStyle = SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snap) {
                final user = snap.data;
                final displayName = (user?.displayName != null && user!.displayName!.isNotEmpty)
                    ? user.displayName!
                    : widget.username;
                final email = user?.email ?? "${widget.username}@gmail.com";
                final photoUrl = user?.photoURL;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Profile Image
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 65,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: photoUrl != null
                                  ? NetworkImage(photoUrl)
                                  : NetworkImage("https://i.pravatar.cc/300?u=${widget.username}"),
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Edit profile tapped")),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.edit, color: Colors.blueAccent, size: 22),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Name
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Email
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Info Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.calendar_month, "Member Since", "October 2025"),
                            const Divider(),
                            _buildInfoRow(Icons.location_on, "Location", "Amritsar, India"),
                            const Divider(),
                            _buildInfoRow(Icons.star, "User Level", "Gold"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildActionButton(
                              context,
                              icon: Icons.settings,
                              text: "Account Settings",
                              color: Colors.blueAccent,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AccountSettingsPage(
                                      currentDisplayName: displayName,
                                      currentLocation: 'Amritsar, India',
                                    ),
                                  ),
                                );
                                if (result is String && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(result)),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildActionButton(
                              context,
                              icon: Icons.logout,
                              text: _isLoggingOut ? "Logging out..." : "Logout",
                              color: Colors.redAccent,
                              onTap: _isLoggingOut ? null : () => _onLogoutPressed(context),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Handler when Logout button pressed
  Future<void> _onLogoutPressed(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return; // user cancelled

    await _performLogout(context);
  }

  // Performs logout with loading dialog and safe navigation
  Future<void> _performLogout(BuildContext context) async {
    setState(() => _isLoggingOut = true);

    // show a loading dialog using rootNavigator so it's independent
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // optional: show error snackbar but continue to navigate away
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout error (ignored): $e")),
        );
      }
    } finally {
      // always remove loading dialog first
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (!mounted) return;

      setState(() => _isLoggingOut = false);

      // navigate to login and clear stack
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  // Helper widget for info rows
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Helper widget for buttons (onTap required)
  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
        required VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: onTap == null ? color.withOpacity(0.6) : color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
