import 'package:flutter/material.dart';
import '../../domain/entities/fixed_asset.dart';

class FilterTabBar extends StatelessWidget {
  final AssetStatus selectedStatus;
  final int approveCount;
  final int pendingCount;
  final int rejectCount;
  final ValueChanged<AssetStatus> onStatusChanged;

  const FilterTabBar({
    super.key,
    required this.selectedStatus,
    required this.approveCount,
    required this.pendingCount,
    required this.rejectCount,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TabChip(
            label: 'All',
            isSelected: selectedStatus == AssetStatus.all,
            onTap: () => onStatusChanged(AssetStatus.all),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Approve',
            count: approveCount,
            countColor: const Color(0xFF2ECC71),
            isSelected: selectedStatus == AssetStatus.approve,
            onTap: () => onStatusChanged(AssetStatus.approve),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Pending',
            count: pendingCount,
            countColor: const Color(0xFFF39C12),
            isSelected: selectedStatus == AssetStatus.pending,
            onTap: () => onStatusChanged(AssetStatus.pending),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Reject',
            count: rejectCount,
            countColor: const Color(0xFFE74C3C),
            isSelected: selectedStatus == AssetStatus.reject,
            onTap: () => onStatusChanged(AssetStatus.reject),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final int? count;
  final Color? countColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    this.count,
    this.countColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2ECC71) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2ECC71)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : (countColor ?? Colors.grey).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected ? Colors.white : (countColor ?? Colors.black87),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
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
