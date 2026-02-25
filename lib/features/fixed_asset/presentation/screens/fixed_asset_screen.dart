import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../dashboard/presentation/widgets/app_top_bar.dart';
import '../controllers/fixed_asset_controller.dart';
import '../widgets/asset_list_item.dart';
import '../widgets/filter_tab_bar.dart';
import '../widgets/search_bar_widget.dart';
import 'asset_detail_screen.dart';

class FixedAssetScreen extends StatefulWidget {
  const FixedAssetScreen({super.key});

  @override
  State<FixedAssetScreen> createState() => _FixedAssetScreenState();
}

class _FixedAssetScreenState extends State<FixedAssetScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FixedAssetController>().init();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FixedAssetController>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const AppTopBar(notificationCount: 15),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page title ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: () => Scaffold.of(ctx).openDrawer(),
                    child: const Icon(Icons.menu, color: Colors.black87, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'Fixed Asset',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2ECC71),
                  ),
                ),
              ],
            ),
          ),

          // ── Search bar ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<FixedAssetController>(
              builder: (_, controller, __) {
                return AssetSearchBar(
                  initialValue: controller.searchQuery,
                  onChanged: controller.onSearchChanged,
                  onClear: controller.clearSearch,
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // ── Filter tabs ────────────────────────────────────────────────
          Consumer<FixedAssetController>(
            builder: (_, controller, __) {
              return FilterTabBar(
                selectedStatus: controller.selectedStatus,
                approveCount: controller.statusCounts?.approveCount ?? 0,
                pendingCount: controller.statusCounts?.pendingCount ?? 0,
                rejectCount: controller.statusCounts?.rejectCount ?? 0,
                onStatusChanged: controller.selectStatus,
              );
            },
          ),

          const SizedBox(height: 12),

          // ── Asset list ─────────────────────────────────────────────────
          Expanded(
            child: Consumer<FixedAssetController>(
              builder: (_, controller, __) {
                if (controller.isLoading) {
                  return _ShimmerList();
                }

                if (controller.state == ListState.error) {
                  return _ErrorState(
                    message: controller.errorMessage ?? 'Something went wrong',
                    onRetry: controller.refresh,
                  );
                }

                if (controller.state == ListState.empty) {
                  return _EmptyState(
                    searchQuery: controller.searchQuery,
                  );
                }

                return RefreshIndicator(
                  color: AppTheme.primaryGreen,
                  onRefresh: controller.refresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount:
                        controller.assets.length + (controller.isLoadingMore ? 1 : 0) + 1,
                    itemBuilder: (ctx, i) {
                      // Footer: pagination info + load-more spinner
                      if (i == controller.assets.length) {
                        return _ListFooter(controller: controller);
                      }

                      // Load-more spinner at end
                      if (i > controller.assets.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                        );
                      }

                      final asset = controller.assets[i];
                      return AssetListItem(
                        asset: asset,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: controller,
                              child: AssetDetailScreen(asset: asset),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── List footer ───────────────────────────────────────────────────────────────
class _ListFooter extends StatelessWidget {
  final FixedAssetController controller;
  const _ListFooter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Text(
            controller.totalCount == 0
                ? 'No entities found'
                : 'Showing ${controller.fromCount} to ${controller.toCount} of ${controller.totalCount} entities',
            style: const TextStyle(
              color: Color(0xFF8A9BB0),
              fontSize: 13,
            ),
          ),
          if (controller.isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Shimmer loading list ──────────────────────────────────────────────────────
class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.only(top: 4),
        itemBuilder: (_, __) => const AssetListItemShimmer(),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(140, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String searchQuery;
  const _EmptyState({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FAF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 52,
                color: Color(0xFF2ECC71),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              searchQuery.isNotEmpty
                  ? 'No results for "$searchQuery"'
                  : 'No assets found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try adjusting your filters or search query',
              style: TextStyle(color: Color(0xFF8A9BB0), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
