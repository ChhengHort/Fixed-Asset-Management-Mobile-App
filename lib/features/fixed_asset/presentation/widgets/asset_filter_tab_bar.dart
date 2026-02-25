import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/fixed_asset.dart';

class AssetFilterTabBar extends StatelessWidget {
  final AssetStatus selectedFilter;
  final Map<AssetStatus, int> counts;
  final ValueChanged<AssetStatus> onFilterChanged;

  const AssetFilterTabBar({
    super.key,
    required this.selectedFilter,
    required this.counts,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterTab(
            label: 'All',
            count: null,
            isSelected: selectedFilter == AssetStatus.all,
            onTap: () => onFilterChanged(AssetStatus.all),
          ),
          const SizedBox(width: 8),
          _FilterTab(
            label: 'Approve',
            count: counts[AssetStatus.approve],
            isSelected: selectedFilter == AssetStatus.approve,
            onTap: () => onFilterChanged(AssetStatus.approve),
            countColor: AppTheme.primaryGreen,
          ),
          const SizedBox(width: 8),
          _FilterTab(
            label: 'Pending',
            count: counts[AssetStatus.pending],
            isSelected: selectedFilter == AssetStatus.pending,
            onTap: () => onFilterChanged(AssetStatus.pending),
            countColor: AppTheme.accentYellow,
          ),
          const SizedBox(width: 8),
          _FilterTab(
            label: 'Reject',
            count: counts[AssetStatus.reject],
            isSelected: selectedFilter == AssetStatus.reject,
            onTap: () => onFilterChanged(AssetStatus.reject),
            countColor: AppTheme.accentRed,
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? countColor;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
    this.countColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : AppTheme.borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : (countColor ?? AppTheme.primaryGreen).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (countColor ?? AppTheme.primaryGreen),
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
