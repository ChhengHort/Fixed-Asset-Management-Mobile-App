// import 'package:flutter/material.dart';
// // import '../../../../core/theme/app_theme.dart';
// import '../../domain/entities/fixed_asset.dart';
// import '../widgets/status_badge.dart';

// class AssetDetailScreen extends StatelessWidget {
//   final FixedAsset asset;

//   const AssetDetailScreen({super.key, required this.asset});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black87,
//             size: 20,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Asset Detail',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: 17,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.black87),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Hero image card ────────────────────────────────────────
//             Container(
//               width: double.infinity,
//               height: 220,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFE8ECF0)),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: asset.imageUrl != null
//                     ? Image.network(asset.imageUrl!, fit: BoxFit.cover)
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.laptop_mac,
//                             size: 80,
//                             color: Colors.grey.shade300,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             asset.name,
//                             style: TextStyle(
//                               color: Colors.grey.shade400,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ── Info card ──────────────────────────────────────────────
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: const Color(0xFFE8ECF0)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           asset.name,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       StatusBadge(status: asset.status, fontSize: 13),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     '\$${asset.price.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       color: Color(0xFF2ECC71),
//                       fontWeight: FontWeight.w700,
//                       fontSize: 22,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(height: 1, color: Color(0xFFE8ECF0)),
//                   const SizedBox(height: 16),
//                   _DetailRow(label: 'Asset Code', value: asset.code),
//                   if (asset.category != null)
//                     _DetailRow(label: 'Category', value: asset.category!),
//                   if (asset.location != null)
//                     _DetailRow(label: 'Location', value: asset.location!),
//                   if (asset.purchaseDate != null)
//                     _DetailRow(
//                       label: 'Purchase Date',
//                       value:
//                           '${asset.purchaseDate!.day}/${asset.purchaseDate!.month}/${asset.purchaseDate!.year}',
//                     ),
//                   if (asset.description != null) ...[
//                     const SizedBox(height: 12),
//                     const Text(
//                       'Description',
//                       style: TextStyle(
//                         color: Color(0xFF8A9BB0),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       asset.description!,
//                       style: const TextStyle(
//                         color: Colors.black87,
//                         fontSize: 14,
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),

//             // ── Action buttons ─────────────────────────────────────────
//             if (asset.status == AssetStatus.pending) ...[
//               Row(
//                 children: [
//                   Expanded(
//                     child: _ActionButton(
//                       label: 'Approve',
//                       icon: Icons.check_circle_outline,
//                       color: const Color(0xFF2ECC71),
//                       onTap: () {},
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _ActionButton(
//                       label: 'Reject',
//                       icon: Icons.cancel_outlined,
//                       color: const Color(0xFFE74C3C),
//                       onTap: () {},
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DetailRow extends StatelessWidget {
//   final String label;
//   final String value;
//   const _DetailRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 110,
//             child: Text(
//               label,
//               style: const TextStyle(color: Color(0xFF8A9BB0), fontSize: 13),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 color: Colors.black87,
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ActionButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onTap;
//   const _ActionButton({
//     required this.label,
//     required this.icon,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 52,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: color.withOpacity(0.3),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../domain/entities/fixed_asset.dart';
import '../widgets/status_badge.dart';

class AssetDetailScreen extends StatefulWidget {
  final FixedAsset asset;

  const AssetDetailScreen({super.key, required this.asset});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  late AssetStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.asset.status;
  }

  void _handleApprove() {
    setState(() {
      _currentStatus = AssetStatus.approved;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asset has been approved'),
        backgroundColor: Color(0xFF2ECC71),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleReject() {
    setState(() {
      _currentStatus = AssetStatus.rejected;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asset has been rejected'),
        backgroundColor: Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Asset Detail',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image card ────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.asset.imageUrl != null
                    ? Image.network(widget.asset.imageUrl!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.laptop_mac,
                            size: 80,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.asset.name,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Info card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.asset.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      StatusBadge(status: _currentStatus, fontSize: 13),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${widget.asset.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFE8ECF0)),
                  const SizedBox(height: 16),
                  _DetailRow(label: 'Asset Code', value: widget.asset.code),
                  if (widget.asset.category != null)
                    _DetailRow(
                      label: 'Category',
                      value: widget.asset.category!,
                    ),
                  if (widget.asset.location != null)
                    _DetailRow(
                      label: 'Location',
                      value: widget.asset.location!,
                    ),
                  if (widget.asset.purchaseDate != null)
                    _DetailRow(
                      label: 'Purchase Date',
                      value:
                          '${widget.asset.purchaseDate!.day}/${widget.asset.purchaseDate!.month}/${widget.asset.purchaseDate!.year}',
                    ),
                  if (widget.asset.description != null) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Color(0xFF8A9BB0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.asset.description!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Action buttons ─────────────────────────────────────────
            if (_currentStatus == AssetStatus.pending) ...[
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Approve',
                      icon: Icons.check_circle_outline,
                      color: const Color(0xFF2ECC71),
                      onTap: _handleApprove,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      label: 'Reject',
                      icon: Icons.cancel_outlined,
                      color: const Color(0xFFE74C3C),
                      onTap: _handleReject,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ... _DetailRow and _ActionButton remain unchanged
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF8A9BB0), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
