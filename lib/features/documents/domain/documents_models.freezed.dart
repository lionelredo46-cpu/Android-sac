// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'documents_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VaultDocument {

 String get id; String get titre; String get categorie; bool get estSigne; Map<String, dynamic>? get signatureMetadata; DateTime get createdAt; bool get aSigner; String? get validation;
/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VaultDocumentCopyWith<VaultDocument> get copyWith => _$VaultDocumentCopyWithImpl<VaultDocument>(this as VaultDocument, _$identity);

  /// Serializes this VaultDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VaultDocument;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VaultDocument&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.titre, _this.titre) || other.titre == _this.titre)&&(identical(other.categorie, _this.categorie) || other.categorie == _this.categorie)&&(identical(other.estSigne, _this.estSigne) || other.estSigne == _this.estSigne)&&const DeepCollectionEquality().equals(other.signatureMetadata, _this.signatureMetadata)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.aSigner, _this.aSigner) || other.aSigner == _this.aSigner)&&(identical(other.validation, _this.validation) || other.validation == _this.validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VaultDocument;
  return Object.hash(runtimeType,_this.id,_this.titre,_this.categorie,_this.estSigne,const DeepCollectionEquality().hash(_this.signatureMetadata),_this.createdAt,_this.aSigner,_this.validation);
}

@override
String toString() {
  final _this = this as VaultDocument;
  return 'VaultDocument(id: ${_this.id}, titre: ${_this.titre}, categorie: ${_this.categorie}, estSigne: ${_this.estSigne}, signatureMetadata: ${_this.signatureMetadata}, createdAt: ${_this.createdAt}, aSigner: ${_this.aSigner}, validation: ${_this.validation})';
}


}

/// @nodoc
abstract mixin class $VaultDocumentCopyWith<$Res>  {
  factory $VaultDocumentCopyWith(VaultDocument value, $Res Function(VaultDocument) _then) = _$VaultDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String titre, String categorie, bool estSigne, Map<String, dynamic>? signatureMetadata, DateTime createdAt, bool aSigner, String? validation
});




}
/// @nodoc
class _$VaultDocumentCopyWithImpl<$Res>
    implements $VaultDocumentCopyWith<$Res> {
  _$VaultDocumentCopyWithImpl(this._self, this._then);

  final VaultDocument _self;
  final $Res Function(VaultDocument) _then;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? categorie = null,Object? estSigne = null,Object? signatureMetadata = freezed,Object? createdAt = null,Object? aSigner = null,Object? validation = freezed,}) {
  return _then(VaultDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as String,estSigne: null == estSigne ? _self.estSigne : estSigne // ignore: cast_nullable_to_non_nullable
as bool,signatureMetadata: freezed == signatureMetadata ? _self.signatureMetadata : signatureMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,aSigner: null == aSigner ? _self.aSigner : aSigner // ignore: cast_nullable_to_non_nullable
as bool,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VaultDocument].
extension VaultDocumentPatterns on VaultDocument {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VaultDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VaultDocument value)  $default,){
final _that = this;
switch (_that) {
case _VaultDocument():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VaultDocument value)?  $default,){
final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titre,  String categorie,  bool estSigne,  Map<String, dynamic>? signatureMetadata,  DateTime createdAt,  bool aSigner,  String? validation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that.id,_that.titre,_that.categorie,_that.estSigne,_that.signatureMetadata,_that.createdAt,_that.aSigner,_that.validation);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titre,  String categorie,  bool estSigne,  Map<String, dynamic>? signatureMetadata,  DateTime createdAt,  bool aSigner,  String? validation)  $default,) {final _that = this;
switch (_that) {
case _VaultDocument():
return $default(_that.id,_that.titre,_that.categorie,_that.estSigne,_that.signatureMetadata,_that.createdAt,_that.aSigner,_that.validation);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titre,  String categorie,  bool estSigne,  Map<String, dynamic>? signatureMetadata,  DateTime createdAt,  bool aSigner,  String? validation)?  $default,) {final _that = this;
switch (_that) {
case _VaultDocument() when $default != null:
return $default(_that.id,_that.titre,_that.categorie,_that.estSigne,_that.signatureMetadata,_that.createdAt,_that.aSigner,_that.validation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VaultDocument implements VaultDocument {
  const _VaultDocument({required this.id, required this.titre, required this.categorie, this.estSigne = false,  Map<String, dynamic>? signatureMetadata, required this.createdAt, this.aSigner = false, this.validation}): _signatureMetadata = signatureMetadata;
  factory _VaultDocument.fromJson(Map<String, dynamic> json) => _$VaultDocumentFromJson(json);

@override final  String id;
@override final  String titre;
@override final  String categorie;
@override@JsonKey() final  bool estSigne;
 final  Map<String, dynamic>? _signatureMetadata;
@override Map<String, dynamic>? get signatureMetadata {
  final value = _signatureMetadata;
  if (value == null) return null;
  if (_signatureMetadata is EqualUnmodifiableMapView) return _signatureMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
@override@JsonKey() final  bool aSigner;
@override final  String? validation;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VaultDocumentCopyWith<_VaultDocument> get copyWith => __$VaultDocumentCopyWithImpl<_VaultDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VaultDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VaultDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.categorie, categorie) || other.categorie == categorie)&&(identical(other.estSigne, estSigne) || other.estSigne == estSigne)&&const DeepCollectionEquality().equals(other.signatureMetadata, _signatureMetadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.aSigner, aSigner) || other.aSigner == aSigner)&&(identical(other.validation, validation) || other.validation == validation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,titre,categorie,estSigne,const DeepCollectionEquality().hash(_signatureMetadata),createdAt,aSigner,validation);
}

@override
String toString() {
    return 'VaultDocument(id: $id, titre: $titre, categorie: $categorie, estSigne: $estSigne, signatureMetadata: $signatureMetadata, createdAt: $createdAt, aSigner: $aSigner, validation: $validation)';
}


}

/// @nodoc
abstract mixin class _$VaultDocumentCopyWith<$Res> implements $VaultDocumentCopyWith<$Res> {
  factory _$VaultDocumentCopyWith(_VaultDocument value, $Res Function(_VaultDocument) _then) = __$VaultDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String titre, String categorie, bool estSigne, Map<String, dynamic>? signatureMetadata, DateTime createdAt, bool aSigner, String? validation
});




}
/// @nodoc
class __$VaultDocumentCopyWithImpl<$Res>
    implements _$VaultDocumentCopyWith<$Res> {
  __$VaultDocumentCopyWithImpl(this._self, this._then);

  final _VaultDocument _self;
  final $Res Function(_VaultDocument) _then;

/// Create a copy of VaultDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? categorie = null,Object? estSigne = null,Object? signatureMetadata = freezed,Object? createdAt = null,Object? aSigner = null,Object? validation = freezed,}) {
  return _then(_VaultDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,categorie: null == categorie ? _self.categorie : categorie // ignore: cast_nullable_to_non_nullable
as String,estSigne: null == estSigne ? _self.estSigne : estSigne // ignore: cast_nullable_to_non_nullable
as bool,signatureMetadata: freezed == signatureMetadata ? _self._signatureMetadata : signatureMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,aSigner: null == aSigner ? _self.aSigner : aSigner // ignore: cast_nullable_to_non_nullable
as bool,validation: freezed == validation ? _self.validation : validation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DocumentRequest {

 String get id; String get type; String? get motif; String get statut; DateTime get createdAt; DateTime get updatedAt; String get libelle; bool get documentDisponible;
/// Create a copy of DocumentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentRequestCopyWith<DocumentRequest> get copyWith => _$DocumentRequestCopyWithImpl<DocumentRequest>(this as DocumentRequest, _$identity);

  /// Serializes this DocumentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DocumentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.motif, _this.motif) || other.motif == _this.motif)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle)&&(identical(other.documentDisponible, _this.documentDisponible) || other.documentDisponible == _this.documentDisponible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DocumentRequest;
  return Object.hash(runtimeType,_this.id,_this.type,_this.motif,_this.statut,_this.createdAt,_this.updatedAt,_this.libelle,_this.documentDisponible);
}

@override
String toString() {
  final _this = this as DocumentRequest;
  return 'DocumentRequest(id: ${_this.id}, type: ${_this.type}, motif: ${_this.motif}, statut: ${_this.statut}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, libelle: ${_this.libelle}, documentDisponible: ${_this.documentDisponible})';
}


}

/// @nodoc
abstract mixin class $DocumentRequestCopyWith<$Res>  {
  factory $DocumentRequestCopyWith(DocumentRequest value, $Res Function(DocumentRequest) _then) = _$DocumentRequestCopyWithImpl;
@useResult
$Res call({
 String id, String type, String? motif, String statut, DateTime createdAt, DateTime updatedAt, String libelle, bool documentDisponible
});




}
/// @nodoc
class _$DocumentRequestCopyWithImpl<$Res>
    implements $DocumentRequestCopyWith<$Res> {
  _$DocumentRequestCopyWithImpl(this._self, this._then);

  final DocumentRequest _self;
  final $Res Function(DocumentRequest) _then;

/// Create a copy of DocumentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? motif = freezed,Object? statut = null,Object? createdAt = null,Object? updatedAt = null,Object? libelle = null,Object? documentDisponible = null,}) {
  return _then(DocumentRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,documentDisponible: null == documentDisponible ? _self.documentDisponible : documentDisponible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentRequest].
extension DocumentRequestPatterns on DocumentRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentRequest value)  $default,){
final _that = this;
switch (_that) {
case _DocumentRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String? motif,  String statut,  DateTime createdAt,  DateTime updatedAt,  String libelle,  bool documentDisponible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentRequest() when $default != null:
return $default(_that.id,_that.type,_that.motif,_that.statut,_that.createdAt,_that.updatedAt,_that.libelle,_that.documentDisponible);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String? motif,  String statut,  DateTime createdAt,  DateTime updatedAt,  String libelle,  bool documentDisponible)  $default,) {final _that = this;
switch (_that) {
case _DocumentRequest():
return $default(_that.id,_that.type,_that.motif,_that.statut,_that.createdAt,_that.updatedAt,_that.libelle,_that.documentDisponible);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String? motif,  String statut,  DateTime createdAt,  DateTime updatedAt,  String libelle,  bool documentDisponible)?  $default,) {final _that = this;
switch (_that) {
case _DocumentRequest() when $default != null:
return $default(_that.id,_that.type,_that.motif,_that.statut,_that.createdAt,_that.updatedAt,_that.libelle,_that.documentDisponible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentRequest implements DocumentRequest {
  const _DocumentRequest({required this.id, required this.type, this.motif, required this.statut, required this.createdAt, required this.updatedAt, required this.libelle, this.documentDisponible = false});
  factory _DocumentRequest.fromJson(Map<String, dynamic> json) => _$DocumentRequestFromJson(json);

@override final  String id;
@override final  String type;
@override final  String? motif;
@override final  String statut;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String libelle;
@override@JsonKey() final  bool documentDisponible;

/// Create a copy of DocumentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentRequestCopyWith<_DocumentRequest> get copyWith => __$DocumentRequestCopyWithImpl<_DocumentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.motif, motif) || other.motif == motif)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.libelle, libelle) || other.libelle == libelle)&&(identical(other.documentDisponible, documentDisponible) || other.documentDisponible == documentDisponible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,motif,statut,createdAt,updatedAt,libelle,documentDisponible);
}

@override
String toString() {
    return 'DocumentRequest(id: $id, type: $type, motif: $motif, statut: $statut, createdAt: $createdAt, updatedAt: $updatedAt, libelle: $libelle, documentDisponible: $documentDisponible)';
}


}

/// @nodoc
abstract mixin class _$DocumentRequestCopyWith<$Res> implements $DocumentRequestCopyWith<$Res> {
  factory _$DocumentRequestCopyWith(_DocumentRequest value, $Res Function(_DocumentRequest) _then) = __$DocumentRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String? motif, String statut, DateTime createdAt, DateTime updatedAt, String libelle, bool documentDisponible
});




}
/// @nodoc
class __$DocumentRequestCopyWithImpl<$Res>
    implements _$DocumentRequestCopyWith<$Res> {
  __$DocumentRequestCopyWithImpl(this._self, this._then);

  final _DocumentRequest _self;
  final $Res Function(_DocumentRequest) _then;

/// Create a copy of DocumentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? motif = freezed,Object? statut = null,Object? createdAt = null,Object? updatedAt = null,Object? libelle = null,Object? documentDisponible = null,}) {
  return _then(_DocumentRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,documentDisponible: null == documentDisponible ? _self.documentDisponible : documentDisponible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DisciplineRecord {

 String get id; String get type; String get motif; String? get sanction; DateTime get dateIncident; DateTime? get convocationDate; bool get accuseReception; DateTime? get accuseReceptionLe; String get libelle; bool get positif; bool get accuseRequis;
/// Create a copy of DisciplineRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisciplineRecordCopyWith<DisciplineRecord> get copyWith => _$DisciplineRecordCopyWithImpl<DisciplineRecord>(this as DisciplineRecord, _$identity);

  /// Serializes this DisciplineRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DisciplineRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisciplineRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.motif, _this.motif) || other.motif == _this.motif)&&(identical(other.sanction, _this.sanction) || other.sanction == _this.sanction)&&(identical(other.dateIncident, _this.dateIncident) || other.dateIncident == _this.dateIncident)&&(identical(other.convocationDate, _this.convocationDate) || other.convocationDate == _this.convocationDate)&&(identical(other.accuseReception, _this.accuseReception) || other.accuseReception == _this.accuseReception)&&(identical(other.accuseReceptionLe, _this.accuseReceptionLe) || other.accuseReceptionLe == _this.accuseReceptionLe)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle)&&(identical(other.positif, _this.positif) || other.positif == _this.positif)&&(identical(other.accuseRequis, _this.accuseRequis) || other.accuseRequis == _this.accuseRequis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DisciplineRecord;
  return Object.hash(runtimeType,_this.id,_this.type,_this.motif,_this.sanction,_this.dateIncident,_this.convocationDate,_this.accuseReception,_this.accuseReceptionLe,_this.libelle,_this.positif,_this.accuseRequis);
}

@override
String toString() {
  final _this = this as DisciplineRecord;
  return 'DisciplineRecord(id: ${_this.id}, type: ${_this.type}, motif: ${_this.motif}, sanction: ${_this.sanction}, dateIncident: ${_this.dateIncident}, convocationDate: ${_this.convocationDate}, accuseReception: ${_this.accuseReception}, accuseReceptionLe: ${_this.accuseReceptionLe}, libelle: ${_this.libelle}, positif: ${_this.positif}, accuseRequis: ${_this.accuseRequis})';
}


}

/// @nodoc
abstract mixin class $DisciplineRecordCopyWith<$Res>  {
  factory $DisciplineRecordCopyWith(DisciplineRecord value, $Res Function(DisciplineRecord) _then) = _$DisciplineRecordCopyWithImpl;
@useResult
$Res call({
 String id, String type, String motif, String? sanction, DateTime dateIncident, DateTime? convocationDate, bool accuseReception, DateTime? accuseReceptionLe, String libelle, bool positif, bool accuseRequis
});




}
/// @nodoc
class _$DisciplineRecordCopyWithImpl<$Res>
    implements $DisciplineRecordCopyWith<$Res> {
  _$DisciplineRecordCopyWithImpl(this._self, this._then);

  final DisciplineRecord _self;
  final $Res Function(DisciplineRecord) _then;

/// Create a copy of DisciplineRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? motif = null,Object? sanction = freezed,Object? dateIncident = null,Object? convocationDate = freezed,Object? accuseReception = null,Object? accuseReceptionLe = freezed,Object? libelle = null,Object? positif = null,Object? accuseRequis = null,}) {
  return _then(DisciplineRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,sanction: freezed == sanction ? _self.sanction : sanction // ignore: cast_nullable_to_non_nullable
as String?,dateIncident: null == dateIncident ? _self.dateIncident : dateIncident // ignore: cast_nullable_to_non_nullable
as DateTime,convocationDate: freezed == convocationDate ? _self.convocationDate : convocationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,accuseReception: null == accuseReception ? _self.accuseReception : accuseReception // ignore: cast_nullable_to_non_nullable
as bool,accuseReceptionLe: freezed == accuseReceptionLe ? _self.accuseReceptionLe : accuseReceptionLe // ignore: cast_nullable_to_non_nullable
as DateTime?,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,positif: null == positif ? _self.positif : positif // ignore: cast_nullable_to_non_nullable
as bool,accuseRequis: null == accuseRequis ? _self.accuseRequis : accuseRequis // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DisciplineRecord].
extension DisciplineRecordPatterns on DisciplineRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisciplineRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisciplineRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisciplineRecord value)  $default,){
final _that = this;
switch (_that) {
case _DisciplineRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisciplineRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DisciplineRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String motif,  String? sanction,  DateTime dateIncident,  DateTime? convocationDate,  bool accuseReception,  DateTime? accuseReceptionLe,  String libelle,  bool positif,  bool accuseRequis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisciplineRecord() when $default != null:
return $default(_that.id,_that.type,_that.motif,_that.sanction,_that.dateIncident,_that.convocationDate,_that.accuseReception,_that.accuseReceptionLe,_that.libelle,_that.positif,_that.accuseRequis);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String motif,  String? sanction,  DateTime dateIncident,  DateTime? convocationDate,  bool accuseReception,  DateTime? accuseReceptionLe,  String libelle,  bool positif,  bool accuseRequis)  $default,) {final _that = this;
switch (_that) {
case _DisciplineRecord():
return $default(_that.id,_that.type,_that.motif,_that.sanction,_that.dateIncident,_that.convocationDate,_that.accuseReception,_that.accuseReceptionLe,_that.libelle,_that.positif,_that.accuseRequis);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String motif,  String? sanction,  DateTime dateIncident,  DateTime? convocationDate,  bool accuseReception,  DateTime? accuseReceptionLe,  String libelle,  bool positif,  bool accuseRequis)?  $default,) {final _that = this;
switch (_that) {
case _DisciplineRecord() when $default != null:
return $default(_that.id,_that.type,_that.motif,_that.sanction,_that.dateIncident,_that.convocationDate,_that.accuseReception,_that.accuseReceptionLe,_that.libelle,_that.positif,_that.accuseRequis);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisciplineRecord implements DisciplineRecord {
  const _DisciplineRecord({required this.id, required this.type, required this.motif, this.sanction, required this.dateIncident, this.convocationDate, this.accuseReception = false, this.accuseReceptionLe, required this.libelle, this.positif = false, this.accuseRequis = false});
  factory _DisciplineRecord.fromJson(Map<String, dynamic> json) => _$DisciplineRecordFromJson(json);

@override final  String id;
@override final  String type;
@override final  String motif;
@override final  String? sanction;
@override final  DateTime dateIncident;
@override final  DateTime? convocationDate;
@override@JsonKey() final  bool accuseReception;
@override final  DateTime? accuseReceptionLe;
@override final  String libelle;
@override@JsonKey() final  bool positif;
@override@JsonKey() final  bool accuseRequis;

/// Create a copy of DisciplineRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisciplineRecordCopyWith<_DisciplineRecord> get copyWith => __$DisciplineRecordCopyWithImpl<_DisciplineRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisciplineRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisciplineRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.motif, motif) || other.motif == motif)&&(identical(other.sanction, sanction) || other.sanction == sanction)&&(identical(other.dateIncident, dateIncident) || other.dateIncident == dateIncident)&&(identical(other.convocationDate, convocationDate) || other.convocationDate == convocationDate)&&(identical(other.accuseReception, accuseReception) || other.accuseReception == accuseReception)&&(identical(other.accuseReceptionLe, accuseReceptionLe) || other.accuseReceptionLe == accuseReceptionLe)&&(identical(other.libelle, libelle) || other.libelle == libelle)&&(identical(other.positif, positif) || other.positif == positif)&&(identical(other.accuseRequis, accuseRequis) || other.accuseRequis == accuseRequis));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,motif,sanction,dateIncident,convocationDate,accuseReception,accuseReceptionLe,libelle,positif,accuseRequis);
}

@override
String toString() {
    return 'DisciplineRecord(id: $id, type: $type, motif: $motif, sanction: $sanction, dateIncident: $dateIncident, convocationDate: $convocationDate, accuseReception: $accuseReception, accuseReceptionLe: $accuseReceptionLe, libelle: $libelle, positif: $positif, accuseRequis: $accuseRequis)';
}


}

/// @nodoc
abstract mixin class _$DisciplineRecordCopyWith<$Res> implements $DisciplineRecordCopyWith<$Res> {
  factory _$DisciplineRecordCopyWith(_DisciplineRecord value, $Res Function(_DisciplineRecord) _then) = __$DisciplineRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String motif, String? sanction, DateTime dateIncident, DateTime? convocationDate, bool accuseReception, DateTime? accuseReceptionLe, String libelle, bool positif, bool accuseRequis
});




}
/// @nodoc
class __$DisciplineRecordCopyWithImpl<$Res>
    implements _$DisciplineRecordCopyWith<$Res> {
  __$DisciplineRecordCopyWithImpl(this._self, this._then);

  final _DisciplineRecord _self;
  final $Res Function(_DisciplineRecord) _then;

/// Create a copy of DisciplineRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? motif = null,Object? sanction = freezed,Object? dateIncident = null,Object? convocationDate = freezed,Object? accuseReception = null,Object? accuseReceptionLe = freezed,Object? libelle = null,Object? positif = null,Object? accuseRequis = null,}) {
  return _then(_DisciplineRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,sanction: freezed == sanction ? _self.sanction : sanction // ignore: cast_nullable_to_non_nullable
as String?,dateIncident: null == dateIncident ? _self.dateIncident : dateIncident // ignore: cast_nullable_to_non_nullable
as DateTime,convocationDate: freezed == convocationDate ? _self.convocationDate : convocationDate // ignore: cast_nullable_to_non_nullable
as DateTime?,accuseReception: null == accuseReception ? _self.accuseReception : accuseReception // ignore: cast_nullable_to_non_nullable
as bool,accuseReceptionLe: freezed == accuseReceptionLe ? _self.accuseReceptionLe : accuseReceptionLe // ignore: cast_nullable_to_non_nullable
as DateTime?,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,positif: null == positif ? _self.positif : positif // ignore: cast_nullable_to_non_nullable
as bool,accuseRequis: null == accuseRequis ? _self.accuseRequis : accuseRequis // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
