import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    app: Firebase.app('OApp'),
  );

  /// Upload bytes (Web + Mobile)
  Future<String> uploadBytes({
    required String storagePath,
    required String fileName,
    required Uint8List bytes,
    String? contentType,
    SettableMetadata? metadata,
  }) async {
    final safeName = _safeFileName(fileName);
    final ref = _storage.ref(_join(storagePath, safeName));

    final meta =
        metadata ??
        SettableMetadata(
          contentType:
              contentType ??
              lookupMimeType(safeName) ??
              'application/octet-stream',
        );

    try {
      final task = ref.putData(bytes, meta);
      final snap = await task.whenComplete(() {});
      return await snap.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Firebase uploadBytes failed (${e.code}): ${e.message}');
    }
  }

  /// Upload local file path (Mobile only)
  Future<String> uploadFile({
    required String storagePath,
    required String filePath,
    String? fileName,
    String? contentType,
    SettableMetadata? metadata,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError(
        'uploadFile(filePath) is not supported on Web. Use uploadBytes().',
      );
    }

    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File does not exist: $filePath');
    }

    final safeName = _safeFileName(fileName ?? p.basename(filePath));
    final ref = _storage.ref(_join(storagePath, safeName));

    final meta =
        metadata ??
        SettableMetadata(
          contentType:
              contentType ??
              lookupMimeType(safeName) ??
              'application/octet-stream',
        );

    try {
      final task = ref.putFile(file, meta);
      final snap = await task.whenComplete(() {});
      return await snap.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Firebase uploadFile failed (${e.code}): ${e.message}');
    }
  }

  Future<String> uploadMusic({
    String? filePath,
    String? uniqueId,
    Uint8List? bytes,
    required String fileName,
  }) async {
    return upload(
      storagePath: 'music/$uniqueId', // folder in Firebase Storage
      filePath: filePath,
      bytes: bytes,
      fileName: fileName,
      contentType: lookupMimeType(fileName) ?? 'audio/mpeg',
    );
  }

  Future<void> deleteFileByUrl(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw Exception('Delete failed (${e.code}): ${e.message}');
    }
  }

  /// Convenience: choose best method automatically
  /// - Web: must pass bytes
  /// - Mobile: can pass filePath or bytes
  Future<String> upload({
    required String storagePath,
    String? filePath,
    Uint8List? bytes,
    required String fileName,
    String? contentType,
    SettableMetadata? metadata,
  }) {
    if (kIsWeb) {
      if (bytes == null) {
        throw ArgumentError('On Web, bytes are required.');
      }
      return uploadBytes(
        storagePath: storagePath,
        fileName: fileName,
        bytes: bytes,
        contentType: contentType,
        metadata: metadata,
      );
    }

    // Mobile
    if (filePath != null && filePath.isNotEmpty) {
      return uploadFile(
        storagePath: storagePath,
        filePath: filePath,
        fileName: fileName,
        contentType: contentType,
        metadata: metadata,
      );
    }

    if (bytes != null) {
      return uploadBytes(
        storagePath: storagePath,
        fileName: fileName,
        bytes: bytes,
        contentType: contentType,
        metadata: metadata,
      );
    }

    throw ArgumentError('Provide either filePath or bytes.');
  }

  Future<void> deleteFile(String fullPath) async {
    await _storage.ref(fullPath).delete();
  }

  Future<List<Reference>> listFiles(String folder) async {
    final result = await _storage.ref(folder).listAll();
    return result.items;
  }

  // ----- helpers -----

  String _join(String a, String b) {
    final left = a.endsWith('/') ? a.substring(0, a.length - 1) : a;
    final right = b.startsWith('/') ? b.substring(1) : b;
    return '$left/$right';
  }

  /// Prevent accidentally passing a full local path as filename
  String _safeFileName(String name) {
    // basename removes directories, also handles windows paths
    final base = p.basename(name);
    // extra cleanup (optional)
    return base.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  }
}
