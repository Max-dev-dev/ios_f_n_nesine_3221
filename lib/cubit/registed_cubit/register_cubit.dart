import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RegistrationStatus { initial, success, error }

class RegistrationState {
  final String? username;
  final File? photo;
  final RegistrationStatus status;

  RegistrationState({
    this.username,
    this.photo,
    this.status = RegistrationStatus.initial,
  });
}

class RegistrationCubit extends Cubit<RegistrationState> {
  final Logger _logger = Logger();

  RegistrationCubit() : super(RegistrationState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    _logger.i('Loading Profile Data');
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final photoPath = prefs.getString('photoPath');

    _logger.i('Loaded username: $username');
    _logger.i('Loaded photoPath: $photoPath');

    emit(
      RegistrationState(
        username: username,
        photo:
            photoPath != null && photoPath.isNotEmpty ? File(photoPath) : null,
        status: RegistrationStatus.success,
      ),
    );
  }

  Future<void> setUsername(String username) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      _logger.i('Setting new username: $username');
      await prefs.setString('username', username);

      emit(
        RegistrationState(
          username: username,
          photo: state.photo,
          status: RegistrationStatus.success,
        ),
      );

      loadProfile();
    }

  Future<void> setUsernameProfile(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _logger.i('Setting new username: $username');
    await prefs.setString('username', username);

    emit(
      RegistrationState(
        username: username,
        photo: state.photo,
        status: RegistrationStatus.success,
      ),
    );

    loadProfile();
    _logger.e('Invalid username format: $username');
    emit(RegistrationState(status: RegistrationStatus.error));
  }

  Future<void> pickPhoto() async {
    _logger.i('Picking new photo');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _logger.i('New photo selected: ${pickedFile.path}');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('photoPath', pickedFile.path);
      emit(
        RegistrationState(
          username: state.username,
          photo: File(pickedFile.path),
          status: RegistrationStatus.success,
        ),
      );
    } else {
      _logger.w('No photo selected');
    }
  }

  Future<void> saveProfile() async {
    _logger.i('Saving Profile Data');
    if (state.username != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', state.username!);
      await prefs.setString('photoPath', state.photo?.path ?? '');
      _logger.i('Profile saved successfully');
      loadProfile();
    } else {
      _logger.w('Profile save failed: username is null');
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    emit(RegistrationState(status: RegistrationStatus.initial));
  }
}
