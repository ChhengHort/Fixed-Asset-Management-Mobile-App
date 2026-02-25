import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../core/utils/use_case.dart';
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
    await Future.wait([
      loadAssets(reset: true),
      loadStatusCounts(),
    ]);
  }

  // ── Load status counts ───────────────────────────────────────────────────
  Future<void> loadStatusCounts() async {
    final result = await getStatusCountsUseCase(const NoParams());
    result.fold(
      (_) {},
      (counts) {
        _statusCounts = counts;
        notifyListeners();
      },
    );
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

    final result = await getAssetsUseCase(GetAssetsParams(
      page: _currentPage,
      perPage: _perPage,
      status: _selectedStatus == AssetStatus.all ? null : _selectedStatus,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
    ));

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
    await Future.wait([
      loadAssets(reset: true),
      loadStatusCounts(),
    ]);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
