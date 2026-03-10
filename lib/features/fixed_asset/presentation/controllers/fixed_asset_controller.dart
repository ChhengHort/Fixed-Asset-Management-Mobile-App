
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/use_case.dart';
import '../../data/models/fixed_asset_model.dart';
import '../../domain/entities/fixed_asset.dart';
import '../../domain/usecases/fixed_asset_usecases.dart';

enum ListState { initial, loading, loadingMore, loaded, error, empty }

class FixedAssetController extends ChangeNotifier {
  final GetAssetsUseCase getAssetsUseCase;
  final GetStatusCountsUseCase getStatusCountsUseCase;
  final GetAssetByIdUseCase getAssetByIdUseCase;

  // ── State ────────────────────────────────────────────────────────────────
  ListState _state = ListState.initial;
  List<FixedAsset> _assets = [];
  AssetStatusCount? _statusCounts;
  AssetPagination? _pagination;
  String? _errorMessage;

  // ── Filter / search ──────────────────────────────────────────────────────
  AssetStatus _selectedStatus = AssetStatus.all;
  String _searchQuery = '';
  int _currentPage = 1;
  static const int _perPage = 10;

  // ── Search debounce ──────────────────────────────────────────────────────
  Timer? _debounce;

  FixedAssetController({
    required this.getAssetsUseCase,
    required this.getStatusCountsUseCase,
    required this.getAssetByIdUseCase,
  });

  // ── Getters ──────────────────────────────────────────────────────────────
  ListState get state => _state;
  List<FixedAsset> get assets => _assets;
  AssetStatusCount? get statusCounts => _statusCounts;
  AssetPagination? get pagination => _pagination;
  String? get errorMessage => _errorMessage;
  AssetStatus get selectedStatus => _selectedStatus;
  String get searchQuery => _searchQuery;
  bool get isLoading => _state == ListState.loading;
  bool get isLoadingMore => _state == ListState.loadingMore;
  bool get hasMore => _pagination?.hasNextPage ?? false;
  int get totalCount => _pagination?.totalCount ?? 0;
  int get fromCount => _pagination?.from ?? 0;
  int get toCount => _pagination?.to ?? 0;

  // ── Init ─────────────────────────────────────────────────────────────────
  Future<void> init() async {
    await Future.wait([loadAssets(reset: true), loadStatusCounts()]);
  }

  // ── Load status counts ───────────────────────────────────────────────────
  Future<void> loadStatusCounts() async {
    final result = await getStatusCountsUseCase(const NoParams());
    result.fold((_) {}, (counts) {
      _statusCounts = counts;
      notifyListeners();
    });
  }

  // ── Load assets ──────────────────────────────────────────────────────────
  Future<void> loadAssets({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _assets = [];
      _state = ListState.loading;
      notifyListeners();
    } else {
      if (_state == ListState.loadingMore) return;
      _state = ListState.loadingMore;
      notifyListeners();
    }

    final result = await getAssetsUseCase(
      GetAssetsParams(
        page: _currentPage,
        perPage: _perPage,
        status: _selectedStatus == AssetStatus.all ? null : _selectedStatus,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = _assets.isEmpty ? ListState.error : ListState.loaded;
      },
      (pagination) {
        _pagination = pagination;
        if (reset) {
          _assets = List.from(pagination.assets);
        } else {
          _assets = [..._assets, ...pagination.assets];
        }
        _state = _assets.isEmpty ? ListState.empty : ListState.loaded;
        _currentPage++;
      },
    );

    notifyListeners();
  }

  // ── Load more (infinite scroll) ──────────────────────────────────────────
  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;
    await loadAssets();
  }

  // ── Select status filter ─────────────────────────────────────────────────
  Future<void> selectStatus(AssetStatus status) async {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    notifyListeners();
    await loadAssets(reset: true);
  }

  // ── Search ───────────────────────────────────────────────────────────────
  void onSearchChanged(String query) {
    _debounce?.cancel();
    _searchQuery = query;
    _debounce = Timer(const Duration(milliseconds: 400), () {
      loadAssets(reset: true);
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    _searchQuery = '';
    loadAssets(reset: true);
  }

  // ── Refresh ──────────────────────────────────────────────────────────────
  Future<void> refresh() async {
    await Future.wait([loadAssets(reset: true), loadStatusCounts()]);
  }

  // ── Find asset by id ─────────────────────────────────────────────────────
  FixedAsset? findById(String id) {
    try {
      return _assets.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Update single asset status ────────────────────────────────────────────
  // Strategy:
  //   1. Optimistically update the item in _assets so the detail screen
  //      badge flips instantly (good UX, no visible delay).
  //   2. Persist to the mock store so every future query reflects the change.
  //   3. Reload the list for the active filter tab (so stale items disappear).
  //   4. Reload status counts from the updated mock store (accurate numbers).
  Future<void> updateAssetStatus(String assetId, AssetStatus newStatus) async {
    // ── Step 1: optimistic local update ─────────────────────────────────
    final index = _assets.indexWhere((a) => a.id == assetId);
    if (index != -1) {
      final old = _assets[index];
      _assets[index] = FixedAssetModel(
        id: old.id,
        name: old.name,
        price: old.price,
        code: old.code,
        status: newStatus,
        imageUrl: old.imageUrl,
        category: old.category,
        description: old.description,
        purchaseDate: old.purchaseDate,
        location: old.location,
      );
      notifyListeners(); // detail screen badge flips immediately
    }

    // ── Step 2: persist to mock store ────────────────────────────────────
    // Replace with your real API call here, e.g.:
    //   await updateAssetUseCase(UpdateAssetParams(id: assetId, status: newStatus));
    await _persistStatusToMock(assetId, newStatus);

    // ── Step 3 + 4: reload list AND counts from the updated source ───────
    // This is the only reliable way to get correct counts and a correctly
    // filtered list — calculating from stale in-memory data always drifts.
    await Future.wait([loadAssets(reset: true), loadStatusCounts()]);
  }

  // ── Persist status change into the mock store ─────────────────────────────
  // FixedAssetModel.mockList() generates fresh data each call, so we keep a
  // simple in-memory override map that GetAssetsUseCase / mock repository
  // must consult. If you already have a real API, delete this entire method.
  Future<void> _persistStatusToMock(
    String assetId,
    AssetStatus newStatus,
  ) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 300));
    // Write into the shared mock override store
    MockAssetStore.overrideStatus(assetId, newStatus);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// ── MockAssetStore ─────────────────────────────────────────────────────────────
// A simple singleton that holds status overrides so mock data stays consistent
// across paginated queries after an approve/reject action.
// Delete this class once you connect a real API.
class MockAssetStore {
  MockAssetStore._();

  static final Map<String, AssetStatus> _overrides = {};

  static void overrideStatus(String id, AssetStatus status) {
    _overrides[id] = status;
  }

  static AssetStatus? getOverride(String id) => _overrides[id];

  static void clear() => _overrides.clear();
}
