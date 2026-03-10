import 'package:flutter/foundation.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../data/models/fixed_asset_model.dart';

class FixedAssetProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────
  List<FixedAsset> _assets = [];
  bool _isLoading = false;
  String? _error;

  // ── Getters ────────────────────────────────────────────────────────────
  List<FixedAsset> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ── Init / Load ────────────────────────────────────────────────────────
  Future<void> loadAssets({
    int page = 1,
    int perPage = 10,
    AssetStatus? status,
    String? query,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));

      final pagination = AssetPaginationModel.mock(
        page: page,
        perPage: perPage,
        status: status,
        query: query,
      );
      _assets = pagination.assets;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Update status ──────────────────────────────────────────────────────
  Future<void> updateStatus(String assetId, AssetStatus newStatus) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _assets.indexWhere((a) => a.id == assetId);
    if (index == -1) return;

    final old = _assets[index];

    // Replace with updated model (FixedAsset is immutable)
    _assets[index] = FixedAssetModel(
      id: old.id,
      name: old.name,
      price: old.price,
      code: old.code,
      status: newStatus,          // ← only this changes
      imageUrl: old.imageUrl,
      category: old.category,
      description: old.description,
      purchaseDate: old.purchaseDate,
      location: old.location,
    );

    notifyListeners();
  }

  // ── Convenience helpers ────────────────────────────────────────────────
  Future<void> approveAsset(String assetId) =>
      updateStatus(assetId, AssetStatus.approve);

  Future<void> rejectAsset(String assetId) =>
      updateStatus(assetId, AssetStatus.reject);

  /// Returns the latest copy of an asset by id (useful after navigation).
  FixedAsset? findById(String id) {
    try {
      return _assets.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}