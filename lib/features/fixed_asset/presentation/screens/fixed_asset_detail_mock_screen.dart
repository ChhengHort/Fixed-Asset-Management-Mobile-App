import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/providers/mock_auth_provider.dart';

// This screen uses the _AssetMock model from fixed_asset_screen.dart
// We declare it here as a stub for type safety in navigation

// Asset model is passed dynamically from fixed_asset_screen.dart
// No need for duplicate class definition

class FixedAssetDetailMockScreen extends StatefulWidget {
  final dynamic asset; // _AssetMock from fixed_asset_screen.dart

  const FixedAssetDetailMockScreen({super.key, required this.asset});

  @override
  State<FixedAssetDetailMockScreen> createState() =>
      _FixedAssetDetailMockScreenState();
}

class _FixedAssetDetailMockScreenState
    extends State<FixedAssetDetailMockScreen> {
  late String _selectedStatus;
  int _currentImageIndex = 0;
  String? _approvedBy;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.asset.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── App Bar with header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: const Color(0xFF18A974),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Consumer<MockAuthProvider>(
                builder: (context, authProvider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PopupMenuButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text('Logout'),
                          onTap: () {
                            authProvider?.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Detail',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // ── Product Image Gallery ────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        widget.asset.icon,
                        size: 140,
                        color: const Color(0xFF18A974),
                      ),
                    ),
                  ),
                  // Thumbnail carousel
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _currentImageIndex = (_currentImageIndex - 1)
                                .clamp(0, 5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.navigate_before, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Thumbnail grid
                        SizedBox(
                          width: 120,
                          height: 60,
                          child: GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            children: List.generate(
                              3,
                              (i) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentImageIndex == i
                                        ? const Color(0xFF18A974)
                                        : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Icon(
                                  widget.asset.icon,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => setState(
                            () => _currentImageIndex = (_currentImageIndex + 1)
                                .clamp(0, 5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.navigate_next, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Asset Information ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asset Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2ECC71),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                      label: 'Asset ID',
                      value: widget.asset.id.toString(),
                    ),
                    _InfoRow(label: 'Asset Code', value: widget.asset.code),
                    _InfoRow(label: 'Registration Date', value: '31-07-2027'),
                    _InfoRow(
                      label: 'Asset Name (EN)',
                      value: widget.asset.title,
                    ),
                    _InfoRow(label: 'Category', value: 'Computer'),
                    _InfoRow(label: 'Sub Category', value: 'Laptop'),
                    _InfoRow(label: 'Brand', value: 'Apple'),
                    _InfoRow(
                      label: 'Depreciation Start Date',
                      value: '31-07-2027',
                    ),
                    _InfoRow(label: 'Location', value: 'Phnom Penh'),
                    const Divider(height: 24),
                    _InfoRow(label: 'Vendor', value: 'Koh Heang'),
                    _InfoRow(
                      label: 'Asset Name (KH)',
                      value: 'កុំព្យូទ័រ ដែលលម្អិត',
                    ),
                    _InfoRow(
                      label: 'Acquisition Cost',
                      value: widget.asset.price,
                    ),
                    _InfoRow(
                      label: 'Depreciation Method',
                      value: 'STRAIGHT-LINE',
                    ),
                    _InfoRow(
                      label: 'Depreciation Cycle',
                      value: 'FINANCIAL-YEAR',
                    ),
                    _InfoRow(label: 'Usage Life', value: '5 Years'),
                    _InfoRow(
                      label: 'Approved By',
                      value: _approvedBy ?? 'Pending Approval',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Select Status ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2ECC71),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedStatus = 'Approve'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedStatus == 'Approve'
                                    ? const Color(0xFF27AE60)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: _selectedStatus == 'Approve'
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Approve',
                                    style: TextStyle(
                                      color: _selectedStatus == 'Approve'
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedStatus = 'Reject'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedStatus == 'Reject'
                                    ? const Color(0xFFE53935)
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: _selectedStatus == 'Reject'
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Reject',
                                    style: TextStyle(
                                      color: _selectedStatus == 'Reject'
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Submit Button ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer<MockAuthProvider>(
                builder: (context, authProvider, _) {
                  return ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => _submitApproval(authProvider, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedStatus == 'Approve'
                          ? const Color(0xFF27AE60)
                          : const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            _selectedStatus == 'Approve'
                                ? 'Approve Asset'
                                : 'Reject Asset',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),

          // ── Attachments ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2ECC71),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _AttachmentItem(
                      title: 'Purchase Invoice',
                      fileName: 'INV-0041234-07-71431.pdf',
                    ),
                    const SizedBox(height: 12),
                    _AttachmentItem(
                      title: 'Purchase Invoice',
                      fileName: 'INV-0041234-07-71431.pdf',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Action Buttons ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE53935)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }

  Future<void> _submitApproval(
    MockAuthProvider authProvider,
    BuildContext context,
  ) async {
    setState(() => _isSubmitting = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _approvedBy = authProvider.approverName;
      _isSubmitting = false;
    });

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Asset ${_selectedStatus.toLowerCase()} successfully!\nApproved by: ${authProvider.approverName}',
        ),
        backgroundColor: _selectedStatus == 'Approve'
            ? const Color(0xFF27AE60)
            : const Color(0xFFE53935),
        duration: const Duration(seconds: 2),
      ),
    );

    // Go back to assets list after 1 second
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF565D6B), fontSize: 13),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(color: Color(0xFF565D6B), fontSize: 13),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final String title;
  final String fileName;

  const _AttachmentItem({required this.title, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2ECC71)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.description,
              color: Color(0xFF2ECC71),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9AA9B8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.visibility, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 6),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.download, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }
}
