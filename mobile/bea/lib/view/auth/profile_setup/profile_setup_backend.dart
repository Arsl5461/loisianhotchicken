import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../config/app_config.dart';
import '../../../core/constants/app_keys.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../services/secure_storage_service.dart';
import '../../../services/storage_service.dart';

/// What the profile-setup flow needs from the outside world.
///
/// Kept behind an interface so the flow can be driven end to end in a test
/// without Firebase or the network - the real one is [LiveProfileSetupBackend].
abstract class ProfileSetupBackend {
  /// Uploads each photo and returns its URL, in the same order.
  Future<List<String>> uploadPhotos(List<File> files);

  Future<ProfileSaveResult> save(Map<String, dynamic> body);

  /// The prompt catalogue. `user/addProfile` keys answers by prompt id, so the
  /// browse list has to come from the API rather than the hard-coded strings
  /// the artboards show.
  Future<List<IcebreakerPrompt>> fetchPrompts();

  /// Adds [text] to the catalogue and returns its id.
  ///
  /// The browse screen falls back to the artboards' nine prompt lines whenever
  /// the catalogue comes back empty, and an answer made against one of those
  /// has no id to be keyed by - which `addProfile` rejects. Registering the
  /// line is what turns that answer back into something the API can store.
  Future<String?> createPrompt(String text);
}

class IcebreakerPrompt {
  const IcebreakerPrompt({required this.id, required this.text});

  final String id;
  final String text;
}

class ProfileSaveResult {
  const ProfileSaveResult({this.ok = false, this.errorMessage});

  final bool ok;
  final String? errorMessage;

  static const ProfileSaveResult success = ProfileSaveResult(ok: true);
}

class LiveProfileSetupBackend implements ProfileSetupBackend {
  LiveProfileSetupBackend({
    ProfileRepository? repository,
    StorageService? storage,
    SecureStorageService? secureStorage,
  })  : _repository = repository ?? ProfileRepository(),
        _storage = storage ?? StorageService.instance,
        _secureStorage = secureStorage ?? Get.find<SecureStorageService>();

  final ProfileRepository _repository;
  final StorageService _storage;
  final SecureStorageService _secureStorage;
  final _uuid = const Uuid();

  @override
  Future<List<String>> uploadPhotos(List<File> files) async {
    if (files.isEmpty) return const [];
    final userId = await _secureStorage.getKey(AppKeys.userID);
    if (userId == null || userId.isEmpty) {
      throw StateError('no user id, so there is nowhere to upload photos to');
    }
    final urls = <String>[];
    for (var index = 0; index < files.length; index++) {
      final file = files[index];
      final name = '${_uuid.v4()}_${p.basename(file.path)}';
      try {
        urls.add(
          await _storage.uploadFile(
            storagePath: 'user_photos/$userId',
            filePath: file.path,
            fileName: name,
          ),
        );
      } catch (error) {
        if (!AppConfig.allowPhotoUploadFallback) rethrow;
        debugPrint('photo upload failed, using a stand-in URL: $error');
        urls.add(_fallbackPhotoUrl(userId, index));
      }
    }
    return urls;
  }

  String _fallbackPhotoUrl(String userId, int index) =>
      'https://picsum.photos/seed/${userId}_$index/800/1000';

  @override
  Future<List<IcebreakerPrompt>> fetchPrompts() async {
    final prompts = await _repository.fetchIceBreakers() ?? const [];
    return [
      for (final prompt in prompts)
        if ((prompt.id ?? '').isNotEmpty && (prompt.prompt ?? '').isNotEmpty)
          IcebreakerPrompt(id: prompt.id!, text: prompt.prompt!),
    ];
  }

  @override
  Future<String?> createPrompt(String text) async {
    final created = await _repository.createIceBreaker(text);
    final id = created?.id;
    return (id == null || id.isEmpty) ? null : id;
  }

  @override
  Future<ProfileSaveResult> save(Map<String, dynamic> body) async {
    final result = await _repository.addProfile(body);
    if (result.isSuccess) return ProfileSaveResult.success;
    return ProfileSaveResult(
      errorMessage: result.errorMessage ?? 'Could not save your profile',
    );
  }
}
