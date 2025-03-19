import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_nesine_3221/cubit/registed_cubit/register_cubit.dart';
import 'package:ios_f_n_nesine_3221/pages/register_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nicknameController = TextEditingController();
  String? _initialUsername;
  File? _initialPhoto;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistrationCubit>();
    _nicknameController.text = cubit.state.username ?? '';
    _initialUsername = cubit.state.username;
    _initialPhoto = cubit.state.photo;
  }

  bool get _hasChanges =>
      _nicknameController.text != _initialUsername ||
      _initialPhoto != context.read<RegistrationCubit>().state.photo;

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Changes saved successfully!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFFF0B800),
            title: const Text(
              "Delete Account",
              style: TextStyle(fontSize: 24.0),
            ),
            content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
              style: TextStyle(fontSize: 16.0),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<RegistrationCubit>().deleteAccount(context).then(
                    (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        "Your account has been deleted successfully",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0B800),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/images/back_button.png',
              height: 50,
              width: 50,
            ),
          ),
        ),
        title: const Text(
          'PROFILE',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            state.photo != null
                                ? FileImage(state.photo!)
                                : null,
                        backgroundColor: Colors.white,
                        child:
                            state.photo == null
                                ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 40,
                                )
                                : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nickname',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _nicknameController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter your nickname',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: const Icon(Icons.edit, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            () => context.read<RegistrationCubit>().pickPhoto(),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Change photo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.image, color: Colors.black, size: 35),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _hasChanges ? Colors.black : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed:
                            _hasChanges
                                ? () {
                                  context
                                      .read<RegistrationCubit>()
                                      .setUsernameProfile(
                                        _nicknameController.text,
                                      );
                                  context
                                      .read<RegistrationCubit>()
                                      .saveProfile();
                                  _showSnackBar();
                                }
                                : null,
                        child: const Text(
                          'Save changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _showDeleteAccountDialog(context),
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
