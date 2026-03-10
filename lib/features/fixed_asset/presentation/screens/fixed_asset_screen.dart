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
import '../../../auth/providers/mock_auth_provider.dart';

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
                    child: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                      size: 26,
                    ),
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
                  return _EmptyState(searchQuery: controller.searchQuery);
                }

                return RefreshIndicator(
                  color: AppTheme.primaryGreen,
                  onRefresh: controller.refresh,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount:
                        controller.assets.length +
                        (controller.isLoadingMore ? 1 : 0) +
                        1,
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
            style: const TextStyle(color: Color(0xFF8A9BB0), fontSize: 13),
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
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
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

// ── Mock UI screen (for design & preview) ─────────────────────────────────
class FixedAssetMockScreen extends StatefulWidget {
  const FixedAssetMockScreen({super.key});

  @override
  State<FixedAssetMockScreen> createState() => _FixedAssetMockScreenState();
}

class _FixedAssetMockScreenState extends State<FixedAssetMockScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_AssetMock> _getFilteredAssets() {
    final query = _searchQuery.toLowerCase();
    return _mockAssets
        .where(
          (asset) =>
              asset.title.toLowerCase().contains(query) &&
              (_selectedStatus == 'All' || asset.status == _selectedStatus),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _getFilteredAssets();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 36, 16, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF18A974), Color(0xFF51D88A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 26),
                const SizedBox(width: 10),
                const Text(
                  'Asset Tech',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 26,
                    ),
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Text(
                          '15',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Consumer<MockAuthProvider>(
                  builder: (context, auth, _) {
                    final name = auth.currentUser?.displayName ?? '';
                    final initials = name.isNotEmpty
                        ? name
                              .split(' ')
                              .map((s) => s.isNotEmpty ? s[0] : '')
                              .take(2)
                              .join()
                        : '';

                    return PopupMenuButton<int>(
                      icon: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Text(
                          initials.isNotEmpty ? initials : 'P',
                          style: const TextStyle(
                            color: Color(0xFF2ECC71),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      onSelected: (v) {
                        if (v == 1) {
                          auth.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(name.isNotEmpty ? name : 'Profile'),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(value: 1, child: Text('Logout')),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: const [
                Icon(Icons.menu, color: Colors.black87, size: 26),
                SizedBox(width: 12),
                Text(
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Color(0xFF99A7B6)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration.collapsed(
                              hintText: 'Search asset name',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchQuery = _searchController.text;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _StatusTab(
                  label: 'All',
                  count: null,
                  active: _selectedStatus == 'All',
                  onTap: () => setState(() => _selectedStatus = 'All'),
                ),
                const SizedBox(width: 8),
                _StatusTab(
                  label: 'Approve',
                  count: 12,
                  active: _selectedStatus == 'Approve',
                  onTap: () => setState(() => _selectedStatus = 'Approve'),
                ),
                const SizedBox(width: 8),
                _StatusTab(
                  label: 'Pending',
                  count: 5,
                  active: _selectedStatus == 'Pending',
                  onTap: () => setState(() => _selectedStatus = 'Pending'),
                ),
                const SizedBox(width: 8),
                _StatusTab(
                  label: 'Reject',
                  count: 2,
                  active: _selectedStatus == 'Reject',
                  onTap: () => setState(() => _selectedStatus = 'Reject'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'No assets match "$_searchQuery"'
                          : 'No assets found for this status',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: filteredItems.length + 1,
                    itemBuilder: (ctx, i) {
                      if (i == filteredItems.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Center(
                            child: Text(
                              'Showing 1 to ${filteredItems.length} of ${_mockAssets.length} entities',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        );
                      }

                      final a = filteredItems[i];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/asset-detail',
                            arguments: a,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(
                                    a.icon,
                                    size: 28,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              a.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _statusColor(
                                                a.status,
                                              ).withOpacity(0.12),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              a.status,
                                              style: TextStyle(
                                                color: _statusColor(a.status),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        a.price,
                                        style: const TextStyle(
                                          color: Color(0xFFE94B4B),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        a.code,
                                        style: const TextStyle(
                                          color: Color(0xFF9AA9B8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

class _StatusTab extends StatelessWidget {
  final String label;
  final int? count;
  final bool active;
  final VoidCallback? onTap;
  const _StatusTab({
    required this.label,
    this.count,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : const Color(0xFF4B5563),
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Color(0xFF2ECC71),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AssetMock {
  final int id;
  final String title;
  final String price;
  final String code;
  final String status;
  final IconData icon;
  const _AssetMock({
    required this.id,
    required this.title,
    required this.price,
    required this.code,
    required this.status,
    required this.icon,
  });
}

final List<_AssetMock> _mockAssets = [
  _AssetMock(
    id: 1,
    title: 'MacBook Pro',
    price: '1,200\$',
    code: 'UPGP-009-hello-2025-009-00002',
    status: 'Approve',
    icon: Icons.laptop_mac,
  ),
  _AssetMock(
    id: 2,
    title: 'Dell Monitor',
    price: '350\$',
    code: 'UPGP-010-dell-2025-010-00003',
    status: 'Pending',
    icon: Icons.monitor,
  ),
  _AssetMock(
    id: 3,
    title: 'Logitech Keyboard',
    price: '120\$',
    code: 'UPGP-011-logitech-2025-011-00004',
    status: 'Approve',
    icon: Icons.keyboard,
  ),
  _AssetMock(
    id: 4,
    title: 'Canon Printer',
    price: '450\$',
    code: 'UPGP-012-canon-2025-012-00005',
    status: 'Reject',
    icon: Icons.print,
  ),
  _AssetMock(
    id: 5,
    title: 'Microsoft Office Chair',
    price: '280\$',
    code: 'UPGP-013-office-2025-013-00006',
    status: 'Approve',
    icon: Icons.event_seat,
  ),
  _AssetMock(
    id: 6,
    title: 'HP Scanner',
    price: '200\$',
    code: 'UPGP-014-hp-2025-014-00007',
    status: 'Pending',
    icon: Icons.image_search,
  ),
  _AssetMock(
    id: 7,
    title: 'Apple iMac',
    price: '1,500\$',
    code: 'UPGP-015-imac-2025-015-00008',
    status: 'Approve',
    icon: Icons.desktop_mac,
  ),
];

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approve':
      return const Color(0xFF27AE60);
    case 'pending':
      return const Color(0xFFF3C623);
    case 'reject':
      return const Color(0xFFE53935);
    default:
      return Colors.grey;
  }
}
