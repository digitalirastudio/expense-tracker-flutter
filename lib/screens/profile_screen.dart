import 'package:expense_tracker/screens/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedAvatar = '👤';

  final List<String> _avatars = [
    '👤',
    '👨',
    '👩',
    '🧑',
    '🧔',
    '👨‍💼',
    '👩‍💼',
    '🦸',
    '🦸‍♀️',
    '🐱',
    '🐶',
    '🐼',
    '🦊',
    '🐸',
    '⭐',
  ];

  late DatabaseReference _userRef;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    _userRef = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
    ).ref().child('users').child(user!.uid);

    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final snapshot = await _userRef.child('profile').child('avatar').get();

    if (snapshot.exists && snapshot.value != null) {
      setState(() {
        _selectedAvatar = snapshot.value.toString();
      });
    }
  }

  Future<void> _selectAvatar(String avatar) async {
    setState(() {
      _selectedAvatar = avatar;
    });

    await _userRef.child('profile').child('avatar').set(avatar);

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile picture updated.')));
  }

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose your avatar'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _avatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final avatar = _avatars[index];

                return GestureDetector(
                  onTap: () => _selectAvatar(avatar),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAF1DE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(avatar, style: const TextStyle(fontSize: 30)),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  //delete account function
  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      // Try deleting the Firebase Authentication account.
      await user.delete();

      // If deletion succeeds, remove the user's database data.
      final database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

      await database.child('users').child(user.uid).remove();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (!mounted) return;

        final passwordController = TextEditingController();

        final password = await showDialog<String>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text('Confirm your password'),
              content: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, passwordController.text);
                  },
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );

        passwordController.dispose();

        if (password == null || password.isEmpty) return;

        try {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: password,
          );

          await user.reauthenticateWithCredential(credential);

          // Delete the account after successful re-authentication.
          await user.delete();

          final database = FirebaseDatabase.instanceFor(
            app: Firebase.app(),
            databaseURL: 'https://expense-tracker-71410-default-rtdb.asia-southeast1.firebasedatabase.app',
          ).ref();

          await database.child('users').child(user.uid).remove();

          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AuthGate()),
            (route) => false,
          );
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.code == 'wrong-password'
                    ? 'Incorrect password.'
                    : 'Re-authentication failed. Please try again.',
              ),
            ),
          );
        }
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: ${e.message}')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete account: $e')));
    }
  } //delete account function end

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Stack(
                children: [
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: const Color(0xFFDAF1DE),
                    child: Text(
                      _selectedAvatar,
                      style: const TextStyle(fontSize: 65),
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showAvatarPicker,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF235347),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Color(0xFFDAF1DE),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                user?.displayName ?? 'User',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user?.email ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 40),
              //delete account list tile start
              const Spacer(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Delete Account?'),
                            content: const Text(
                              'This will permanently delete your account and expenses. '
                              'This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  Navigator.pop(context);

                                  await _deleteAccount();
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  'Delete Account',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // delete account list tile end
            ],
          ),
        ),
      ),
    );
  }
}
