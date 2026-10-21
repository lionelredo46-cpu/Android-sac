// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$YearRef {

 String get id; String get libelle;
/// Create a copy of YearRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearRefCopyWith<YearRef> get copyWith => _$YearRefCopyWithImpl<YearRef>(this as YearRef, _$identity);

  /// Serializes this YearRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as YearRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as YearRef;
  return Object.hash(runtimeType,_this.id,_this.libelle);
}

@override
String toString() {
  final _this = this as YearRef;
  return 'YearRef(id: ${_this.id}, libelle: ${_this.libelle})';
}


}

/// @nodoc
abstract mixin class $YearRefCopyWith<$Res>  {
  factory $YearRefCopyWith(YearRef value, $Res Function(YearRef) _then) = _$YearRefCopyWithImpl;
@useResult
$Res call({
 String id, String libelle
});




}
/// @nodoc
class _$YearRefCopyWithImpl<$Res>
    implements $YearRefCopyWith<$Res> {
  _$YearRefCopyWithImpl(this._self, this._then);

  final YearRef _self;
  final $Res Function(YearRef) _then;

/// Create a copy of YearRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? libelle = null,}) {
  return _then(YearRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [YearRef].
extension YearRefPatterns on YearRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearRef value)  $default,){
final _that = this;
switch (_that) {
case _YearRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearRef value)?  $default,){
final _that = this;
switch (_that) {
case _YearRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String libelle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearRef() when $default != null:
return $default(_that.id,_that.libelle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String libelle)  $default,) {final _that = this;
switch (_that) {
case _YearRef():
return $default(_that.id,_that.libelle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String libelle)?  $default,) {final _that = this;
switch (_that) {
case _YearRef() when $default != null:
return $default(_that.id,_that.libelle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearRef implements YearRef {
  const _YearRef({required this.id, required this.libelle});
  factory _YearRef.fromJson(Map<String, dynamic> json) => _$YearRefFromJson(json);

@override final  String id;
@override final  String libelle;

/// Create a copy of YearRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearRefCopyWith<_YearRef> get copyWith => __$YearRefCopyWithImpl<_YearRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearRef&&(identical(other.id, id) || other.id == id)&&(identical(other.libelle, libelle) || other.libelle == libelle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,libelle);
}

@override
String toString() {
    return 'YearRef(id: $id, libelle: $libelle)';
}


}

/// @nodoc
abstract mixin class _$YearRefCopyWith<$Res> implements $YearRefCopyWith<$Res> {
  factory _$YearRefCopyWith(_YearRef value, $Res Function(_YearRef) _then) = __$YearRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String libelle
});




}
/// @nodoc
class __$YearRefCopyWithImpl<$Res>
    implements _$YearRefCopyWith<$Res> {
  __$YearRefCopyWithImpl(this._self, this._then);

  final _YearRef _self;
  final $Res Function(_YearRef) _then;

/// Create a copy of YearRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? libelle = null,}) {
  return _then(_YearRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$InvoiceLine {

 String get id; String get titre; String get type; int get montant; DateTime get dateLimite; int get montantPaye; int get resteAPayer; String get statut;
/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceLineCopyWith<InvoiceLine> get copyWith => _$InvoiceLineCopyWithImpl<InvoiceLine>(this as InvoiceLine, _$identity);

  /// Serializes this InvoiceLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InvoiceLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceLine&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.titre, _this.titre) || other.titre == _this.titre)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.dateLimite, _this.dateLimite) || other.dateLimite == _this.dateLimite)&&(identical(other.montantPaye, _this.montantPaye) || other.montantPaye == _this.montantPaye)&&(identical(other.resteAPayer, _this.resteAPayer) || other.resteAPayer == _this.resteAPayer)&&(identical(other.statut, _this.statut) || other.statut == _this.statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InvoiceLine;
  return Object.hash(runtimeType,_this.id,_this.titre,_this.type,_this.montant,_this.dateLimite,_this.montantPaye,_this.resteAPayer,_this.statut);
}

@override
String toString() {
  final _this = this as InvoiceLine;
  return 'InvoiceLine(id: ${_this.id}, titre: ${_this.titre}, type: ${_this.type}, montant: ${_this.montant}, dateLimite: ${_this.dateLimite}, montantPaye: ${_this.montantPaye}, resteAPayer: ${_this.resteAPayer}, statut: ${_this.statut})';
}


}

/// @nodoc
abstract mixin class $InvoiceLineCopyWith<$Res>  {
  factory $InvoiceLineCopyWith(InvoiceLine value, $Res Function(InvoiceLine) _then) = _$InvoiceLineCopyWithImpl;
@useResult
$Res call({
 String id, String titre, String type, int montant, DateTime dateLimite, int montantPaye, int resteAPayer, String statut
});




}
/// @nodoc
class _$InvoiceLineCopyWithImpl<$Res>
    implements $InvoiceLineCopyWith<$Res> {
  _$InvoiceLineCopyWithImpl(this._self, this._then);

  final InvoiceLine _self;
  final $Res Function(InvoiceLine) _then;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? type = null,Object? montant = null,Object? dateLimite = null,Object? montantPaye = null,Object? resteAPayer = null,Object? statut = null,}) {
  return _then(InvoiceLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,dateLimite: null == dateLimite ? _self.dateLimite : dateLimite // ignore: cast_nullable_to_non_nullable
as DateTime,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,resteAPayer: null == resteAPayer ? _self.resteAPayer : resteAPayer // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceLine].
extension InvoiceLinePatterns on InvoiceLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceLine value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceLine value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titre,  String type,  int montant,  DateTime dateLimite,  int montantPaye,  int resteAPayer,  String statut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that.id,_that.titre,_that.type,_that.montant,_that.dateLimite,_that.montantPaye,_that.resteAPayer,_that.statut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titre,  String type,  int montant,  DateTime dateLimite,  int montantPaye,  int resteAPayer,  String statut)  $default,) {final _that = this;
switch (_that) {
case _InvoiceLine():
return $default(_that.id,_that.titre,_that.type,_that.montant,_that.dateLimite,_that.montantPaye,_that.resteAPayer,_that.statut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titre,  String type,  int montant,  DateTime dateLimite,  int montantPaye,  int resteAPayer,  String statut)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceLine() when $default != null:
return $default(_that.id,_that.titre,_that.type,_that.montant,_that.dateLimite,_that.montantPaye,_that.resteAPayer,_that.statut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceLine implements InvoiceLine {
  const _InvoiceLine({required this.id, required this.titre, required this.type, required this.montant, required this.dateLimite, this.montantPaye = 0, this.resteAPayer = 0, this.statut = 'A_PAYER'});
  factory _InvoiceLine.fromJson(Map<String, dynamic> json) => _$InvoiceLineFromJson(json);

@override final  String id;
@override final  String titre;
@override final  String type;
@override final  int montant;
@override final  DateTime dateLimite;
@override@JsonKey() final  int montantPaye;
@override@JsonKey() final  int resteAPayer;
@override@JsonKey() final  String statut;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceLineCopyWith<_InvoiceLine> get copyWith => __$InvoiceLineCopyWithImpl<_InvoiceLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLine&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.type, type) || other.type == type)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.dateLimite, dateLimite) || other.dateLimite == dateLimite)&&(identical(other.montantPaye, montantPaye) || other.montantPaye == montantPaye)&&(identical(other.resteAPayer, resteAPayer) || other.resteAPayer == resteAPayer)&&(identical(other.statut, statut) || other.statut == statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,titre,type,montant,dateLimite,montantPaye,resteAPayer,statut);
}

@override
String toString() {
    return 'InvoiceLine(id: $id, titre: $titre, type: $type, montant: $montant, dateLimite: $dateLimite, montantPaye: $montantPaye, resteAPayer: $resteAPayer, statut: $statut)';
}


}

/// @nodoc
abstract mixin class _$InvoiceLineCopyWith<$Res> implements $InvoiceLineCopyWith<$Res> {
  factory _$InvoiceLineCopyWith(_InvoiceLine value, $Res Function(_InvoiceLine) _then) = __$InvoiceLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String titre, String type, int montant, DateTime dateLimite, int montantPaye, int resteAPayer, String statut
});




}
/// @nodoc
class __$InvoiceLineCopyWithImpl<$Res>
    implements _$InvoiceLineCopyWith<$Res> {
  __$InvoiceLineCopyWithImpl(this._self, this._then);

  final _InvoiceLine _self;
  final $Res Function(_InvoiceLine) _then;

/// Create a copy of InvoiceLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? type = null,Object? montant = null,Object? dateLimite = null,Object? montantPaye = null,Object? resteAPayer = null,Object? statut = null,}) {
  return _then(_InvoiceLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,dateLimite: null == dateLimite ? _self.dateLimite : dateLimite // ignore: cast_nullable_to_non_nullable
as DateTime,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,resteAPayer: null == resteAPayer ? _self.resteAPayer : resteAPayer // ignore: cast_nullable_to_non_nullable
as int,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReceiptRef {

 String get id; String get numeroRecu;
/// Create a copy of ReceiptRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptRefCopyWith<ReceiptRef> get copyWith => _$ReceiptRefCopyWithImpl<ReceiptRef>(this as ReceiptRef, _$identity);

  /// Serializes this ReceiptRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReceiptRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numeroRecu, _this.numeroRecu) || other.numeroRecu == _this.numeroRecu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReceiptRef;
  return Object.hash(runtimeType,_this.id,_this.numeroRecu);
}

@override
String toString() {
  final _this = this as ReceiptRef;
  return 'ReceiptRef(id: ${_this.id}, numeroRecu: ${_this.numeroRecu})';
}


}

/// @nodoc
abstract mixin class $ReceiptRefCopyWith<$Res>  {
  factory $ReceiptRefCopyWith(ReceiptRef value, $Res Function(ReceiptRef) _then) = _$ReceiptRefCopyWithImpl;
@useResult
$Res call({
 String id, String numeroRecu
});




}
/// @nodoc
class _$ReceiptRefCopyWithImpl<$Res>
    implements $ReceiptRefCopyWith<$Res> {
  _$ReceiptRefCopyWithImpl(this._self, this._then);

  final ReceiptRef _self;
  final $Res Function(ReceiptRef) _then;

/// Create a copy of ReceiptRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numeroRecu = null,}) {
  return _then(ReceiptRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroRecu: null == numeroRecu ? _self.numeroRecu : numeroRecu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptRef].
extension ReceiptRefPatterns on ReceiptRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptRef value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptRef value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String numeroRecu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptRef() when $default != null:
return $default(_that.id,_that.numeroRecu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String numeroRecu)  $default,) {final _that = this;
switch (_that) {
case _ReceiptRef():
return $default(_that.id,_that.numeroRecu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String numeroRecu)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptRef() when $default != null:
return $default(_that.id,_that.numeroRecu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptRef implements ReceiptRef {
  const _ReceiptRef({required this.id, required this.numeroRecu});
  factory _ReceiptRef.fromJson(Map<String, dynamic> json) => _$ReceiptRefFromJson(json);

@override final  String id;
@override final  String numeroRecu;

/// Create a copy of ReceiptRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptRefCopyWith<_ReceiptRef> get copyWith => __$ReceiptRefCopyWithImpl<_ReceiptRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptRef&&(identical(other.id, id) || other.id == id)&&(identical(other.numeroRecu, numeroRecu) || other.numeroRecu == numeroRecu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numeroRecu);
}

@override
String toString() {
    return 'ReceiptRef(id: $id, numeroRecu: $numeroRecu)';
}


}

/// @nodoc
abstract mixin class _$ReceiptRefCopyWith<$Res> implements $ReceiptRefCopyWith<$Res> {
  factory _$ReceiptRefCopyWith(_ReceiptRef value, $Res Function(_ReceiptRef) _then) = __$ReceiptRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String numeroRecu
});




}
/// @nodoc
class __$ReceiptRefCopyWithImpl<$Res>
    implements _$ReceiptRefCopyWith<$Res> {
  __$ReceiptRefCopyWithImpl(this._self, this._then);

  final _ReceiptRef _self;
  final $Res Function(_ReceiptRef) _then;

/// Create a copy of ReceiptRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numeroRecu = null,}) {
  return _then(_ReceiptRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroRecu: null == numeroRecu ? _self.numeroRecu : numeroRecu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PaymentRecord {

 String get id; String get reference; DateTime get date; int get montant; String get devise; String get statut; String get canal; bool get enLigne; String? get fournisseur; String? get referenceExterne; String get payeurType; String? get auteur; String? get enregistrePar; String get invoiceId; ReceiptRef? get receipt;
/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRecordCopyWith<PaymentRecord> get copyWith => _$PaymentRecordCopyWithImpl<PaymentRecord>(this as PaymentRecord, _$identity);

  /// Serializes this PaymentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.canal, _this.canal) || other.canal == _this.canal)&&(identical(other.enLigne, _this.enLigne) || other.enLigne == _this.enLigne)&&(identical(other.fournisseur, _this.fournisseur) || other.fournisseur == _this.fournisseur)&&(identical(other.referenceExterne, _this.referenceExterne) || other.referenceExterne == _this.referenceExterne)&&(identical(other.payeurType, _this.payeurType) || other.payeurType == _this.payeurType)&&(identical(other.auteur, _this.auteur) || other.auteur == _this.auteur)&&(identical(other.enregistrePar, _this.enregistrePar) || other.enregistrePar == _this.enregistrePar)&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.receipt, _this.receipt) || other.receipt == _this.receipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentRecord;
  return Object.hash(runtimeType,_this.id,_this.reference,_this.date,_this.montant,_this.devise,_this.statut,_this.canal,_this.enLigne,_this.fournisseur,_this.referenceExterne,_this.payeurType,_this.auteur,_this.enregistrePar,_this.invoiceId,_this.receipt);
}

@override
String toString() {
  final _this = this as PaymentRecord;
  return 'PaymentRecord(id: ${_this.id}, reference: ${_this.reference}, date: ${_this.date}, montant: ${_this.montant}, devise: ${_this.devise}, statut: ${_this.statut}, canal: ${_this.canal}, enLigne: ${_this.enLigne}, fournisseur: ${_this.fournisseur}, referenceExterne: ${_this.referenceExterne}, payeurType: ${_this.payeurType}, auteur: ${_this.auteur}, enregistrePar: ${_this.enregistrePar}, invoiceId: ${_this.invoiceId}, receipt: ${_this.receipt})';
}


}

/// @nodoc
abstract mixin class $PaymentRecordCopyWith<$Res>  {
  factory $PaymentRecordCopyWith(PaymentRecord value, $Res Function(PaymentRecord) _then) = _$PaymentRecordCopyWithImpl;
@useResult
$Res call({
 String id, String reference, DateTime date, int montant, String devise, String statut, String canal, bool enLigne, String? fournisseur, String? referenceExterne, String payeurType, String? auteur, String? enregistrePar, String invoiceId, ReceiptRef? receipt
});


$ReceiptRefCopyWith<$Res>? get receipt;

}
/// @nodoc
class _$PaymentRecordCopyWithImpl<$Res>
    implements $PaymentRecordCopyWith<$Res> {
  _$PaymentRecordCopyWithImpl(this._self, this._then);

  final PaymentRecord _self;
  final $Res Function(PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reference = null,Object? date = null,Object? montant = null,Object? devise = null,Object? statut = null,Object? canal = null,Object? enLigne = null,Object? fournisseur = freezed,Object? referenceExterne = freezed,Object? payeurType = null,Object? auteur = freezed,Object? enregistrePar = freezed,Object? invoiceId = null,Object? receipt = freezed,}) {
  return _then(PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,canal: null == canal ? _self.canal : canal // ignore: cast_nullable_to_non_nullable
as String,enLigne: null == enLigne ? _self.enLigne : enLigne // ignore: cast_nullable_to_non_nullable
as bool,fournisseur: freezed == fournisseur ? _self.fournisseur : fournisseur // ignore: cast_nullable_to_non_nullable
as String?,referenceExterne: freezed == referenceExterne ? _self.referenceExterne : referenceExterne // ignore: cast_nullable_to_non_nullable
as String?,payeurType: null == payeurType ? _self.payeurType : payeurType // ignore: cast_nullable_to_non_nullable
as String,auteur: freezed == auteur ? _self.auteur : auteur // ignore: cast_nullable_to_non_nullable
as String?,enregistrePar: freezed == enregistrePar ? _self.enregistrePar : enregistrePar // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptRef?,
  ));
}
/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptRefCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $ReceiptRefCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentRecord].
extension PaymentRecordPatterns on PaymentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRecord value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reference,  DateTime date,  int montant,  String devise,  String statut,  String canal,  bool enLigne,  String? fournisseur,  String? referenceExterne,  String payeurType,  String? auteur,  String? enregistrePar,  String invoiceId,  ReceiptRef? receipt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.reference,_that.date,_that.montant,_that.devise,_that.statut,_that.canal,_that.enLigne,_that.fournisseur,_that.referenceExterne,_that.payeurType,_that.auteur,_that.enregistrePar,_that.invoiceId,_that.receipt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reference,  DateTime date,  int montant,  String devise,  String statut,  String canal,  bool enLigne,  String? fournisseur,  String? referenceExterne,  String payeurType,  String? auteur,  String? enregistrePar,  String invoiceId,  ReceiptRef? receipt)  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord():
return $default(_that.id,_that.reference,_that.date,_that.montant,_that.devise,_that.statut,_that.canal,_that.enLigne,_that.fournisseur,_that.referenceExterne,_that.payeurType,_that.auteur,_that.enregistrePar,_that.invoiceId,_that.receipt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reference,  DateTime date,  int montant,  String devise,  String statut,  String canal,  bool enLigne,  String? fournisseur,  String? referenceExterne,  String payeurType,  String? auteur,  String? enregistrePar,  String invoiceId,  ReceiptRef? receipt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.reference,_that.date,_that.montant,_that.devise,_that.statut,_that.canal,_that.enLigne,_that.fournisseur,_that.referenceExterne,_that.payeurType,_that.auteur,_that.enregistrePar,_that.invoiceId,_that.receipt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentRecord implements PaymentRecord {
  const _PaymentRecord({required this.id, required this.reference, required this.date, required this.montant, this.devise = 'XAF', required this.statut, required this.canal, this.enLigne = false, this.fournisseur, this.referenceExterne, this.payeurType = 'PARENT', this.auteur, this.enregistrePar, required this.invoiceId, this.receipt});
  factory _PaymentRecord.fromJson(Map<String, dynamic> json) => _$PaymentRecordFromJson(json);

@override final  String id;
@override final  String reference;
@override final  DateTime date;
@override final  int montant;
@override@JsonKey() final  String devise;
@override final  String statut;
@override final  String canal;
@override@JsonKey() final  bool enLigne;
@override final  String? fournisseur;
@override final  String? referenceExterne;
@override@JsonKey() final  String payeurType;
@override final  String? auteur;
@override final  String? enregistrePar;
@override final  String invoiceId;
@override final  ReceiptRef? receipt;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRecordCopyWith<_PaymentRecord> get copyWith => __$PaymentRecordCopyWithImpl<_PaymentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.date, date) || other.date == date)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.canal, canal) || other.canal == canal)&&(identical(other.enLigne, enLigne) || other.enLigne == enLigne)&&(identical(other.fournisseur, fournisseur) || other.fournisseur == fournisseur)&&(identical(other.referenceExterne, referenceExterne) || other.referenceExterne == referenceExterne)&&(identical(other.payeurType, payeurType) || other.payeurType == payeurType)&&(identical(other.auteur, auteur) || other.auteur == auteur)&&(identical(other.enregistrePar, enregistrePar) || other.enregistrePar == enregistrePar)&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.receipt, receipt) || other.receipt == receipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,reference,date,montant,devise,statut,canal,enLigne,fournisseur,referenceExterne,payeurType,auteur,enregistrePar,invoiceId,receipt);
}

@override
String toString() {
    return 'PaymentRecord(id: $id, reference: $reference, date: $date, montant: $montant, devise: $devise, statut: $statut, canal: $canal, enLigne: $enLigne, fournisseur: $fournisseur, referenceExterne: $referenceExterne, payeurType: $payeurType, auteur: $auteur, enregistrePar: $enregistrePar, invoiceId: $invoiceId, receipt: $receipt)';
}


}

/// @nodoc
abstract mixin class _$PaymentRecordCopyWith<$Res> implements $PaymentRecordCopyWith<$Res> {
  factory _$PaymentRecordCopyWith(_PaymentRecord value, $Res Function(_PaymentRecord) _then) = __$PaymentRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String reference, DateTime date, int montant, String devise, String statut, String canal, bool enLigne, String? fournisseur, String? referenceExterne, String payeurType, String? auteur, String? enregistrePar, String invoiceId, ReceiptRef? receipt
});


@override $ReceiptRefCopyWith<$Res>? get receipt;

}
/// @nodoc
class __$PaymentRecordCopyWithImpl<$Res>
    implements _$PaymentRecordCopyWith<$Res> {
  __$PaymentRecordCopyWithImpl(this._self, this._then);

  final _PaymentRecord _self;
  final $Res Function(_PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reference = null,Object? date = null,Object? montant = null,Object? devise = null,Object? statut = null,Object? canal = null,Object? enLigne = null,Object? fournisseur = freezed,Object? referenceExterne = freezed,Object? payeurType = null,Object? auteur = freezed,Object? enregistrePar = freezed,Object? invoiceId = null,Object? receipt = freezed,}) {
  return _then(_PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,canal: null == canal ? _self.canal : canal // ignore: cast_nullable_to_non_nullable
as String,enLigne: null == enLigne ? _self.enLigne : enLigne // ignore: cast_nullable_to_non_nullable
as bool,fournisseur: freezed == fournisseur ? _self.fournisseur : fournisseur // ignore: cast_nullable_to_non_nullable
as String?,referenceExterne: freezed == referenceExterne ? _self.referenceExterne : referenceExterne // ignore: cast_nullable_to_non_nullable
as String?,payeurType: null == payeurType ? _self.payeurType : payeurType // ignore: cast_nullable_to_non_nullable
as String,auteur: freezed == auteur ? _self.auteur : auteur // ignore: cast_nullable_to_non_nullable
as String?,enregistrePar: freezed == enregistrePar ? _self.enregistrePar : enregistrePar // ignore: cast_nullable_to_non_nullable
as String?,invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptRef?,
  ));
}

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptRefCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $ReceiptRefCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}


/// @nodoc
mixin _$InstallmentRequest {

 String get id; String get statut; int get nombreTranches; String get motif; String? get reponse; DateTime get createdAt;
/// Create a copy of InstallmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstallmentRequestCopyWith<InstallmentRequest> get copyWith => _$InstallmentRequestCopyWithImpl<InstallmentRequest>(this as InstallmentRequest, _$identity);

  /// Serializes this InstallmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InstallmentRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstallmentRequest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.nombreTranches, _this.nombreTranches) || other.nombreTranches == _this.nombreTranches)&&(identical(other.motif, _this.motif) || other.motif == _this.motif)&&(identical(other.reponse, _this.reponse) || other.reponse == _this.reponse)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InstallmentRequest;
  return Object.hash(runtimeType,_this.id,_this.statut,_this.nombreTranches,_this.motif,_this.reponse,_this.createdAt);
}

@override
String toString() {
  final _this = this as InstallmentRequest;
  return 'InstallmentRequest(id: ${_this.id}, statut: ${_this.statut}, nombreTranches: ${_this.nombreTranches}, motif: ${_this.motif}, reponse: ${_this.reponse}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $InstallmentRequestCopyWith<$Res>  {
  factory $InstallmentRequestCopyWith(InstallmentRequest value, $Res Function(InstallmentRequest) _then) = _$InstallmentRequestCopyWithImpl;
@useResult
$Res call({
 String id, String statut, int nombreTranches, String motif, String? reponse, DateTime createdAt
});




}
/// @nodoc
class _$InstallmentRequestCopyWithImpl<$Res>
    implements $InstallmentRequestCopyWith<$Res> {
  _$InstallmentRequestCopyWithImpl(this._self, this._then);

  final InstallmentRequest _self;
  final $Res Function(InstallmentRequest) _then;

/// Create a copy of InstallmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statut = null,Object? nombreTranches = null,Object? motif = null,Object? reponse = freezed,Object? createdAt = null,}) {
  return _then(InstallmentRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,nombreTranches: null == nombreTranches ? _self.nombreTranches : nombreTranches // ignore: cast_nullable_to_non_nullable
as int,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,reponse: freezed == reponse ? _self.reponse : reponse // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InstallmentRequest].
extension InstallmentRequestPatterns on InstallmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstallmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstallmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstallmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _InstallmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstallmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _InstallmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String statut,  int nombreTranches,  String motif,  String? reponse,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstallmentRequest() when $default != null:
return $default(_that.id,_that.statut,_that.nombreTranches,_that.motif,_that.reponse,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String statut,  int nombreTranches,  String motif,  String? reponse,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InstallmentRequest():
return $default(_that.id,_that.statut,_that.nombreTranches,_that.motif,_that.reponse,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String statut,  int nombreTranches,  String motif,  String? reponse,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InstallmentRequest() when $default != null:
return $default(_that.id,_that.statut,_that.nombreTranches,_that.motif,_that.reponse,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstallmentRequest implements InstallmentRequest {
  const _InstallmentRequest({required this.id, required this.statut, required this.nombreTranches, required this.motif, this.reponse, required this.createdAt});
  factory _InstallmentRequest.fromJson(Map<String, dynamic> json) => _$InstallmentRequestFromJson(json);

@override final  String id;
@override final  String statut;
@override final  int nombreTranches;
@override final  String motif;
@override final  String? reponse;
@override final  DateTime createdAt;

/// Create a copy of InstallmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstallmentRequestCopyWith<_InstallmentRequest> get copyWith => __$InstallmentRequestCopyWithImpl<_InstallmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstallmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstallmentRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.nombreTranches, nombreTranches) || other.nombreTranches == nombreTranches)&&(identical(other.motif, motif) || other.motif == motif)&&(identical(other.reponse, reponse) || other.reponse == reponse)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,statut,nombreTranches,motif,reponse,createdAt);
}

@override
String toString() {
    return 'InstallmentRequest(id: $id, statut: $statut, nombreTranches: $nombreTranches, motif: $motif, reponse: $reponse, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InstallmentRequestCopyWith<$Res> implements $InstallmentRequestCopyWith<$Res> {
  factory _$InstallmentRequestCopyWith(_InstallmentRequest value, $Res Function(_InstallmentRequest) _then) = __$InstallmentRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String statut, int nombreTranches, String motif, String? reponse, DateTime createdAt
});




}
/// @nodoc
class __$InstallmentRequestCopyWithImpl<$Res>
    implements _$InstallmentRequestCopyWith<$Res> {
  __$InstallmentRequestCopyWithImpl(this._self, this._then);

  final _InstallmentRequest _self;
  final $Res Function(_InstallmentRequest) _then;

/// Create a copy of InstallmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statut = null,Object? nombreTranches = null,Object? motif = null,Object? reponse = freezed,Object? createdAt = null,}) {
  return _then(_InstallmentRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,nombreTranches: null == nombreTranches ? _self.nombreTranches : nombreTranches // ignore: cast_nullable_to_non_nullable
as int,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,reponse: freezed == reponse ? _self.reponse : reponse // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Invoice {

 String get id; String get numeroFacture; int get montantTotal; int get montantPaye; int get soldeRestant; String get devise; String get statut; DateTime get dateEcheance; YearRef? get academicYear; List<InvoiceLine> get lines; List<PaymentRecord> get payments; List<InstallmentRequest> get installmentRequests;
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceCopyWith<Invoice> get copyWith => _$InvoiceCopyWithImpl<Invoice>(this as Invoice, _$identity);

  /// Serializes this Invoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Invoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Invoice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numeroFacture, _this.numeroFacture) || other.numeroFacture == _this.numeroFacture)&&(identical(other.montantTotal, _this.montantTotal) || other.montantTotal == _this.montantTotal)&&(identical(other.montantPaye, _this.montantPaye) || other.montantPaye == _this.montantPaye)&&(identical(other.soldeRestant, _this.soldeRestant) || other.soldeRestant == _this.soldeRestant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.dateEcheance, _this.dateEcheance) || other.dateEcheance == _this.dateEcheance)&&(identical(other.academicYear, _this.academicYear) || other.academicYear == _this.academicYear)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.payments, _this.payments)&&const DeepCollectionEquality().equals(other.installmentRequests, _this.installmentRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Invoice;
  return Object.hash(runtimeType,_this.id,_this.numeroFacture,_this.montantTotal,_this.montantPaye,_this.soldeRestant,_this.devise,_this.statut,_this.dateEcheance,_this.academicYear,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.payments),const DeepCollectionEquality().hash(_this.installmentRequests));
}

@override
String toString() {
  final _this = this as Invoice;
  return 'Invoice(id: ${_this.id}, numeroFacture: ${_this.numeroFacture}, montantTotal: ${_this.montantTotal}, montantPaye: ${_this.montantPaye}, soldeRestant: ${_this.soldeRestant}, devise: ${_this.devise}, statut: ${_this.statut}, dateEcheance: ${_this.dateEcheance}, academicYear: ${_this.academicYear}, lines: ${_this.lines}, payments: ${_this.payments}, installmentRequests: ${_this.installmentRequests})';
}


}

/// @nodoc
abstract mixin class $InvoiceCopyWith<$Res>  {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) _then) = _$InvoiceCopyWithImpl;
@useResult
$Res call({
 String id, String numeroFacture, int montantTotal, int montantPaye, int soldeRestant, String devise, String statut, DateTime dateEcheance, YearRef? academicYear, List<InvoiceLine> lines, List<PaymentRecord> payments, List<InstallmentRequest> installmentRequests
});


$YearRefCopyWith<$Res>? get academicYear;

}
/// @nodoc
class _$InvoiceCopyWithImpl<$Res>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._self, this._then);

  final Invoice _self;
  final $Res Function(Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numeroFacture = null,Object? montantTotal = null,Object? montantPaye = null,Object? soldeRestant = null,Object? devise = null,Object? statut = null,Object? dateEcheance = null,Object? academicYear = freezed,Object? lines = null,Object? payments = null,Object? installmentRequests = null,}) {
  return _then(Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroFacture: null == numeroFacture ? _self.numeroFacture : numeroFacture // ignore: cast_nullable_to_non_nullable
as String,montantTotal: null == montantTotal ? _self.montantTotal : montantTotal // ignore: cast_nullable_to_non_nullable
as int,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,soldeRestant: null == soldeRestant ? _self.soldeRestant : soldeRestant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,dateEcheance: null == dateEcheance ? _self.dateEcheance : dateEcheance // ignore: cast_nullable_to_non_nullable
as DateTime,academicYear: freezed == academicYear ? _self.academicYear : academicYear // ignore: cast_nullable_to_non_nullable
as YearRef?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceLine>,payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentRecord>,installmentRequests: null == installmentRequests ? _self.installmentRequests : installmentRequests // ignore: cast_nullable_to_non_nullable
as List<InstallmentRequest>,
  ));
}
/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearRefCopyWith<$Res>? get academicYear {
    if (_self.academicYear == null) {
    return null;
  }

  return $YearRefCopyWith<$Res>(_self.academicYear!, (value) {
    return _then(_self.copyWith(academicYear: value));
  });
}
}


/// Adds pattern-matching-related methods to [Invoice].
extension InvoicePatterns on Invoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Invoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Invoice value)  $default,){
final _that = this;
switch (_that) {
case _Invoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Invoice value)?  $default,){
final _that = this;
switch (_that) {
case _Invoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String numeroFacture,  int montantTotal,  int montantPaye,  int soldeRestant,  String devise,  String statut,  DateTime dateEcheance,  YearRef? academicYear,  List<InvoiceLine> lines,  List<PaymentRecord> payments,  List<InstallmentRequest> installmentRequests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.numeroFacture,_that.montantTotal,_that.montantPaye,_that.soldeRestant,_that.devise,_that.statut,_that.dateEcheance,_that.academicYear,_that.lines,_that.payments,_that.installmentRequests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String numeroFacture,  int montantTotal,  int montantPaye,  int soldeRestant,  String devise,  String statut,  DateTime dateEcheance,  YearRef? academicYear,  List<InvoiceLine> lines,  List<PaymentRecord> payments,  List<InstallmentRequest> installmentRequests)  $default,) {final _that = this;
switch (_that) {
case _Invoice():
return $default(_that.id,_that.numeroFacture,_that.montantTotal,_that.montantPaye,_that.soldeRestant,_that.devise,_that.statut,_that.dateEcheance,_that.academicYear,_that.lines,_that.payments,_that.installmentRequests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String numeroFacture,  int montantTotal,  int montantPaye,  int soldeRestant,  String devise,  String statut,  DateTime dateEcheance,  YearRef? academicYear,  List<InvoiceLine> lines,  List<PaymentRecord> payments,  List<InstallmentRequest> installmentRequests)?  $default,) {final _that = this;
switch (_that) {
case _Invoice() when $default != null:
return $default(_that.id,_that.numeroFacture,_that.montantTotal,_that.montantPaye,_that.soldeRestant,_that.devise,_that.statut,_that.dateEcheance,_that.academicYear,_that.lines,_that.payments,_that.installmentRequests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Invoice extends Invoice {
  const _Invoice({required this.id, required this.numeroFacture, required this.montantTotal, required this.montantPaye, required this.soldeRestant, this.devise = 'XAF', required this.statut, required this.dateEcheance, this.academicYear,  List<InvoiceLine> lines = const [],  List<PaymentRecord> payments = const [],  List<InstallmentRequest> installmentRequests = const []}): _lines = lines,_payments = payments,_installmentRequests = installmentRequests,super._();
  factory _Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

@override final  String id;
@override final  String numeroFacture;
@override final  int montantTotal;
@override final  int montantPaye;
@override final  int soldeRestant;
@override@JsonKey() final  String devise;
@override final  String statut;
@override final  DateTime dateEcheance;
@override final  YearRef? academicYear;
 final  List<InvoiceLine> _lines;
@override@JsonKey() List<InvoiceLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<PaymentRecord> _payments;
@override@JsonKey() List<PaymentRecord> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

 final  List<InstallmentRequest> _installmentRequests;
@override@JsonKey() List<InstallmentRequest> get installmentRequests {
  if (_installmentRequests is EqualUnmodifiableListView) return _installmentRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_installmentRequests);
}


/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceCopyWith<_Invoice> get copyWith => __$InvoiceCopyWithImpl<_Invoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invoice&&(identical(other.id, id) || other.id == id)&&(identical(other.numeroFacture, numeroFacture) || other.numeroFacture == numeroFacture)&&(identical(other.montantTotal, montantTotal) || other.montantTotal == montantTotal)&&(identical(other.montantPaye, montantPaye) || other.montantPaye == montantPaye)&&(identical(other.soldeRestant, soldeRestant) || other.soldeRestant == soldeRestant)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.dateEcheance, dateEcheance) || other.dateEcheance == dateEcheance)&&(identical(other.academicYear, academicYear) || other.academicYear == academicYear)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.payments, _payments)&&const DeepCollectionEquality().equals(other.installmentRequests, _installmentRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numeroFacture,montantTotal,montantPaye,soldeRestant,devise,statut,dateEcheance,academicYear,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_payments),const DeepCollectionEquality().hash(_installmentRequests));
}

@override
String toString() {
    return 'Invoice(id: $id, numeroFacture: $numeroFacture, montantTotal: $montantTotal, montantPaye: $montantPaye, soldeRestant: $soldeRestant, devise: $devise, statut: $statut, dateEcheance: $dateEcheance, academicYear: $academicYear, lines: $lines, payments: $payments, installmentRequests: $installmentRequests)';
}


}

/// @nodoc
abstract mixin class _$InvoiceCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$InvoiceCopyWith(_Invoice value, $Res Function(_Invoice) _then) = __$InvoiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String numeroFacture, int montantTotal, int montantPaye, int soldeRestant, String devise, String statut, DateTime dateEcheance, YearRef? academicYear, List<InvoiceLine> lines, List<PaymentRecord> payments, List<InstallmentRequest> installmentRequests
});


@override $YearRefCopyWith<$Res>? get academicYear;

}
/// @nodoc
class __$InvoiceCopyWithImpl<$Res>
    implements _$InvoiceCopyWith<$Res> {
  __$InvoiceCopyWithImpl(this._self, this._then);

  final _Invoice _self;
  final $Res Function(_Invoice) _then;

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numeroFacture = null,Object? montantTotal = null,Object? montantPaye = null,Object? soldeRestant = null,Object? devise = null,Object? statut = null,Object? dateEcheance = null,Object? academicYear = freezed,Object? lines = null,Object? payments = null,Object? installmentRequests = null,}) {
  return _then(_Invoice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroFacture: null == numeroFacture ? _self.numeroFacture : numeroFacture // ignore: cast_nullable_to_non_nullable
as String,montantTotal: null == montantTotal ? _self.montantTotal : montantTotal // ignore: cast_nullable_to_non_nullable
as int,montantPaye: null == montantPaye ? _self.montantPaye : montantPaye // ignore: cast_nullable_to_non_nullable
as int,soldeRestant: null == soldeRestant ? _self.soldeRestant : soldeRestant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,dateEcheance: null == dateEcheance ? _self.dateEcheance : dateEcheance // ignore: cast_nullable_to_non_nullable
as DateTime,academicYear: freezed == academicYear ? _self.academicYear : academicYear // ignore: cast_nullable_to_non_nullable
as YearRef?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceLine>,payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentRecord>,installmentRequests: null == installmentRequests ? _self._installmentRequests : installmentRequests // ignore: cast_nullable_to_non_nullable
as List<InstallmentRequest>,
  ));
}

/// Create a copy of Invoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$YearRefCopyWith<$Res>? get academicYear {
    if (_self.academicYear == null) {
    return null;
  }

  return $YearRefCopyWith<$Res>(_self.academicYear!, (value) {
    return _then(_self.copyWith(academicYear: value));
  });
}
}


/// @nodoc
mixin _$YearBalance {

 String get academicYearId; String get libelle; int get total; int get paye; int get reste;
/// Create a copy of YearBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$YearBalanceCopyWith<YearBalance> get copyWith => _$YearBalanceCopyWithImpl<YearBalance>(this as YearBalance, _$identity);

  /// Serializes this YearBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as YearBalance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is YearBalance&&(identical(other.academicYearId, _this.academicYearId) || other.academicYearId == _this.academicYearId)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.paye, _this.paye) || other.paye == _this.paye)&&(identical(other.reste, _this.reste) || other.reste == _this.reste));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as YearBalance;
  return Object.hash(runtimeType,_this.academicYearId,_this.libelle,_this.total,_this.paye,_this.reste);
}

@override
String toString() {
  final _this = this as YearBalance;
  return 'YearBalance(academicYearId: ${_this.academicYearId}, libelle: ${_this.libelle}, total: ${_this.total}, paye: ${_this.paye}, reste: ${_this.reste})';
}


}

/// @nodoc
abstract mixin class $YearBalanceCopyWith<$Res>  {
  factory $YearBalanceCopyWith(YearBalance value, $Res Function(YearBalance) _then) = _$YearBalanceCopyWithImpl;
@useResult
$Res call({
 String academicYearId, String libelle, int total, int paye, int reste
});




}
/// @nodoc
class _$YearBalanceCopyWithImpl<$Res>
    implements $YearBalanceCopyWith<$Res> {
  _$YearBalanceCopyWithImpl(this._self, this._then);

  final YearBalance _self;
  final $Res Function(YearBalance) _then;

/// Create a copy of YearBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? academicYearId = null,Object? libelle = null,Object? total = null,Object? paye = null,Object? reste = null,}) {
  return _then(YearBalance(
academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,paye: null == paye ? _self.paye : paye // ignore: cast_nullable_to_non_nullable
as int,reste: null == reste ? _self.reste : reste // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [YearBalance].
extension YearBalancePatterns on YearBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _YearBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _YearBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _YearBalance value)  $default,){
final _that = this;
switch (_that) {
case _YearBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _YearBalance value)?  $default,){
final _that = this;
switch (_that) {
case _YearBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String academicYearId,  String libelle,  int total,  int paye,  int reste)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _YearBalance() when $default != null:
return $default(_that.academicYearId,_that.libelle,_that.total,_that.paye,_that.reste);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String academicYearId,  String libelle,  int total,  int paye,  int reste)  $default,) {final _that = this;
switch (_that) {
case _YearBalance():
return $default(_that.academicYearId,_that.libelle,_that.total,_that.paye,_that.reste);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String academicYearId,  String libelle,  int total,  int paye,  int reste)?  $default,) {final _that = this;
switch (_that) {
case _YearBalance() when $default != null:
return $default(_that.academicYearId,_that.libelle,_that.total,_that.paye,_that.reste);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _YearBalance implements YearBalance {
  const _YearBalance({required this.academicYearId, required this.libelle, required this.total, required this.paye, required this.reste});
  factory _YearBalance.fromJson(Map<String, dynamic> json) => _$YearBalanceFromJson(json);

@override final  String academicYearId;
@override final  String libelle;
@override final  int total;
@override final  int paye;
@override final  int reste;

/// Create a copy of YearBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$YearBalanceCopyWith<_YearBalance> get copyWith => __$YearBalanceCopyWithImpl<_YearBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$YearBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _YearBalance&&(identical(other.academicYearId, academicYearId) || other.academicYearId == academicYearId)&&(identical(other.libelle, libelle) || other.libelle == libelle)&&(identical(other.total, total) || other.total == total)&&(identical(other.paye, paye) || other.paye == paye)&&(identical(other.reste, reste) || other.reste == reste));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,academicYearId,libelle,total,paye,reste);
}

@override
String toString() {
    return 'YearBalance(academicYearId: $academicYearId, libelle: $libelle, total: $total, paye: $paye, reste: $reste)';
}


}

/// @nodoc
abstract mixin class _$YearBalanceCopyWith<$Res> implements $YearBalanceCopyWith<$Res> {
  factory _$YearBalanceCopyWith(_YearBalance value, $Res Function(_YearBalance) _then) = __$YearBalanceCopyWithImpl;
@override @useResult
$Res call({
 String academicYearId, String libelle, int total, int paye, int reste
});




}
/// @nodoc
class __$YearBalanceCopyWithImpl<$Res>
    implements _$YearBalanceCopyWith<$Res> {
  __$YearBalanceCopyWithImpl(this._self, this._then);

  final _YearBalance _self;
  final $Res Function(_YearBalance) _then;

/// Create a copy of YearBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? academicYearId = null,Object? libelle = null,Object? total = null,Object? paye = null,Object? reste = null,}) {
  return _then(_YearBalance(
academicYearId: null == academicYearId ? _self.academicYearId : academicYearId // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,paye: null == paye ? _self.paye : paye // ignore: cast_nullable_to_non_nullable
as int,reste: null == reste ? _self.reste : reste // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonthlyPayment {

 String get mois; int get montant; int get cumul;
/// Create a copy of MonthlyPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyPaymentCopyWith<MonthlyPayment> get copyWith => _$MonthlyPaymentCopyWithImpl<MonthlyPayment>(this as MonthlyPayment, _$identity);

  /// Serializes this MonthlyPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MonthlyPayment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyPayment&&(identical(other.mois, _this.mois) || other.mois == _this.mois)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.cumul, _this.cumul) || other.cumul == _this.cumul));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MonthlyPayment;
  return Object.hash(runtimeType,_this.mois,_this.montant,_this.cumul);
}

@override
String toString() {
  final _this = this as MonthlyPayment;
  return 'MonthlyPayment(mois: ${_this.mois}, montant: ${_this.montant}, cumul: ${_this.cumul})';
}


}

/// @nodoc
abstract mixin class $MonthlyPaymentCopyWith<$Res>  {
  factory $MonthlyPaymentCopyWith(MonthlyPayment value, $Res Function(MonthlyPayment) _then) = _$MonthlyPaymentCopyWithImpl;
@useResult
$Res call({
 String mois, int montant, int cumul
});




}
/// @nodoc
class _$MonthlyPaymentCopyWithImpl<$Res>
    implements $MonthlyPaymentCopyWith<$Res> {
  _$MonthlyPaymentCopyWithImpl(this._self, this._then);

  final MonthlyPayment _self;
  final $Res Function(MonthlyPayment) _then;

/// Create a copy of MonthlyPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mois = null,Object? montant = null,Object? cumul = null,}) {
  return _then(MonthlyPayment(
mois: null == mois ? _self.mois : mois // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,cumul: null == cumul ? _self.cumul : cumul // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyPayment].
extension MonthlyPaymentPatterns on MonthlyPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyPayment value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyPayment value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mois,  int montant,  int cumul)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyPayment() when $default != null:
return $default(_that.mois,_that.montant,_that.cumul);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mois,  int montant,  int cumul)  $default,) {final _that = this;
switch (_that) {
case _MonthlyPayment():
return $default(_that.mois,_that.montant,_that.cumul);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mois,  int montant,  int cumul)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyPayment() when $default != null:
return $default(_that.mois,_that.montant,_that.cumul);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyPayment implements MonthlyPayment {
  const _MonthlyPayment({required this.mois, required this.montant, required this.cumul});
  factory _MonthlyPayment.fromJson(Map<String, dynamic> json) => _$MonthlyPaymentFromJson(json);

@override final  String mois;
@override final  int montant;
@override final  int cumul;

/// Create a copy of MonthlyPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyPaymentCopyWith<_MonthlyPayment> get copyWith => __$MonthlyPaymentCopyWithImpl<_MonthlyPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyPayment&&(identical(other.mois, mois) || other.mois == mois)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.cumul, cumul) || other.cumul == cumul));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mois,montant,cumul);
}

@override
String toString() {
    return 'MonthlyPayment(mois: $mois, montant: $montant, cumul: $cumul)';
}


}

/// @nodoc
abstract mixin class _$MonthlyPaymentCopyWith<$Res> implements $MonthlyPaymentCopyWith<$Res> {
  factory _$MonthlyPaymentCopyWith(_MonthlyPayment value, $Res Function(_MonthlyPayment) _then) = __$MonthlyPaymentCopyWithImpl;
@override @useResult
$Res call({
 String mois, int montant, int cumul
});




}
/// @nodoc
class __$MonthlyPaymentCopyWithImpl<$Res>
    implements _$MonthlyPaymentCopyWith<$Res> {
  __$MonthlyPaymentCopyWithImpl(this._self, this._then);

  final _MonthlyPayment _self;
  final $Res Function(_MonthlyPayment) _then;

/// Create a copy of MonthlyPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mois = null,Object? montant = null,Object? cumul = null,}) {
  return _then(_MonthlyPayment(
mois: null == mois ? _self.mois : mois // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,cumul: null == cumul ? _self.cumul : cumul // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FinanceSummary {

 List<YearBalance> get parAnnee; List<MonthlyPayment> get evolution;
/// Create a copy of FinanceSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceSummaryCopyWith<FinanceSummary> get copyWith => _$FinanceSummaryCopyWithImpl<FinanceSummary>(this as FinanceSummary, _$identity);

  /// Serializes this FinanceSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinanceSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceSummary&&const DeepCollectionEquality().equals(other.parAnnee, _this.parAnnee)&&const DeepCollectionEquality().equals(other.evolution, _this.evolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinanceSummary;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.parAnnee),const DeepCollectionEquality().hash(_this.evolution));
}

@override
String toString() {
  final _this = this as FinanceSummary;
  return 'FinanceSummary(parAnnee: ${_this.parAnnee}, evolution: ${_this.evolution})';
}


}

/// @nodoc
abstract mixin class $FinanceSummaryCopyWith<$Res>  {
  factory $FinanceSummaryCopyWith(FinanceSummary value, $Res Function(FinanceSummary) _then) = _$FinanceSummaryCopyWithImpl;
@useResult
$Res call({
 List<YearBalance> parAnnee, List<MonthlyPayment> evolution
});




}
/// @nodoc
class _$FinanceSummaryCopyWithImpl<$Res>
    implements $FinanceSummaryCopyWith<$Res> {
  _$FinanceSummaryCopyWithImpl(this._self, this._then);

  final FinanceSummary _self;
  final $Res Function(FinanceSummary) _then;

/// Create a copy of FinanceSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parAnnee = null,Object? evolution = null,}) {
  return _then(FinanceSummary(
parAnnee: null == parAnnee ? _self.parAnnee : parAnnee // ignore: cast_nullable_to_non_nullable
as List<YearBalance>,evolution: null == evolution ? _self.evolution : evolution // ignore: cast_nullable_to_non_nullable
as List<MonthlyPayment>,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceSummary].
extension FinanceSummaryPatterns on FinanceSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinanceSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<YearBalance> parAnnee,  List<MonthlyPayment> evolution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceSummary() when $default != null:
return $default(_that.parAnnee,_that.evolution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<YearBalance> parAnnee,  List<MonthlyPayment> evolution)  $default,) {final _that = this;
switch (_that) {
case _FinanceSummary():
return $default(_that.parAnnee,_that.evolution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<YearBalance> parAnnee,  List<MonthlyPayment> evolution)?  $default,) {final _that = this;
switch (_that) {
case _FinanceSummary() when $default != null:
return $default(_that.parAnnee,_that.evolution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceSummary implements FinanceSummary {
  const _FinanceSummary({ List<YearBalance> parAnnee = const [],  List<MonthlyPayment> evolution = const []}): _parAnnee = parAnnee,_evolution = evolution;
  factory _FinanceSummary.fromJson(Map<String, dynamic> json) => _$FinanceSummaryFromJson(json);

 final  List<YearBalance> _parAnnee;
@override@JsonKey() List<YearBalance> get parAnnee {
  if (_parAnnee is EqualUnmodifiableListView) return _parAnnee;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parAnnee);
}

 final  List<MonthlyPayment> _evolution;
@override@JsonKey() List<MonthlyPayment> get evolution {
  if (_evolution is EqualUnmodifiableListView) return _evolution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evolution);
}


/// Create a copy of FinanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceSummaryCopyWith<_FinanceSummary> get copyWith => __$FinanceSummaryCopyWithImpl<_FinanceSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceSummary&&const DeepCollectionEquality().equals(other.parAnnee, _parAnnee)&&const DeepCollectionEquality().equals(other.evolution, _evolution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_parAnnee),const DeepCollectionEquality().hash(_evolution));
}

@override
String toString() {
    return 'FinanceSummary(parAnnee: $parAnnee, evolution: $evolution)';
}


}

/// @nodoc
abstract mixin class _$FinanceSummaryCopyWith<$Res> implements $FinanceSummaryCopyWith<$Res> {
  factory _$FinanceSummaryCopyWith(_FinanceSummary value, $Res Function(_FinanceSummary) _then) = __$FinanceSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<YearBalance> parAnnee, List<MonthlyPayment> evolution
});




}
/// @nodoc
class __$FinanceSummaryCopyWithImpl<$Res>
    implements _$FinanceSummaryCopyWith<$Res> {
  __$FinanceSummaryCopyWithImpl(this._self, this._then);

  final _FinanceSummary _self;
  final $Res Function(_FinanceSummary) _then;

/// Create a copy of FinanceSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parAnnee = null,Object? evolution = null,}) {
  return _then(_FinanceSummary(
parAnnee: null == parAnnee ? _self._parAnnee : parAnnee // ignore: cast_nullable_to_non_nullable
as List<YearBalance>,evolution: null == evolution ? _self._evolution : evolution // ignore: cast_nullable_to_non_nullable
as List<MonthlyPayment>,
  ));
}


}


/// @nodoc
mixin _$ProviderOption {

 String get code; List<String> get canaux; bool get parDefaut;
/// Create a copy of ProviderOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderOptionCopyWith<ProviderOption> get copyWith => _$ProviderOptionCopyWithImpl<ProviderOption>(this as ProviderOption, _$identity);

  /// Serializes this ProviderOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderOption&&(identical(other.code, _this.code) || other.code == _this.code)&&const DeepCollectionEquality().equals(other.canaux, _this.canaux)&&(identical(other.parDefaut, _this.parDefaut) || other.parDefaut == _this.parDefaut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderOption;
  return Object.hash(runtimeType,_this.code,const DeepCollectionEquality().hash(_this.canaux),_this.parDefaut);
}

@override
String toString() {
  final _this = this as ProviderOption;
  return 'ProviderOption(code: ${_this.code}, canaux: ${_this.canaux}, parDefaut: ${_this.parDefaut})';
}


}

/// @nodoc
abstract mixin class $ProviderOptionCopyWith<$Res>  {
  factory $ProviderOptionCopyWith(ProviderOption value, $Res Function(ProviderOption) _then) = _$ProviderOptionCopyWithImpl;
@useResult
$Res call({
 String code, List<String> canaux, bool parDefaut
});




}
/// @nodoc
class _$ProviderOptionCopyWithImpl<$Res>
    implements $ProviderOptionCopyWith<$Res> {
  _$ProviderOptionCopyWithImpl(this._self, this._then);

  final ProviderOption _self;
  final $Res Function(ProviderOption) _then;

/// Create a copy of ProviderOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? canaux = null,Object? parDefaut = null,}) {
  return _then(ProviderOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,canaux: null == canaux ? _self.canaux : canaux // ignore: cast_nullable_to_non_nullable
as List<String>,parDefaut: null == parDefaut ? _self.parDefaut : parDefaut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderOption].
extension ProviderOptionPatterns on ProviderOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderOption value)  $default,){
final _that = this;
switch (_that) {
case _ProviderOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderOption value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  List<String> canaux,  bool parDefaut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderOption() when $default != null:
return $default(_that.code,_that.canaux,_that.parDefaut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  List<String> canaux,  bool parDefaut)  $default,) {final _that = this;
switch (_that) {
case _ProviderOption():
return $default(_that.code,_that.canaux,_that.parDefaut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  List<String> canaux,  bool parDefaut)?  $default,) {final _that = this;
switch (_that) {
case _ProviderOption() when $default != null:
return $default(_that.code,_that.canaux,_that.parDefaut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderOption implements ProviderOption {
  const _ProviderOption({required this.code,  List<String> canaux = const [], this.parDefaut = false}): _canaux = canaux;
  factory _ProviderOption.fromJson(Map<String, dynamic> json) => _$ProviderOptionFromJson(json);

@override final  String code;
 final  List<String> _canaux;
@override@JsonKey() List<String> get canaux {
  if (_canaux is EqualUnmodifiableListView) return _canaux;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_canaux);
}

@override@JsonKey() final  bool parDefaut;

/// Create a copy of ProviderOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderOptionCopyWith<_ProviderOption> get copyWith => __$ProviderOptionCopyWithImpl<_ProviderOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderOptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderOption&&(identical(other.code, code) || other.code == code)&&const DeepCollectionEquality().equals(other.canaux, _canaux)&&(identical(other.parDefaut, parDefaut) || other.parDefaut == parDefaut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,const DeepCollectionEquality().hash(_canaux),parDefaut);
}

@override
String toString() {
    return 'ProviderOption(code: $code, canaux: $canaux, parDefaut: $parDefaut)';
}


}

/// @nodoc
abstract mixin class _$ProviderOptionCopyWith<$Res> implements $ProviderOptionCopyWith<$Res> {
  factory _$ProviderOptionCopyWith(_ProviderOption value, $Res Function(_ProviderOption) _then) = __$ProviderOptionCopyWithImpl;
@override @useResult
$Res call({
 String code, List<String> canaux, bool parDefaut
});




}
/// @nodoc
class __$ProviderOptionCopyWithImpl<$Res>
    implements _$ProviderOptionCopyWith<$Res> {
  __$ProviderOptionCopyWithImpl(this._self, this._then);

  final _ProviderOption _self;
  final $Res Function(_ProviderOption) _then;

/// Create a copy of ProviderOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? canaux = null,Object? parDefaut = null,}) {
  return _then(_ProviderOption(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,canaux: null == canaux ? _self._canaux : canaux // ignore: cast_nullable_to_non_nullable
as List<String>,parDefaut: null == parDefaut ? _self.parDefaut : parDefaut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PaymentIntent {

 String get paymentId; String get reference; String get statut; int get montant; String get devise; String? get paymentUrl; String? get instructions; ReceiptRef? get receipt;
/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentIntentCopyWith<PaymentIntent> get copyWith => _$PaymentIntentCopyWithImpl<PaymentIntent>(this as PaymentIntent, _$identity);

  /// Serializes this PaymentIntent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaymentIntent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIntent&&(identical(other.paymentId, _this.paymentId) || other.paymentId == _this.paymentId)&&(identical(other.reference, _this.reference) || other.reference == _this.reference)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.montant, _this.montant) || other.montant == _this.montant)&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.paymentUrl, _this.paymentUrl) || other.paymentUrl == _this.paymentUrl)&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions)&&(identical(other.receipt, _this.receipt) || other.receipt == _this.receipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaymentIntent;
  return Object.hash(runtimeType,_this.paymentId,_this.reference,_this.statut,_this.montant,_this.devise,_this.paymentUrl,_this.instructions,_this.receipt);
}

@override
String toString() {
  final _this = this as PaymentIntent;
  return 'PaymentIntent(paymentId: ${_this.paymentId}, reference: ${_this.reference}, statut: ${_this.statut}, montant: ${_this.montant}, devise: ${_this.devise}, paymentUrl: ${_this.paymentUrl}, instructions: ${_this.instructions}, receipt: ${_this.receipt})';
}


}

/// @nodoc
abstract mixin class $PaymentIntentCopyWith<$Res>  {
  factory $PaymentIntentCopyWith(PaymentIntent value, $Res Function(PaymentIntent) _then) = _$PaymentIntentCopyWithImpl;
@useResult
$Res call({
 String paymentId, String reference, String statut, int montant, String devise, String? paymentUrl, String? instructions, ReceiptRef? receipt
});


$ReceiptRefCopyWith<$Res>? get receipt;

}
/// @nodoc
class _$PaymentIntentCopyWithImpl<$Res>
    implements $PaymentIntentCopyWith<$Res> {
  _$PaymentIntentCopyWithImpl(this._self, this._then);

  final PaymentIntent _self;
  final $Res Function(PaymentIntent) _then;

/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? paymentId = null,Object? reference = null,Object? statut = null,Object? montant = null,Object? devise = null,Object? paymentUrl = freezed,Object? instructions = freezed,Object? receipt = freezed,}) {
  return _then(PaymentIntent(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptRef?,
  ));
}
/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptRefCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $ReceiptRefCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentIntent].
extension PaymentIntentPatterns on PaymentIntent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentIntent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentIntent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentIntent value)  $default,){
final _that = this;
switch (_that) {
case _PaymentIntent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentIntent value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentIntent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String paymentId,  String reference,  String statut,  int montant,  String devise,  String? paymentUrl,  String? instructions,  ReceiptRef? receipt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentIntent() when $default != null:
return $default(_that.paymentId,_that.reference,_that.statut,_that.montant,_that.devise,_that.paymentUrl,_that.instructions,_that.receipt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String paymentId,  String reference,  String statut,  int montant,  String devise,  String? paymentUrl,  String? instructions,  ReceiptRef? receipt)  $default,) {final _that = this;
switch (_that) {
case _PaymentIntent():
return $default(_that.paymentId,_that.reference,_that.statut,_that.montant,_that.devise,_that.paymentUrl,_that.instructions,_that.receipt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String paymentId,  String reference,  String statut,  int montant,  String devise,  String? paymentUrl,  String? instructions,  ReceiptRef? receipt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentIntent() when $default != null:
return $default(_that.paymentId,_that.reference,_that.statut,_that.montant,_that.devise,_that.paymentUrl,_that.instructions,_that.receipt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentIntent implements PaymentIntent {
  const _PaymentIntent({required this.paymentId, required this.reference, required this.statut, required this.montant, this.devise = 'XAF', this.paymentUrl, this.instructions, this.receipt});
  factory _PaymentIntent.fromJson(Map<String, dynamic> json) => _$PaymentIntentFromJson(json);

@override final  String paymentId;
@override final  String reference;
@override final  String statut;
@override final  int montant;
@override@JsonKey() final  String devise;
@override final  String? paymentUrl;
@override final  String? instructions;
@override final  ReceiptRef? receipt;

/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentIntentCopyWith<_PaymentIntent> get copyWith => __$PaymentIntentCopyWithImpl<_PaymentIntent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentIntentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentIntent&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.montant, montant) || other.montant == montant)&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.receipt, receipt) || other.receipt == receipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,paymentId,reference,statut,montant,devise,paymentUrl,instructions,receipt);
}

@override
String toString() {
    return 'PaymentIntent(paymentId: $paymentId, reference: $reference, statut: $statut, montant: $montant, devise: $devise, paymentUrl: $paymentUrl, instructions: $instructions, receipt: $receipt)';
}


}

/// @nodoc
abstract mixin class _$PaymentIntentCopyWith<$Res> implements $PaymentIntentCopyWith<$Res> {
  factory _$PaymentIntentCopyWith(_PaymentIntent value, $Res Function(_PaymentIntent) _then) = __$PaymentIntentCopyWithImpl;
@override @useResult
$Res call({
 String paymentId, String reference, String statut, int montant, String devise, String? paymentUrl, String? instructions, ReceiptRef? receipt
});


@override $ReceiptRefCopyWith<$Res>? get receipt;

}
/// @nodoc
class __$PaymentIntentCopyWithImpl<$Res>
    implements _$PaymentIntentCopyWith<$Res> {
  __$PaymentIntentCopyWithImpl(this._self, this._then);

  final _PaymentIntent _self;
  final $Res Function(_PaymentIntent) _then;

/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? paymentId = null,Object? reference = null,Object? statut = null,Object? montant = null,Object? devise = null,Object? paymentUrl = freezed,Object? instructions = freezed,Object? receipt = freezed,}) {
  return _then(_PaymentIntent(
paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptRef?,
  ));
}

/// Create a copy of PaymentIntent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReceiptRefCopyWith<$Res>? get receipt {
    if (_self.receipt == null) {
    return null;
  }

  return $ReceiptRefCopyWith<$Res>(_self.receipt!, (value) {
    return _then(_self.copyWith(receipt: value));
  });
}
}

// dart format on
