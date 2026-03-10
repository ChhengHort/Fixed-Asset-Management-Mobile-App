import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/fixed_asset.dart';
import '../controllers/fixed_asset_controller.dart';
import '../widgets/asset_status_badge.dart';

class FixedAssetDetailScreen extends StatefulWidget {
  final FixedAsset asset;

  const FixedAssetDetailScreen({super.key, required this.asset});

  @override
  State<FixedAssetDetailScreen> createState() => _FixedAssetDetailScreenState();
}

class _FixedAssetDetailScreenState extends State<FixedAssetDetailScreen> {
  bool _isUpdating = false;

  FixedAsset _liveAsset(FixedAssetController controller) =>
      controller.findById(widget.asset.id) ?? widget.asset;

  Future<void> _applyStatus(
    BuildContext context,
    AssetStatus newStatus,
    FixedAssetController controller,
  ) async {
    setState(() => _isUpdating = true);
    await controller.updateAssetStatus(widget.asset.id, newStatus);
    setState(() => _isUpdating = false);

    if (!mounted) return;

    final isApprove = newStatus == AssetStatus.approve;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isApprove ? 'Asset has been approved' : 'Asset has been rejected',
        ),
        backgroundColor: isApprove ? AppTheme.primaryGreen : AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    AssetStatus newStatus,
    FixedAssetController controller,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          newStatus == AssetStatus.approve ? 'Approve Asset' : 'Reject Asset',
        ),
        content: Text(
          'Are you sure you want to ${newStatus.label.toLowerCase()} "${widget.asset.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              _applyStatus(context, newStatus, controller);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == AssetStatus.approve
                  ? AppTheme.primaryGreen
                  : AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(newStatus.label),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FixedAssetController>(
      builder: (context, controller, _) {
        final asset = _liveAsset(controller);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBackground,
          body: CustomScrollView(
            slivers: [
              // ── App Bar — bigger image (expandedHeight: 340) ─────────────
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                backgroundColor: AppTheme.darkGreen,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () => _showOptions(context),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                        ),
                      ),
                      // ✅ Much bigger image: 220×220
                      Center(
                        child: Hero(
                          tag: 'asset_${asset.id}',
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: asset.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(22),
                                    child: Image.network(
                                      asset.imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.laptop_mac_outlined,
                                    size: 90,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ──────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Name + Status badge (ONE badge, here only) ───────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${asset.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ✅ Single status badge — only here, removed from detail card
                          AssetStatusBadge(status: asset.status, fontSize: 14),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Details Card — NO status row ─────────────────────
                      _DetailCard(
                        children: [
                          _DetailRow(
                            icon: Icons.qr_code,
                            label: 'Asset Code',
                            value: asset.code,
                          ),
                          if (asset.category != null) ...[
                            _Divider(),
                            _DetailRow(
                              icon: Icons.category_outlined,
                              label: 'Category',
                              value: asset.category!,
                            ),
                          ],
                          if (asset.location != null) ...[
                            _Divider(),
                            _DetailRow(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: asset.location!,
                            ),
                          ],
                          if (asset.purchaseDate != null) ...[
                            _Divider(),
                            _DetailRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'Purchase Date',
                              value:
                                  '${asset.purchaseDate!.day}/${asset.purchaseDate!.month}/${asset.purchaseDate!.year}',
                            ),
                          ],
                          // ✅ Status row removed — badge is already shown above
                        ],
                      ),

                      if (asset.description != null) ...[
                        const SizedBox(height: 16),
                        _DetailCard(
                          title: 'Description',
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                              child: Text(
                                asset.description!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  height: 1.6,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          bottomNavigationBar: _buildActionBar(context, asset, controller),
        );
      },
    );
  }

  Widget _buildActionBar(
    BuildContext context,
    FixedAsset asset,
    FixedAssetController controller,
  ) {
    if (asset.status != AssetStatus.pending) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: _isUpdating
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(color: AppTheme.primaryGreen),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _confirmAction(context, AssetStatus.reject, controller),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.accentRed,
                      side: const BorderSide(color: AppTheme.accentRed),
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmAction(
                      context,
                      AssetStatus.approve,
                      controller,
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                  color: AppTheme.primaryGreen,
                ),
                title: const Text('Edit Asset'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppTheme.accentRed,
                ),
                title: const Text(
                  'Delete Asset',
                  style: TextStyle(color: AppTheme.accentRed),
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFEEF1F5),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  const _DetailCard({required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? valueWidget;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const Spacer(),
          valueWidget ??
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

