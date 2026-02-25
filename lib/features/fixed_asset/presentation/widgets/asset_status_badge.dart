import 'package:flutter/material.dart';
import '../../domain/entities/fixed_asset.dart';

class AssetStatusBadge extends StatelessWidget {
  final AssetStatus status;
  final double? fontSize;

  const AssetStatusBadge({super.key, required this.status, this.fontSize});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          color: config.textColor,
          fontSize: fontSize ?? 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  _BadgeConfig _getConfig(AssetStatus status) {
    switch (status) {
      case AssetStatus.approve:
        return _BadgeConfig(
          label: 'Approve',
          background: const Color(0xFF2ECC71),
          textColor: Colors.white,
        );
      case AssetStatus.pending:
        return _BadgeConfig(
          label: 'Pending',
          background: const Color(0xFFF39C12),
          textColor: Colors.white,
        );
      case AssetStatus.reject:
        return _BadgeConfig(
          label: 'Reject',
          background: const Color(0xFFE74C3C),
          textColor: Colors.white,
        );
      default:
        return _BadgeConfig(
          label: 'Unknown',
          background: Colors.grey.shade300,
          textColor: Colors.grey.shade700,
        );
    }
  }
}

class _BadgeConfig {
  final String label;
  final Color background;
  final Color textColor;
  _BadgeConfig({
    required this.label,
    required this.background,
    required this.textColor,
  });
}
