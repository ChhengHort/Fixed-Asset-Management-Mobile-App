import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.dashboardRoute);
            },
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
                Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
              }
            },
          ),
        ],
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