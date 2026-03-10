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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/myPF.jpg'),
                ),
                const SizedBox(width: 8),
                Consumer<AuthController>(
                  builder: (_, auth, __) => RichText(
                    text: TextSpan(
                      text:
                          auth.user?.fullName ??
                          auth.user?.username ??
                          'Eang Chhenghort',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                      children: const [
                        TextSpan(
                          text: '\nView Profile',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
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
