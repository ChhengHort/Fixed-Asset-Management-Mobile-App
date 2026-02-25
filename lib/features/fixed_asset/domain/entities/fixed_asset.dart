import 'package:equatable/equatable.dart';

enum AssetStatus { all, approve, pending, reject }

extension AssetStatusExtension on AssetStatus {
  String get label {
    switch (this) {
      case AssetStatus.all:
        return 'All';
      case AssetStatus.approve:
        return 'Approve';
      case AssetStatus.pending:
        return 'Pending';
      case AssetStatus.reject:
        return 'Reject';
    }
  }

  String get apiValue => this == AssetStatus.all ? '' : name;
}

class FixedAsset extends Equatable {
  final String id;
  final String name;
  final double price;
  final String code;
  final AssetStatus status;
  final String? imageUrl;
  final String? category;
  final String? description;
  final DateTime? purchaseDate;
  final String? location;

  const FixedAsset({
    required this.id,
    required this.name,
    required this.price,
    required this.code,
    required this.status,
    this.imageUrl,
    this.category,
    this.description,
    this.purchaseDate,
    this.location,
  });

  @override
  List<Object?> get props => [id, name, price, code, status, imageUrl];
}

class AssetPagination extends Equatable {
  final List<FixedAsset> assets;
  final int totalCount;
  final int currentPage;
  final int perPage;
  final int totalPages;

  const AssetPagination({
    required this.assets,
    required this.totalCount,
    required this.currentPage,
    required this.perPage,
    required this.totalPages,
  });

  bool get hasNextPage => currentPage < totalPages;
  int get from => totalCount == 0 ? 0 : (currentPage - 1) * perPage + 1;
  int get to => (from + assets.length - 1).clamp(0, totalCount);

  @override
  List<Object> get props => [totalCount, currentPage, perPage, totalPages];
}

class AssetStatusCount extends Equatable {
  final int approveCount;
  final int pendingCount;
  final int rejectCount;

  const AssetStatusCount({
    required this.approveCount,
    required this.pendingCount,
    required this.rejectCount,
  });

  @override
  List<Object> get props => [approveCount, pendingCount, rejectCount];
}
