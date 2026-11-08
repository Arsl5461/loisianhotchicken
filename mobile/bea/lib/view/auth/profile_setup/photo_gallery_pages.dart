import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../utils/toast.dart';
import 'photo_album_screen.dart';
import 'photo_camera_screen.dart';
import 'photo_preview_screen.dart';
import 'photo_library_screen.dart';
import 'profile_setup_controller.dart';

class BubbaGallery {
  BubbaGallery._();

  static const int _pageSize = 120;

  static Future<bool> ensurePermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    if (state.isAuth || state.hasAccess) return true;
    Toast.warning('Bubba needs access to your photos to add them.');
    return false;
  }

  /// Every album on the device, for the album picker.
  static Future<List<AssetPathEntity>> albums() => PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: false,
      );

  /// The single "Recent" album that holds every image. [albums] cannot stand in
  /// for this: with `onlyAll: false` the first entry is whichever folder the
  /// platform lists first, which is routinely an empty one - that is why the
  /// grid came up blank right after the user granted access.
  static Future<AssetPathEntity?> recents() async {
    final all = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );
    return all.isEmpty ? null : all.first;
  }

  static Future<List<AssetEntity>> assetsOf(AssetPathEntity album) =>
      album.getAssetListPaged(page: 0, size: _pageSize);
}

class BubbaPhotoLibraryPage extends StatefulWidget {
  const BubbaPhotoLibraryPage({super.key, this.album, this.maxSelection = 6});

  final AssetPathEntity? album;
  final int maxSelection;

  @override
  State<BubbaPhotoLibraryPage> createState() => _BubbaPhotoLibraryPageState();
}

class _BubbaPhotoLibraryPageState extends State<BubbaPhotoLibraryPage> {
  AssetPathEntity? _album;
  List<AssetEntity> _assets = const [];
  bool _busy = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _album = widget.album;
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      if (!await BubbaGallery.ensurePermission()) {
        if (mounted) Get.back();
        return;
      }
      final album = _album ?? await BubbaGallery.recents();
      final assets =
          album == null ? const <AssetEntity>[] : await BubbaGallery.assetsOf(album);
      if (!mounted) return;
      setState(() {
        _album = album;
        _assets = assets;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      Toast.error('Could not open your photos. Please try again.');
    }
  }

  Future<void> _chooseAlbum() async {
    final picked = await Get.to<AssetPathEntity>(() => const BubbaPhotoAlbumPage());
    if (picked == null || !mounted) return;
    setState(() {
      _album = picked;
      _assets = const [];
      _loading = true;
    });
    _load();
  }

  Future<void> _next(List<int> indexes) async {
    if (_busy) return;
    setState(() => _busy = true);

    final controller = ProfileSetupController.instance;
    final free = controller.photos.where((p) => p == null).length;

    for (final index in indexes.take(free)) {
      if (index < 0 || index >= _assets.length) continue;
      final file = await _assets[index].file;
      if (file == null) continue;
      controller.addPhoto(ProfileSetupPhoto(File(file.path)));
    }

    if (!mounted) return;
    Get.back();
  }

  @override
  Widget build(BuildContext context) => PhotoLibraryScreen(
        photos: [
          for (final asset in _assets)
            AssetEntityImageProvider(asset, isOriginal: false),
        ],
        albumName: _album?.name ?? 'Recents',
        maxSelection: widget.maxSelection,
        loading: _loading,
        busy: _busy,
        onCancel: Get.back,
        onChooseAlbum: _chooseAlbum,
        onNext: _busy ? null : _next,
      );
}

class BubbaPhotoAlbumPage extends StatefulWidget {
  const BubbaPhotoAlbumPage({super.key});

  @override
  State<BubbaPhotoAlbumPage> createState() => _BubbaPhotoAlbumPageState();
}

class _BubbaPhotoAlbumPageState extends State<BubbaPhotoAlbumPage> {
  List<AssetPathEntity> _albums = const [];
  final Map<String, ImageProvider?> _covers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      if (!await BubbaGallery.ensurePermission()) {
        if (mounted) Get.back();
        return;
      }
      final albums = await BubbaGallery.albums();
      final covers = <String, ImageProvider?>{};
      final counts = <String, int>{};
      for (final album in albums) {
        counts[album.id] = await album.assetCountAsync;
        final first = await album.getAssetListPaged(page: 0, size: 1);
        covers[album.id] = first.isEmpty
            ? null
            : AssetEntityImageProvider(first.first, isOriginal: false);
      }
      if (!mounted) return;
      setState(() {
        _albums = albums;
        _loading = false;
        _covers
          ..clear()
          ..addAll(covers);
        _counts
          ..clear()
          ..addAll(counts);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      Toast.error('Could not open your albums. Please try again.');
    }
  }

  final Map<String, int> _counts = {};

  @override
  Widget build(BuildContext context) => PhotoAlbumScreen(
        loading: _loading,
        albums: [
          for (final album in _albums)
            PhotoAlbum(
              name: album.name,
              count: _counts[album.id] ?? 0,
              cover: _covers[album.id],
            ),
        ],
        onBack: Get.back,
        onPick: (picked) {
          final match = _albums.firstWhere(
            (a) => a.name == picked.name,
            orElse: () => _albums.first,
          );
          Get.back(result: match);
        },
      );
}

class BubbaPhotoCameraPage extends StatefulWidget {
  const BubbaPhotoCameraPage({super.key});

  @override
  State<BubbaPhotoCameraPage> createState() => _BubbaPhotoCameraPageState();
}

class _BubbaPhotoCameraPageState extends State<BubbaPhotoCameraPage>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = const [];
  CameraController? _camera;
  int _lens = 0;
  bool _flash = false;
  bool _busy = false;
  File? _lastShot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      camera.dispose();
      _camera = null;
    } else if (state == AppLifecycleState.resumed) {
      _open(_lens);
    }
  }

  Future<void> _start() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (error) {
      Toast.error(error.description ?? 'No camera is available.');
      if (mounted) Get.back();
      return;
    }
    if (_cameras.isEmpty) {
      Toast.error('No camera is available on this device.');
      if (mounted) Get.back();
      return;
    }
    await _open(0);
  }

  Future<void> _open(int index) async {
    if (_cameras.isEmpty) return;
    final next = CameraController(
      _cameras[index % _cameras.length],
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await next.initialize();
      await next.setFlashMode(_flash ? FlashMode.torch : FlashMode.off);
    } on CameraException catch (error) {
      Toast.error(error.description ?? 'Could not open the camera.');
      return;
    }
    if (!mounted) {
      await next.dispose();
      return;
    }
    final previous = _camera;
    setState(() {
      _camera = next;
      _lens = index % _cameras.length;
    });
    await previous?.dispose();
  }

  Future<void> _toggleFlash() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;
    final next = !_flash;
    try {
      await camera.setFlashMode(next ? FlashMode.torch : FlashMode.off);
    } on CameraException {
      Toast.warning('This camera has no flash.');
      return;
    }
    if (mounted) setState(() => _flash = next);
  }

  Future<void> _shutter() async {
    final camera = _camera;
    if (_busy || camera == null || !camera.value.isInitialized) return;
    setState(() => _busy = true);

    final XFile shot;
    try {
      shot = await camera.takePicture();
    } on CameraException catch (error) {
      Toast.error(error.description ?? 'Could not take that photo.');
      if (mounted) setState(() => _busy = false);
      return;
    }

    final file = File(shot.path);
    if (!mounted) return;
    setState(() {
      _lastShot = file;
      _busy = false;
    });

    final keep = await Get.to<bool>(
      () => PhotoPreviewScreen(
        photo: FileImage(file),
        onBack: () => Get.back(result: false),
        onRetake: () => Get.back(result: false),
        onAdd: () => Get.back(result: true),
      ),
    );

    if (keep != true || !mounted) return;
    ProfileSetupController.instance.addPhoto(ProfileSetupPhoto(file));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final camera = _camera;
    return PhotoCameraScreen(
      previewChild: camera == null || !camera.value.isInitialized
          ? null
          : FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: camera.value.previewSize?.height ?? 1,
                height: camera.value.previewSize?.width ?? 1,
                child: CameraPreview(camera),
              ),
            ),
      lastShot: _lastShot == null ? null : FileImage(_lastShot!),
      flashOn: _flash,
      onClose: Get.back,
      onToggleFlash: _toggleFlash,
      onShutter: _busy ? null : _shutter,
      onFlipCamera: _cameras.length < 2 ? null : () => _open(_lens + 1),
      onOpenLibrary: () => Get.off(() => const BubbaPhotoLibraryPage()),
    );
  }
}
