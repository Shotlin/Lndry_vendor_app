// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) {
  return _ServiceModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceModel {
  String get id => throw _privateConstructorUsedError;
  String get vendorId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ServiceCategory get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  double? get pricePerKg => throw _privateConstructorUsedError;
  double? get pricePerPiece => throw _privateConstructorUsedError;
  double get minWeightKg => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Admin review state for this service ('PENDING' | 'APPROVED' | 'REJECTED').
  /// Only APPROVED services are visible to customers.
  @JsonKey(name: 'approval_status')
  String? get approvalStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;

  /// Most recent admin price-recalculation note across this service's
  /// subcategories, if any — surfaced right on the service card so it's
  /// never hidden behind a separate notification only.
  @JsonKey(name: 'latest_override_reason')
  String? get latestOverrideReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'latest_override_at')
  DateTime? get latestOverrideAt => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  double? get averageRating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  Duration? get estimatedDuration => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceModelCopyWith<ServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceModelCopyWith<$Res> {
  factory $ServiceModelCopyWith(
          ServiceModel value, $Res Function(ServiceModel) then) =
      _$ServiceModelCopyWithImpl<$Res, ServiceModel>;
  @useResult
  $Res call(
      {String id,
      String vendorId,
      String name,
      String description,
      ServiceCategory category,
      @JsonKey(name: 'category_id') String? categoryId,
      double? pricePerKg,
      double? pricePerPiece,
      double minWeightKg,
      bool isAvailable,
      @JsonKey(name: 'approval_status') String? approvalStatus,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'latest_override_reason') String? latestOverrideReason,
      @JsonKey(name: 'latest_override_at') DateTime? latestOverrideAt,
      String? imageUrl,
      List<String> tags,
      double? averageRating,
      int reviewCount,
      Duration? estimatedDuration,
      DateTime? createdAt});
}

/// @nodoc
class _$ServiceModelCopyWithImpl<$Res, $Val extends ServiceModel>
    implements $ServiceModelCopyWith<$Res> {
  _$ServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? categoryId = freezed,
    Object? pricePerKg = freezed,
    Object? pricePerPiece = freezed,
    Object? minWeightKg = null,
    Object? isAvailable = null,
    Object? approvalStatus = freezed,
    Object? rejectionReason = freezed,
    Object? latestOverrideReason = freezed,
    Object? latestOverrideAt = freezed,
    Object? imageUrl = freezed,
    Object? tags = null,
    Object? averageRating = freezed,
    Object? reviewCount = null,
    Object? estimatedDuration = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ServiceCategory,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricePerKg: freezed == pricePerKg
          ? _value.pricePerKg
          : pricePerKg // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerPiece: freezed == pricePerPiece
          ? _value.pricePerPiece
          : pricePerPiece // ignore: cast_nullable_to_non_nullable
              as double?,
      minWeightKg: null == minWeightKg
          ? _value.minWeightKg
          : minWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      latestOverrideReason: freezed == latestOverrideReason
          ? _value.latestOverrideReason
          : latestOverrideReason // ignore: cast_nullable_to_non_nullable
              as String?,
      latestOverrideAt: freezed == latestOverrideAt
          ? _value.latestOverrideAt
          : latestOverrideAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceModelImplCopyWith<$Res>
    implements $ServiceModelCopyWith<$Res> {
  factory _$$ServiceModelImplCopyWith(
          _$ServiceModelImpl value, $Res Function(_$ServiceModelImpl) then) =
      __$$ServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vendorId,
      String name,
      String description,
      ServiceCategory category,
      @JsonKey(name: 'category_id') String? categoryId,
      double? pricePerKg,
      double? pricePerPiece,
      double minWeightKg,
      bool isAvailable,
      @JsonKey(name: 'approval_status') String? approvalStatus,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'latest_override_reason') String? latestOverrideReason,
      @JsonKey(name: 'latest_override_at') DateTime? latestOverrideAt,
      String? imageUrl,
      List<String> tags,
      double? averageRating,
      int reviewCount,
      Duration? estimatedDuration,
      DateTime? createdAt});
}

/// @nodoc
class __$$ServiceModelImplCopyWithImpl<$Res>
    extends _$ServiceModelCopyWithImpl<$Res, _$ServiceModelImpl>
    implements _$$ServiceModelImplCopyWith<$Res> {
  __$$ServiceModelImplCopyWithImpl(
      _$ServiceModelImpl _value, $Res Function(_$ServiceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vendorId = null,
    Object? name = null,
    Object? description = null,
    Object? category = null,
    Object? categoryId = freezed,
    Object? pricePerKg = freezed,
    Object? pricePerPiece = freezed,
    Object? minWeightKg = null,
    Object? isAvailable = null,
    Object? approvalStatus = freezed,
    Object? rejectionReason = freezed,
    Object? latestOverrideReason = freezed,
    Object? latestOverrideAt = freezed,
    Object? imageUrl = freezed,
    Object? tags = null,
    Object? averageRating = freezed,
    Object? reviewCount = null,
    Object? estimatedDuration = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ServiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vendorId: null == vendorId
          ? _value.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ServiceCategory,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      pricePerKg: freezed == pricePerKg
          ? _value.pricePerKg
          : pricePerKg // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerPiece: freezed == pricePerPiece
          ? _value.pricePerPiece
          : pricePerPiece // ignore: cast_nullable_to_non_nullable
              as double?,
      minWeightKg: null == minWeightKg
          ? _value.minWeightKg
          : minWeightKg // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      approvalStatus: freezed == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      latestOverrideReason: freezed == latestOverrideReason
          ? _value.latestOverrideReason
          : latestOverrideReason // ignore: cast_nullable_to_non_nullable
              as String?,
      latestOverrideAt: freezed == latestOverrideAt
          ? _value.latestOverrideAt
          : latestOverrideAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as Duration?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceModelImpl implements _ServiceModel {
  const _$ServiceModelImpl(
      {required this.id,
      required this.vendorId,
      required this.name,
      required this.description,
      required this.category,
      @JsonKey(name: 'category_id') this.categoryId,
      this.pricePerKg,
      this.pricePerPiece,
      required this.minWeightKg,
      this.isAvailable = true,
      @JsonKey(name: 'approval_status') this.approvalStatus,
      @JsonKey(name: 'rejection_reason') this.rejectionReason,
      @JsonKey(name: 'latest_override_reason') this.latestOverrideReason,
      @JsonKey(name: 'latest_override_at') this.latestOverrideAt,
      this.imageUrl,
      final List<String> tags = const [],
      this.averageRating,
      this.reviewCount = 0,
      this.estimatedDuration,
      this.createdAt})
      : _tags = tags;

  factory _$ServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String vendorId;
  @override
  final String name;
  @override
  final String description;
  @override
  final ServiceCategory category;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  @override
  final double? pricePerKg;
  @override
  final double? pricePerPiece;
  @override
  final double minWeightKg;
  @override
  @JsonKey()
  final bool isAvailable;

  /// Admin review state for this service ('PENDING' | 'APPROVED' | 'REJECTED').
  /// Only APPROVED services are visible to customers.
  @override
  @JsonKey(name: 'approval_status')
  final String? approvalStatus;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  /// Most recent admin price-recalculation note across this service's
  /// subcategories, if any — surfaced right on the service card so it's
  /// never hidden behind a separate notification only.
  @override
  @JsonKey(name: 'latest_override_reason')
  final String? latestOverrideReason;
  @override
  @JsonKey(name: 'latest_override_at')
  final DateTime? latestOverrideAt;
  @override
  final String? imageUrl;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final double? averageRating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final Duration? estimatedDuration;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ServiceModel(id: $id, vendorId: $vendorId, name: $name, description: $description, category: $category, categoryId: $categoryId, pricePerKg: $pricePerKg, pricePerPiece: $pricePerPiece, minWeightKg: $minWeightKg, isAvailable: $isAvailable, approvalStatus: $approvalStatus, rejectionReason: $rejectionReason, latestOverrideReason: $latestOverrideReason, latestOverrideAt: $latestOverrideAt, imageUrl: $imageUrl, tags: $tags, averageRating: $averageRating, reviewCount: $reviewCount, estimatedDuration: $estimatedDuration, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.pricePerKg, pricePerKg) ||
                other.pricePerKg == pricePerKg) &&
            (identical(other.pricePerPiece, pricePerPiece) ||
                other.pricePerPiece == pricePerPiece) &&
            (identical(other.minWeightKg, minWeightKg) ||
                other.minWeightKg == minWeightKg) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.latestOverrideReason, latestOverrideReason) ||
                other.latestOverrideReason == latestOverrideReason) &&
            (identical(other.latestOverrideAt, latestOverrideAt) ||
                other.latestOverrideAt == latestOverrideAt) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        vendorId,
        name,
        description,
        category,
        categoryId,
        pricePerKg,
        pricePerPiece,
        minWeightKg,
        isAvailable,
        approvalStatus,
        rejectionReason,
        latestOverrideReason,
        latestOverrideAt,
        imageUrl,
        const DeepCollectionEquality().hash(_tags),
        averageRating,
        reviewCount,
        estimatedDuration,
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      __$$ServiceModelImplCopyWithImpl<_$ServiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceModel implements ServiceModel {
  const factory _ServiceModel(
      {required final String id,
      required final String vendorId,
      required final String name,
      required final String description,
      required final ServiceCategory category,
      @JsonKey(name: 'category_id') final String? categoryId,
      final double? pricePerKg,
      final double? pricePerPiece,
      required final double minWeightKg,
      final bool isAvailable,
      @JsonKey(name: 'approval_status') final String? approvalStatus,
      @JsonKey(name: 'rejection_reason') final String? rejectionReason,
      @JsonKey(name: 'latest_override_reason')
      final String? latestOverrideReason,
      @JsonKey(name: 'latest_override_at') final DateTime? latestOverrideAt,
      final String? imageUrl,
      final List<String> tags,
      final double? averageRating,
      final int reviewCount,
      final Duration? estimatedDuration,
      final DateTime? createdAt}) = _$ServiceModelImpl;

  factory _ServiceModel.fromJson(Map<String, dynamic> json) =
      _$ServiceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get vendorId;
  @override
  String get name;
  @override
  String get description;
  @override
  ServiceCategory get category;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  double? get pricePerKg;
  @override
  double? get pricePerPiece;
  @override
  double get minWeightKg;
  @override
  bool get isAvailable;
  @override

  /// Admin review state for this service ('PENDING' | 'APPROVED' | 'REJECTED').
  /// Only APPROVED services are visible to customers.
  @JsonKey(name: 'approval_status')
  String? get approvalStatus;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @override

  /// Most recent admin price-recalculation note across this service's
  /// subcategories, if any — surfaced right on the service card so it's
  /// never hidden behind a separate notification only.
  @JsonKey(name: 'latest_override_reason')
  String? get latestOverrideReason;
  @override
  @JsonKey(name: 'latest_override_at')
  DateTime? get latestOverrideAt;
  @override
  String? get imageUrl;
  @override
  List<String> get tags;
  @override
  double? get averageRating;
  @override
  int get reviewCount;
  @override
  Duration? get estimatedDuration;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
