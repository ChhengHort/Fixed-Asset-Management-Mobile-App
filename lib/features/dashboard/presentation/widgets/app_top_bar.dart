import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const AppTopBar({
    super.key,
    this.notificationCount = 0,
    this.avatarUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Image.asset(
                    "../assets/images/logos2.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Asset Tech',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Notification Bell
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: onNotificationTap,
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 4),
              // Avatar with dropdown menu (logout)
              PopupMenuButton<String>(
                onSelected: (val) async {
                  if (val == 'logout') {
                    final controller = context.read<AuthController>();
                    await controller.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppConstants.loginRoute,
                      (r) => false,
                    );
                  }
                },
                color: Colors.white,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: avatarUrl != null
                        ? Image.network(avatarUrl!, fit: BoxFit.cover)
                        : Container(
                            color: Colors.white.withOpacity(0.3),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
