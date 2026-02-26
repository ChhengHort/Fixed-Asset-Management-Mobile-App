import 'package:asset_tech/core/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/stat_card.dart';

// final GlobalKey<ScaffoldState> appScaffoldKey = GlobalKey<ScaffoldState>();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      drawer: const AppDrawer(),
      appBar: AppTopBar(
        notificationCount: 15,
        avatarUrl: authController.user?.avatarUrl,
        onNotificationTap: () {
          // Navigate to notifications
        },
        onProfileTap: () {
          Navigator.pushNamed(context, AppConstants.profileRoute);
        },
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryGreen,
        onRefresh: () => context.read<DashboardController>().refresh(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      children: [
                        Builder(
                          builder: (ctx) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black87),
                            onPressed: () => Scaffold.of(ctx).openDrawer(),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Dashboard',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid
                    Consumer<DashboardController>(
                      builder: (_, controller, __) {
                        if (controller.isLoading) {
                          return _buildShimmerGrid();
                        }

                        if (controller.stats == null) {
                          return _buildErrorState(controller);
                        }

                        final s = controller.stats!;
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: 'Fixed Assete',
                                    amount: s.fixedAssetTotal,
                                    count: s.fixedAssetCount,
                                    dotColor: AppTheme.primaryGreen,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: StatCard(
                                    title: 'Expendable',
                                    amount: s.expendableTotal,
                                    count: s.expendableCount,
                                    dotColor: AppTheme.accentYellow,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: 'Stationery',
                                    amount: s.stationeryTotal,
                                    count: s.stationeryCount,
                                    dotColor: AppTheme.accentBlue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: StatCard(
                                    title: 'Total Expense',
                                    amount: s.totalExpense,
                                    count: s.totalExpenseCount,
                                    dotColor: AppTheme.accentRed,
                                    badgeLabel: s.totalExpenseMonth,
                                    badgeColor: AppTheme.accentRed,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Analytics Chart
                    Consumer<DashboardController>(
                      builder: (_, controller, __) {
                        if (controller.isLoading) {
                          return _buildShimmerChart();
                        }
                        return AnalyticsChart(
                          data: controller.analyticsData,
                          selectedYear: controller.selectedYear,
                          onYearChanged: controller.changeYear,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white30,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 8),
                Consumer<AuthController>(
                  builder: (_, auth, __) => Text(
                    auth.user?.fullName ?? auth.user?.username ?? 'User',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.inventory_2_outlined,
            label: 'Fixed Assets',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.assetsRoute);
            },
          ),
          _DrawerItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Expendable',
            onTap: () {},
          ),
          _DrawerItem(icon: Icons.edit_note, label: 'Stationery', onTap: () {}),
          _DrawerItem(icon: Icons.bar_chart, label: 'Reports', onTap: () {}),
          const Divider(),
          _DrawerItem(
            icon: Icons.logout,
            label: 'Logout',
            onTap: () async {
              await context.read<AuthController>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(
                  context,
                  AppConstants.loginRoute,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            children: List.generate(
              2,
              (_) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              2,
              (_) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerChart() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildErrorState(DashboardController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppTheme.accentRed,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage ?? 'Failed to load data',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.darkGreen),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryGreen : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryGreen : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
