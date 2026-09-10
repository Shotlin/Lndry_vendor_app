// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vendor_application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VendorApplicationDocumentModel _$VendorApplicationDocumentModelFromJson(
    Map<String, dynamic> json) {
  return _VendorApplicationDocumentModel.fromJson(json);
}

/// @nodoc
mixin _$VendorApplicationDocumentModel {
  String get id => throw _privateConstructorUsedError;
  String get documentType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorApplicationDocumentModelCopyWith<VendorApplicationDocumentModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorApplicationDocumentModelCopyWith<$Res> {
  factory $VendorApplicationDocumentModelCopyWith(
          VendorApplicationDocumentModel value,
          $Res Function(VendorApplicationDocumentModel) then) =
      _$VendorApplicationDocumentModelCopyWithImpl<$Res,
          VendorApplicationDocumentModel>;
  @useResult
  $Res call(
      {String id, String documentType, String status, String? rejectionReason});
}

/// @nodoc
class _$VendorApplicationDocumentModelCopyWithImpl<$Res,
        $Val extends VendorApplicationDocumentModel>
    implements $VendorApplicationDocumentModelCopyWith<$Res> {
  _$VendorApplicationDocumentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentType = null,
    Object? status = null,
    Object? rejectionReason = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VendorApplicationDocumentModelImplCopyWith<$Res>
    implements $VendorApplicationDocumentModelCopyWith<$Res> {
  factory _$$VendorApplicationDocumentModelImplCopyWith(
          _$VendorApplicationDocumentModelImpl value,
          $Res Function(_$VendorApplicationDocumentModelImpl) then) =
      __$$VendorApplicationDocumentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String documentType, String status, String? rejectionReason});
}

/// @nodoc
class __$$VendorApplicationDocumentModelImplCopyWithImpl<$Res>
    extends _$VendorApplicationDocumentModelCopyWithImpl<$Res,
        _$VendorApplicationDocumentModelImpl>
    implements _$$VendorApplicationDocumentModelImplCopyWith<$Res> {
  __$$VendorApplicationDocumentModelImplCopyWithImpl(
      _$VendorApplicationDocumentModelImpl _value,
      $Res Function(_$VendorApplicationDocumentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? documentType = null,
    Object? status = null,
    Object? rejectionReason = freezed,
  }) {
    return _then(_$VendorApplicationDocumentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      documentType: null == documentType
          ? _value.documentType
          : documentType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorApplicationDocumentModelImpl
    implements _VendorApplicationDocumentModel {
  const _$VendorApplicationDocumentModelImpl(
      {required this.id,
      required this.documentType,
      this.status = 'PENDING',
      this.rejectionReason});

  factory _$VendorApplicationDocumentModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$VendorApplicationDocumentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String documentType;
  @override
  @JsonKey()
  final String status;
  @override
  final String? rejectionReason;

  @override
  String toString() {
    return 'VendorApplicationDocumentModel(id: $id, documentType: $documentType, status: $status, rejectionReason: $rejectionReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorApplicationDocumentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, documentType, status, rejectionReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorApplicationDocumentModelImplCopyWith<
          _$VendorApplicationDocumentModelImpl>
      get copyWith => __$$VendorApplicationDocumentModelImplCopyWithImpl<
          _$VendorApplicationDocumentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorApplicationDocumentModelImplToJson(
      this,
    );
  }
}

abstract class _VendorApplicationDocumentModel
    implements VendorApplicationDocumentModel {
  const factory _VendorApplicationDocumentModel(
      {required final String id,
      required final String documentType,
      final String status,
      final String? rejectionReason}) = _$VendorApplicationDocumentModelImpl;

  factory _VendorApplicationDocumentModel.fromJson(Map<String, dynamic> json) =
      _$VendorApplicationDocumentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get documentType;
  @override
  String get status;
  @override
  String? get rejectionReason;
  @override
  @JsonKey(ignore: true)
  _$$VendorApplicationDocumentModelImplCopyWith<
          _$VendorApplicationDocumentModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VendorApplicationModel _$VendorApplicationModelFromJson(
    Map<String, dynamic> json) {
  return _VendorApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$VendorApplicationModel {
  String get id => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get ownerName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  String? get bankIfsc => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankHolderName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get gstNumber => throw _privateConstructorUsedError;
  String? get panNumber => throw _privateConstructorUsedError;
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get addressLine2 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get pincode => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  double get requestedServiceRadiusKm => throw _privateConstructorUsedError;
  double? get approvedServiceRadiusKm => throw _privateConstructorUsedError;
  int? get requestedDailyCapacity => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  List<String> get correctionSections => throw _privateConstructorUsedError;
  List<VendorApplicationDocumentModel> get documents =>
      throw _privateConstructorUsedError;
  List<String> get missingSteps => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VendorApplicationModelCopyWith<VendorApplicationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VendorApplicationModelCopyWith<$Res> {
  factory $VendorApplicationModelCopyWith(VendorApplicationModel value,
          $Res Function(VendorApplicationModel) then) =
      _$VendorApplicationModelCopyWithImpl<$Res, VendorApplicationModel>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String status,
      String? ownerName,
      String? email,
      String? phone,
      String? bankAccountNumber,
      String? bankIfsc,
      String? bankName,
      String? bankHolderName,
      String? description,
      String? gstNumber,
      String? panNumber,
      String? addressLine1,
      String? addressLine2,
      String? city,
      String? state,
      String? pincode,
      double? lat,
      double? lng,
      double requestedServiceRadiusKm,
      double? approvedServiceRadiusKm,
      int? requestedDailyCapacity,
      String? rejectionReason,
      List<String> correctionSections,
      List<VendorApplicationDocumentModel> documents,
      List<String> missingSteps,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$VendorApplicationModelCopyWithImpl<$Res,
        $Val extends VendorApplicationModel>
    implements $VendorApplicationModelCopyWith<$Res> {
  _$VendorApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? status = null,
    Object? ownerName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankIfsc = freezed,
    Object? bankName = freezed,
    Object? bankHolderName = freezed,
    Object? description = freezed,
    Object? gstNumber = freezed,
    Object? panNumber = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? requestedServiceRadiusKm = null,
    Object? approvedServiceRadiusKm = freezed,
    Object? requestedDailyCapacity = freezed,
    Object? rejectionReason = freezed,
    Object? correctionSections = null,
    Object? documents = null,
    Object? missingSteps = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIfsc: freezed == bankIfsc
          ? _value.bankIfsc
          : bankIfsc // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankHolderName: freezed == bankHolderName
          ? _value.bankHolderName
          : bankHolderName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      gstNumber: freezed == gstNumber
          ? _value.gstNumber
          : gstNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine1: freezed == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine2: freezed == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      pincode: freezed == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      requestedServiceRadiusKm: null == requestedServiceRadiusKm
          ? _value.requestedServiceRadiusKm
          : requestedServiceRadiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      approvedServiceRadiusKm: freezed == approvedServiceRadiusKm
          ? _value.approvedServiceRadiusKm
          : approvedServiceRadiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      requestedDailyCapacity: freezed == requestedDailyCapacity
          ? _value.requestedDailyCapacity
          : requestedDailyCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      correctionSections: null == correctionSections
          ? _value.correctionSections
          : correctionSections // ignore: cast_nullable_to_non_nullable
              as List<String>,
      documents: null == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<VendorApplicationDocumentModel>,
      missingSteps: null == missingSteps
          ? _value.missingSteps
          : missingSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VendorApplicationModelImplCopyWith<$Res>
    implements $VendorApplicationModelCopyWith<$Res> {
  factory _$$VendorApplicationModelImplCopyWith(
          _$VendorApplicationModelImpl value,
          $Res Function(_$VendorApplicationModelImpl) then) =
      __$$VendorApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String status,
      String? ownerName,
      String? email,
      String? phone,
      String? bankAccountNumber,
      String? bankIfsc,
      String? bankName,
      String? bankHolderName,
      String? description,
      String? gstNumber,
      String? panNumber,
      String? addressLine1,
      String? addressLine2,
      String? city,
      String? state,
      String? pincode,
      double? lat,
      double? lng,
      double requestedServiceRadiusKm,
      double? approvedServiceRadiusKm,
      int? requestedDailyCapacity,
      String? rejectionReason,
      List<String> correctionSections,
      List<VendorApplicationDocumentModel> documents,
      List<String> missingSteps,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$VendorApplicationModelImplCopyWithImpl<$Res>
    extends _$VendorApplicationModelCopyWithImpl<$Res,
        _$VendorApplicationModelImpl>
    implements _$$VendorApplicationModelImplCopyWith<$Res> {
  __$$VendorApplicationModelImplCopyWithImpl(
      _$VendorApplicationModelImpl _value,
      $Res Function(_$VendorApplicationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? status = null,
    Object? ownerName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? bankAccountNumber = freezed,
    Object? bankIfsc = freezed,
    Object? bankName = freezed,
    Object? bankHolderName = freezed,
    Object? description = freezed,
    Object? gstNumber = freezed,
    Object? panNumber = freezed,
    Object? addressLine1 = freezed,
    Object? addressLine2 = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? pincode = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? requestedServiceRadiusKm = null,
    Object? approvedServiceRadiusKm = freezed,
    Object? requestedDailyCapacity = freezed,
    Object? rejectionReason = freezed,
    Object? correctionSections = null,
    Object? documents = null,
    Object? missingSteps = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$VendorApplicationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      bankIfsc: freezed == bankIfsc
          ? _value.bankIfsc
          : bankIfsc // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankHolderName: freezed == bankHolderName
          ? _value.bankHolderName
          : bankHolderName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      gstNumber: freezed == gstNumber
          ? _value.gstNumber
          : gstNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      panNumber: freezed == panNumber
          ? _value.panNumber
          : panNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine1: freezed == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine2: freezed == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      pincode: freezed == pincode
          ? _value.pincode
          : pincode // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      requestedServiceRadiusKm: null == requestedServiceRadiusKm
          ? _value.requestedServiceRadiusKm
          : requestedServiceRadiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      approvedServiceRadiusKm: freezed == approvedServiceRadiusKm
          ? _value.approvedServiceRadiusKm
          : approvedServiceRadiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      requestedDailyCapacity: freezed == requestedDailyCapacity
          ? _value.requestedDailyCapacity
          : requestedDailyCapacity // ignore: cast_nullable_to_non_nullable
              as int?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      correctionSections: null == correctionSections
          ? _value._correctionSections
          : correctionSections // ignore: cast_nullable_to_non_nullable
              as List<String>,
      documents: null == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<VendorApplicationDocumentModel>,
      missingSteps: null == missingSteps
          ? _value._missingSteps
          : missingSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VendorApplicationModelImpl implements _VendorApplicationModel {
  const _$VendorApplicationModelImpl(
      {required this.id,
      required this.ownerId,
      required this.name,
      this.status = 'DRAFT',
      this.ownerName,
      this.email,
      this.phone,
      this.bankAccountNumber,
      this.bankIfsc,
      this.bankName,
      this.bankHolderName,
      this.description,
      this.gstNumber,
      this.panNumber,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.state,
      this.pincode,
      this.lat,
      this.lng,
      this.requestedServiceRadiusKm = 5.0,
      this.approvedServiceRadiusKm,
      this.requestedDailyCapacity,
      this.rejectionReason,
      final List<String> correctionSections = const [],
      final List<VendorApplicationDocumentModel> documents = const [],
      final List<String> missingSteps = const [],
      this.createdAt,
      this.updatedAt})
      : _correctionSections = correctionSections,
        _documents = documents,
        _missingSteps = missingSteps;

  factory _$VendorApplicationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VendorApplicationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  @JsonKey()
  final String status;
  @override
  final String? ownerName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? bankAccountNumber;
  @override
  final String? bankIfsc;
  @override
  final String? bankName;
  @override
  final String? bankHolderName;
  @override
  final String? description;
  @override
  final String? gstNumber;
  @override
  final String? panNumber;
  @override
  final String? addressLine1;
  @override
  final String? addressLine2;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? pincode;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  @JsonKey()
  final double requestedServiceRadiusKm;
  @override
  final double? approvedServiceRadiusKm;
  @override
  final int? requestedDailyCapacity;
  @override
  final String? rejectionReason;
  final List<String> _correctionSections;
  @override
  @JsonKey()
  List<String> get correctionSections {
    if (_correctionSections is EqualUnmodifiableListView)
      return _correctionSections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_correctionSections);
  }

  final List<VendorApplicationDocumentModel> _documents;
  @override
  @JsonKey()
  List<VendorApplicationDocumentModel> get documents {
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documents);
  }

  final List<String> _missingSteps;
  @override
  @JsonKey()
  List<String> get missingSteps {
    if (_missingSteps is EqualUnmodifiableListView) return _missingSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missingSteps);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'VendorApplicationModel(id: $id, ownerId: $ownerId, name: $name, status: $status, ownerName: $ownerName, email: $email, phone: $phone, bankAccountNumber: $bankAccountNumber, bankIfsc: $bankIfsc, bankName: $bankName, bankHolderName: $bankHolderName, description: $description, gstNumber: $gstNumber, panNumber: $panNumber, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, pincode: $pincode, lat: $lat, lng: $lng, requestedServiceRadiusKm: $requestedServiceRadiusKm, approvedServiceRadiusKm: $approvedServiceRadiusKm, requestedDailyCapacity: $requestedDailyCapacity, rejectionReason: $rejectionReason, correctionSections: $correctionSections, documents: $documents, missingSteps: $missingSteps, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VendorApplicationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.bankIfsc, bankIfsc) ||
                other.bankIfsc == bankIfsc) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankHolderName, bankHolderName) ||
                other.bankHolderName == bankHolderName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.gstNumber, gstNumber) ||
                other.gstNumber == gstNumber) &&
            (identical(other.panNumber, panNumber) ||
                other.panNumber == panNumber) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.pincode, pincode) || other.pincode == pincode) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(
                    other.requestedServiceRadiusKm, requestedServiceRadiusKm) ||
                other.requestedServiceRadiusKm == requestedServiceRadiusKm) &&
            (identical(
                    other.approvedServiceRadiusKm, approvedServiceRadiusKm) ||
                other.approvedServiceRadiusKm == approvedServiceRadiusKm) &&
            (identical(other.requestedDailyCapacity, requestedDailyCapacity) ||
                other.requestedDailyCapacity == requestedDailyCapacity) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            const DeepCollectionEquality()
                .equals(other._correctionSections, _correctionSections) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            const DeepCollectionEquality()
                .equals(other._missingSteps, _missingSteps) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        name,
        status,
        ownerName,
        email,
        phone,
        bankAccountNumber,
        bankIfsc,
        bankName,
        bankHolderName,
        description,
        gstNumber,
        panNumber,
        addressLine1,
        addressLine2,
        city,
        state,
        pincode,
        lat,
        lng,
        requestedServiceRadiusKm,
        approvedServiceRadiusKm,
        requestedDailyCapacity,
        rejectionReason,
        const DeepCollectionEquality().hash(_correctionSections),
        const DeepCollectionEquality().hash(_documents),
        const DeepCollectionEquality().hash(_missingSteps),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VendorApplicationModelImplCopyWith<_$VendorApplicationModelImpl>
      get copyWith => __$$VendorApplicationModelImplCopyWithImpl<
          _$VendorApplicationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VendorApplicationModelImplToJson(
      this,
    );
  }
}

abstract class _VendorApplicationModel implements VendorApplicationModel {
  const factory _VendorApplicationModel(
      {required final String id,
      required final String ownerId,
      required final String name,
      final String status,
      final String? ownerName,
      final String? email,
      final String? phone,
      final String? bankAccountNumber,
      final String? bankIfsc,
      final String? bankName,
      final String? bankHolderName,
      final String? description,
      final String? gstNumber,
      final String? panNumber,
      final String? addressLine1,
      final String? addressLine2,
      final String? city,
      final String? state,
      final String? pincode,
      final double? lat,
      final double? lng,
      final double requestedServiceRadiusKm,
      final double? approvedServiceRadiusKm,
      final int? requestedDailyCapacity,
      final String? rejectionReason,
      final List<String> correctionSections,
      final List<VendorApplicationDocumentModel> documents,
      final List<String> missingSteps,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$VendorApplicationModelImpl;

  factory _VendorApplicationModel.fromJson(Map<String, dynamic> json) =
      _$VendorApplicationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ownerId;
  @override
  String get name;
  @override
  String get status;
  @override
  String? get ownerName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get bankAccountNumber;
  @override
  String? get bankIfsc;
  @override
  String? get bankName;
  @override
  String? get bankHolderName;
  @override
  String? get description;
  @override
  String? get gstNumber;
  @override
  String? get panNumber;
  @override
  String? get addressLine1;
  @override
  String? get addressLine2;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get pincode;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  double get requestedServiceRadiusKm;
  @override
  double? get approvedServiceRadiusKm;
  @override
  int? get requestedDailyCapacity;
  @override
  String? get rejectionReason;
  @override
  List<String> get correctionSections;
  @override
  List<VendorApplicationDocumentModel> get documents;
  @override
  List<String> get missingSteps;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$VendorApplicationModelImplCopyWith<_$VendorApplicationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
