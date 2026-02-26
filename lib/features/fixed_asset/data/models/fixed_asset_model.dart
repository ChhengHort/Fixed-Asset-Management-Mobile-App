import '../../domain/entities/fixed_asset.dart';

class FixedAssetModel extends FixedAsset {
  const FixedAssetModel({
    required super.id,
    required super.name,
    required super.price,
    required super.code,
    required super.status,
    super.imageUrl,
    super.category,
    super.description,
    super.purchaseDate,
    super.location,
  });

  factory FixedAssetModel.fromJson(Map<String, dynamic> json) {
    return FixedAssetModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      code: json['code'] ?? '',
      status: _parseStatus(json['status']),
      imageUrl: json['image_url'] ?? json['imageUrl'],
      category: json['category'],
      description: json['description'],
      purchaseDate: json['purchase_date'] != null
          ? DateTime.tryParse(json['purchase_date'])
          : null,
      location: json['location'],
    );
  }

  static AssetStatus _parseStatus(dynamic raw) {
    switch (raw?.toString().toLowerCase()) {
      case 'approve':
        return AssetStatus.approve;
      case 'pending':
        return AssetStatus.pending;
      case 'reject':
        return AssetStatus.reject;
      default:
        return AssetStatus.pending;
    }
  }

  // ── Mock data generator ──────────────────────────────────────────────────
  static List<FixedAssetModel> mockList(
    int count, {
    AssetStatus? filterStatus,
  }) {
    final statuses = [
      AssetStatus.approve,
      AssetStatus.pending,
      AssetStatus.reject,
    ];

    const names = [
      'MacBook Pro',
      'Dell Monitor',
      'iPhone 15',
      'Office Chair',
      'Standing Desk',
      'iPad Pro',
      'Canon Printer',
      'Sony Headphones',
      'Logitech Keyboard',
      'Samsung TV',
      'HP Laptop',
      'Epson Projector',
      'Cisco Router',
      'WD Hard Drive',
      'LG UltraWide Monitor',
      'APC UPS',
      'Raspberry Pi 5',
      'Wacom Tablet',
      'DJI Drone',
    ];

    const prices = [
      1200.0,
      350.0,
      999.0,
      450.0,
      800.0,
      1099.0,
      280.0,
      199.0,
      89.0,
      650.0,
      750.0,
      520.0,
      310.0,
      120.0,
      480.0,
      160.0,
      80.0,
      370.0,
      1500.0,
    ];

    const imageUrls = [
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=200', // MacBook Pro
      'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=200', // Dell Monitor
      'https://images.unsplash.com/photo-1678685888221-cda773a3dcdb?w=200', // iPhone 15
      'https://images.unsplash.com/photo-1580480055273-228ff5388ef8?w=200', // Office Chair
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=200', // Standing Desk
      'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=200', // iPad Pro
      'https://images.unsplash.com/photo-1612815154858-60aa4c59eaa6?w=200', // Canon Printer
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200', // Sony Headphones
      'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=200', // Logitech Keyboard
      null,
    ];

    final all = List.generate(19, (i) {
      final status = filterStatus ?? statuses[i % statuses.length];
      return FixedAssetModel(
        id: '${i + 1}',
        name: names[i % names.length],
        price: prices[i % prices.length],
        code: 'UPGP-009-hello-2025-009-0000${i + 1}',
        status: status,
        imageUrl: imageUrls[i % imageUrls.length],
      );
    });
    return all.take(count).toList();
  }
}

class AssetPaginationModel extends AssetPagination {
  const AssetPaginationModel({
    required super.assets,
    required super.totalCount,
    required super.currentPage,
    required super.perPage,
    required super.totalPages,
  });

  factory AssetPaginationModel.fromJson(
    Map<String, dynamic> json, {
    required int page,
    required int perPage,
  }) {
    final List<dynamic> rawAssets = json['data'] ?? [];
    return AssetPaginationModel(
      assets: rawAssets.map((e) => FixedAssetModel.fromJson(e)).toList(),
      totalCount: json['total'] ?? 0,
      currentPage: json['current_page'] ?? page,
      perPage: json['per_page'] ?? perPage,
      totalPages: json['last_page'] ?? 1,
    );
  }

  factory AssetPaginationModel.mock({
    int page = 1,
    int perPage = 10,
    AssetStatus? status,
    String? query,
  }) {
    final all = FixedAssetModel.mockList(19);
    final filtered = all.where((a) {
      final matchStatus =
          status == null || status == AssetStatus.all || a.status == status;
      final matchQuery =
          query == null ||
          query.isEmpty ||
          a.name.toLowerCase().contains(query.toLowerCase()) ||
          a.code.toLowerCase().contains(query.toLowerCase());
      return matchStatus && matchQuery;
    }).toList();

    final total = filtered.length;
    final totalPages = (total / perPage).ceil().clamp(1, 9999);
    final start = ((page - 1) * perPage).clamp(0, total);
    final end = (start + perPage).clamp(0, total);
    final pageItems = filtered.sublist(start, end);

    return AssetPaginationModel(
      assets: pageItems,
      totalCount: total,
      currentPage: page,
      perPage: perPage,
      totalPages: totalPages,
    );
  }
}

class AssetStatusCountModel extends AssetStatusCount {
  const AssetStatusCountModel({
    required super.approveCount,
    required super.pendingCount,
    required super.rejectCount,
  });

  factory AssetStatusCountModel.fromJson(Map<String, dynamic> json) {
    return AssetStatusCountModel(
      approveCount: json['approve'] ?? 0,
      pendingCount: json['pending'] ?? 0,
      rejectCount: json['reject'] ?? 0,
    );
  }

  factory AssetStatusCountModel.mock() {
    return const AssetStatusCountModel(
      approveCount: 7,
      pendingCount: 6,
      rejectCount: 6,
    );
  }
}
