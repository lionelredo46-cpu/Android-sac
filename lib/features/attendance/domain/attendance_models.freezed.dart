// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseRef {

 String get id; String get code; String get nom;
/// Create a copy of CourseRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseRefCopyWith<CourseRef> get copyWith => _$CourseRefCopyWithImpl<CourseRef>(this as CourseRef, _$identity);

  /// Serializes this CourseRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CourseRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nom, _this.nom) || other.nom == _this.nom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CourseRef;
  return Object.hash(runtimeType,_this.id,_this.code,_this.nom);
}

@override
String toString() {
  final _this = this as CourseRef;
  return 'CourseRef(id: ${_this.id}, code: ${_this.code}, nom: ${_this.nom})';
}


}

/// @nodoc
abstract mixin class $CourseRefCopyWith<$Res>  {
  factory $CourseRefCopyWith(CourseRef value, $Res Function(CourseRef) _then) = _$CourseRefCopyWithImpl;
@useResult
$Res call({
 String id, String code, String nom
});




}
/// @nodoc
class _$CourseRefCopyWithImpl<$Res>
    implements $CourseRefCopyWith<$Res> {
  _$CourseRefCopyWithImpl(this._self, this._then);

  final CourseRef _self;
  final $Res Function(CourseRef) _then;

/// Create a copy of CourseRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nom = null,}) {
  return _then(CourseRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseRef].
extension CourseRefPatterns on CourseRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseRef value)  $default,){
final _that = this;
switch (_that) {
case _CourseRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseRef value)?  $default,){
final _that = this;
switch (_that) {
case _CourseRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String nom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseRef() when $default != null:
return $default(_that.id,_that.code,_that.nom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String nom)  $default,) {final _that = this;
switch (_that) {
case _CourseRef():
return $default(_that.id,_that.code,_that.nom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String nom)?  $default,) {final _that = this;
switch (_that) {
case _CourseRef() when $default != null:
return $default(_that.id,_that.code,_that.nom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseRef implements CourseRef {
  const _CourseRef({required this.id, required this.code, required this.nom});
  factory _CourseRef.fromJson(Map<String, dynamic> json) => _$CourseRefFromJson(json);

@override final  String id;
@override final  String code;
@override final  String nom;

/// Create a copy of CourseRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseRefCopyWith<_CourseRef> get copyWith => __$CourseRefCopyWithImpl<_CourseRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.nom, nom) || other.nom == nom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,nom);
}

@override
String toString() {
    return 'CourseRef(id: $id, code: $code, nom: $nom)';
}


}

/// @nodoc
abstract mixin class _$CourseRefCopyWith<$Res> implements $CourseRefCopyWith<$Res> {
  factory _$CourseRefCopyWith(_CourseRef value, $Res Function(_CourseRef) _then) = __$CourseRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String nom
});




}
/// @nodoc
class __$CourseRefCopyWithImpl<$Res>
    implements _$CourseRefCopyWith<$Res> {
  __$CourseRefCopyWithImpl(this._self, this._then);

  final _CourseRef _self;
  final $Res Function(_CourseRef) _then;

/// Create a copy of CourseRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nom = null,}) {
  return _then(_CourseRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Justification {

 String get id; String get motif; String get statut; String? get commentaire; DateTime get createdAt;
/// Create a copy of Justification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JustificationCopyWith<Justification> get copyWith => _$JustificationCopyWithImpl<Justification>(this as Justification, _$identity);

  /// Serializes this Justification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Justification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Justification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.motif, _this.motif) || other.motif == _this.motif)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.commentaire, _this.commentaire) || other.commentaire == _this.commentaire)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Justification;
  return Object.hash(runtimeType,_this.id,_this.motif,_this.statut,_this.commentaire,_this.createdAt);
}

@override
String toString() {
  final _this = this as Justification;
  return 'Justification(id: ${_this.id}, motif: ${_this.motif}, statut: ${_this.statut}, commentaire: ${_this.commentaire}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $JustificationCopyWith<$Res>  {
  factory $JustificationCopyWith(Justification value, $Res Function(Justification) _then) = _$JustificationCopyWithImpl;
@useResult
$Res call({
 String id, String motif, String statut, String? commentaire, DateTime createdAt
});




}
/// @nodoc
class _$JustificationCopyWithImpl<$Res>
    implements $JustificationCopyWith<$Res> {
  _$JustificationCopyWithImpl(this._self, this._then);

  final Justification _self;
  final $Res Function(Justification) _then;

/// Create a copy of Justification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? motif = null,Object? statut = null,Object? commentaire = freezed,Object? createdAt = null,}) {
  return _then(Justification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,commentaire: freezed == commentaire ? _self.commentaire : commentaire // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Justification].
extension JustificationPatterns on Justification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Justification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Justification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Justification value)  $default,){
final _that = this;
switch (_that) {
case _Justification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Justification value)?  $default,){
final _that = this;
switch (_that) {
case _Justification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String motif,  String statut,  String? commentaire,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Justification() when $default != null:
return $default(_that.id,_that.motif,_that.statut,_that.commentaire,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String motif,  String statut,  String? commentaire,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Justification():
return $default(_that.id,_that.motif,_that.statut,_that.commentaire,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String motif,  String statut,  String? commentaire,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Justification() when $default != null:
return $default(_that.id,_that.motif,_that.statut,_that.commentaire,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Justification implements Justification {
  const _Justification({required this.id, required this.motif, required this.statut, this.commentaire, required this.createdAt});
  factory _Justification.fromJson(Map<String, dynamic> json) => _$JustificationFromJson(json);

@override final  String id;
@override final  String motif;
@override final  String statut;
@override final  String? commentaire;
@override final  DateTime createdAt;

/// Create a copy of Justification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JustificationCopyWith<_Justification> get copyWith => __$JustificationCopyWithImpl<_Justification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JustificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Justification&&(identical(other.id, id) || other.id == id)&&(identical(other.motif, motif) || other.motif == motif)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.commentaire, commentaire) || other.commentaire == commentaire)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,motif,statut,commentaire,createdAt);
}

@override
String toString() {
    return 'Justification(id: $id, motif: $motif, statut: $statut, commentaire: $commentaire, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JustificationCopyWith<$Res> implements $JustificationCopyWith<$Res> {
  factory _$JustificationCopyWith(_Justification value, $Res Function(_Justification) _then) = __$JustificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String motif, String statut, String? commentaire, DateTime createdAt
});




}
/// @nodoc
class __$JustificationCopyWithImpl<$Res>
    implements _$JustificationCopyWith<$Res> {
  __$JustificationCopyWithImpl(this._self, this._then);

  final _Justification _self;
  final $Res Function(_Justification) _then;

/// Create a copy of Justification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? motif = null,Object? statut = null,Object? commentaire = freezed,Object? createdAt = null,}) {
  return _then(_Justification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,motif: null == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,commentaire: freezed == commentaire ? _self.commentaire : commentaire // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AttendanceItem {

 String get id; String get statut; int get minutesRetard; DateTime get date; DateTime get fin; int get dureeMinutes; CourseRef get cours; String get enseignant; String get salle; Justification? get justification; bool get justifiable;
/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceItemCopyWith<AttendanceItem> get copyWith => _$AttendanceItemCopyWithImpl<AttendanceItem>(this as AttendanceItem, _$identity);

  /// Serializes this AttendanceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.minutesRetard, _this.minutesRetard) || other.minutesRetard == _this.minutesRetard)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.fin, _this.fin) || other.fin == _this.fin)&&(identical(other.dureeMinutes, _this.dureeMinutes) || other.dureeMinutes == _this.dureeMinutes)&&(identical(other.cours, _this.cours) || other.cours == _this.cours)&&(identical(other.enseignant, _this.enseignant) || other.enseignant == _this.enseignant)&&(identical(other.salle, _this.salle) || other.salle == _this.salle)&&(identical(other.justification, _this.justification) || other.justification == _this.justification)&&(identical(other.justifiable, _this.justifiable) || other.justifiable == _this.justifiable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceItem;
  return Object.hash(runtimeType,_this.id,_this.statut,_this.minutesRetard,_this.date,_this.fin,_this.dureeMinutes,_this.cours,_this.enseignant,_this.salle,_this.justification,_this.justifiable);
}

@override
String toString() {
  final _this = this as AttendanceItem;
  return 'AttendanceItem(id: ${_this.id}, statut: ${_this.statut}, minutesRetard: ${_this.minutesRetard}, date: ${_this.date}, fin: ${_this.fin}, dureeMinutes: ${_this.dureeMinutes}, cours: ${_this.cours}, enseignant: ${_this.enseignant}, salle: ${_this.salle}, justification: ${_this.justification}, justifiable: ${_this.justifiable})';
}


}

/// @nodoc
abstract mixin class $AttendanceItemCopyWith<$Res>  {
  factory $AttendanceItemCopyWith(AttendanceItem value, $Res Function(AttendanceItem) _then) = _$AttendanceItemCopyWithImpl;
@useResult
$Res call({
 String id, String statut, int minutesRetard, DateTime date, DateTime fin, int dureeMinutes, CourseRef cours, String enseignant, String salle, Justification? justification, bool justifiable
});


$CourseRefCopyWith<$Res> get cours;$JustificationCopyWith<$Res>? get justification;

}
/// @nodoc
class _$AttendanceItemCopyWithImpl<$Res>
    implements $AttendanceItemCopyWith<$Res> {
  _$AttendanceItemCopyWithImpl(this._self, this._then);

  final AttendanceItem _self;
  final $Res Function(AttendanceItem) _then;

/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statut = null,Object? minutesRetard = null,Object? date = null,Object? fin = null,Object? dureeMinutes = null,Object? cours = null,Object? enseignant = null,Object? salle = null,Object? justification = freezed,Object? justifiable = null,}) {
  return _then(AttendanceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,minutesRetard: null == minutesRetard ? _self.minutesRetard : minutesRetard // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,dureeMinutes: null == dureeMinutes ? _self.dureeMinutes : dureeMinutes // ignore: cast_nullable_to_non_nullable
as int,cours: null == cours ? _self.cours : cours // ignore: cast_nullable_to_non_nullable
as CourseRef,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as Justification?,justifiable: null == justifiable ? _self.justifiable : justifiable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseRefCopyWith<$Res> get cours {
  
  return $CourseRefCopyWith<$Res>(_self.cours, (value) {
    return _then(_self.copyWith(cours: value));
  });
}/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JustificationCopyWith<$Res>? get justification {
    if (_self.justification == null) {
    return null;
  }

  return $JustificationCopyWith<$Res>(_self.justification!, (value) {
    return _then(_self.copyWith(justification: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceItem].
extension AttendanceItemPatterns on AttendanceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceItem value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceItem value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String statut,  int minutesRetard,  DateTime date,  DateTime fin,  int dureeMinutes,  CourseRef cours,  String enseignant,  String salle,  Justification? justification,  bool justifiable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceItem() when $default != null:
return $default(_that.id,_that.statut,_that.minutesRetard,_that.date,_that.fin,_that.dureeMinutes,_that.cours,_that.enseignant,_that.salle,_that.justification,_that.justifiable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String statut,  int minutesRetard,  DateTime date,  DateTime fin,  int dureeMinutes,  CourseRef cours,  String enseignant,  String salle,  Justification? justification,  bool justifiable)  $default,) {final _that = this;
switch (_that) {
case _AttendanceItem():
return $default(_that.id,_that.statut,_that.minutesRetard,_that.date,_that.fin,_that.dureeMinutes,_that.cours,_that.enseignant,_that.salle,_that.justification,_that.justifiable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String statut,  int minutesRetard,  DateTime date,  DateTime fin,  int dureeMinutes,  CourseRef cours,  String enseignant,  String salle,  Justification? justification,  bool justifiable)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceItem() when $default != null:
return $default(_that.id,_that.statut,_that.minutesRetard,_that.date,_that.fin,_that.dureeMinutes,_that.cours,_that.enseignant,_that.salle,_that.justification,_that.justifiable);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceItem implements AttendanceItem {
  const _AttendanceItem({required this.id, required this.statut, this.minutesRetard = 0, required this.date, required this.fin, this.dureeMinutes = 0, required this.cours, required this.enseignant, required this.salle, this.justification, this.justifiable = false});
  factory _AttendanceItem.fromJson(Map<String, dynamic> json) => _$AttendanceItemFromJson(json);

@override final  String id;
@override final  String statut;
@override@JsonKey() final  int minutesRetard;
@override final  DateTime date;
@override final  DateTime fin;
@override@JsonKey() final  int dureeMinutes;
@override final  CourseRef cours;
@override final  String enseignant;
@override final  String salle;
@override final  Justification? justification;
@override@JsonKey() final  bool justifiable;

/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceItemCopyWith<_AttendanceItem> get copyWith => __$AttendanceItemCopyWithImpl<_AttendanceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.minutesRetard, minutesRetard) || other.minutesRetard == minutesRetard)&&(identical(other.date, date) || other.date == date)&&(identical(other.fin, fin) || other.fin == fin)&&(identical(other.dureeMinutes, dureeMinutes) || other.dureeMinutes == dureeMinutes)&&(identical(other.cours, cours) || other.cours == cours)&&(identical(other.enseignant, enseignant) || other.enseignant == enseignant)&&(identical(other.salle, salle) || other.salle == salle)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.justifiable, justifiable) || other.justifiable == justifiable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,statut,minutesRetard,date,fin,dureeMinutes,cours,enseignant,salle,justification,justifiable);
}

@override
String toString() {
    return 'AttendanceItem(id: $id, statut: $statut, minutesRetard: $minutesRetard, date: $date, fin: $fin, dureeMinutes: $dureeMinutes, cours: $cours, enseignant: $enseignant, salle: $salle, justification: $justification, justifiable: $justifiable)';
}


}

/// @nodoc
abstract mixin class _$AttendanceItemCopyWith<$Res> implements $AttendanceItemCopyWith<$Res> {
  factory _$AttendanceItemCopyWith(_AttendanceItem value, $Res Function(_AttendanceItem) _then) = __$AttendanceItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String statut, int minutesRetard, DateTime date, DateTime fin, int dureeMinutes, CourseRef cours, String enseignant, String salle, Justification? justification, bool justifiable
});


@override $CourseRefCopyWith<$Res> get cours;@override $JustificationCopyWith<$Res>? get justification;

}
/// @nodoc
class __$AttendanceItemCopyWithImpl<$Res>
    implements _$AttendanceItemCopyWith<$Res> {
  __$AttendanceItemCopyWithImpl(this._self, this._then);

  final _AttendanceItem _self;
  final $Res Function(_AttendanceItem) _then;

/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statut = null,Object? minutesRetard = null,Object? date = null,Object? fin = null,Object? dureeMinutes = null,Object? cours = null,Object? enseignant = null,Object? salle = null,Object? justification = freezed,Object? justifiable = null,}) {
  return _then(_AttendanceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,minutesRetard: null == minutesRetard ? _self.minutesRetard : minutesRetard // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,dureeMinutes: null == dureeMinutes ? _self.dureeMinutes : dureeMinutes // ignore: cast_nullable_to_non_nullable
as int,cours: null == cours ? _self.cours : cours // ignore: cast_nullable_to_non_nullable
as CourseRef,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as Justification?,justifiable: null == justifiable ? _self.justifiable : justifiable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CourseRefCopyWith<$Res> get cours {
  
  return $CourseRefCopyWith<$Res>(_self.cours, (value) {
    return _then(_self.copyWith(cours: value));
  });
}/// Create a copy of AttendanceItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JustificationCopyWith<$Res>? get justification {
    if (_self.justification == null) {
    return null;
  }

  return $JustificationCopyWith<$Res>(_self.justification!, (value) {
    return _then(_self.copyWith(justification: value));
  });
}
}


/// @nodoc
mixin _$AttendanceTotals {

 int get seances;@JsonKey(name: 'PRESENT') int get presents;@JsonKey(name: 'ABSENT') int get absents;@JsonKey(name: 'RETARD') int get retards;@JsonKey(name: 'EXCUSE') int get excuses; int get absencesNonJustifiees;
/// Create a copy of AttendanceTotals
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceTotalsCopyWith<AttendanceTotals> get copyWith => _$AttendanceTotalsCopyWithImpl<AttendanceTotals>(this as AttendanceTotals, _$identity);

  /// Serializes this AttendanceTotals to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceTotals;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceTotals&&(identical(other.seances, _this.seances) || other.seances == _this.seances)&&(identical(other.presents, _this.presents) || other.presents == _this.presents)&&(identical(other.absents, _this.absents) || other.absents == _this.absents)&&(identical(other.retards, _this.retards) || other.retards == _this.retards)&&(identical(other.excuses, _this.excuses) || other.excuses == _this.excuses)&&(identical(other.absencesNonJustifiees, _this.absencesNonJustifiees) || other.absencesNonJustifiees == _this.absencesNonJustifiees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceTotals;
  return Object.hash(runtimeType,_this.seances,_this.presents,_this.absents,_this.retards,_this.excuses,_this.absencesNonJustifiees);
}

@override
String toString() {
  final _this = this as AttendanceTotals;
  return 'AttendanceTotals(seances: ${_this.seances}, presents: ${_this.presents}, absents: ${_this.absents}, retards: ${_this.retards}, excuses: ${_this.excuses}, absencesNonJustifiees: ${_this.absencesNonJustifiees})';
}


}

/// @nodoc
abstract mixin class $AttendanceTotalsCopyWith<$Res>  {
  factory $AttendanceTotalsCopyWith(AttendanceTotals value, $Res Function(AttendanceTotals) _then) = _$AttendanceTotalsCopyWithImpl;
@useResult
$Res call({
 int seances,@JsonKey(name: 'PRESENT') int presents,@JsonKey(name: 'ABSENT') int absents,@JsonKey(name: 'RETARD') int retards,@JsonKey(name: 'EXCUSE') int excuses, int absencesNonJustifiees
});




}
/// @nodoc
class _$AttendanceTotalsCopyWithImpl<$Res>
    implements $AttendanceTotalsCopyWith<$Res> {
  _$AttendanceTotalsCopyWithImpl(this._self, this._then);

  final AttendanceTotals _self;
  final $Res Function(AttendanceTotals) _then;

/// Create a copy of AttendanceTotals
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seances = null,Object? presents = null,Object? absents = null,Object? retards = null,Object? excuses = null,Object? absencesNonJustifiees = null,}) {
  return _then(AttendanceTotals(
seances: null == seances ? _self.seances : seances // ignore: cast_nullable_to_non_nullable
as int,presents: null == presents ? _self.presents : presents // ignore: cast_nullable_to_non_nullable
as int,absents: null == absents ? _self.absents : absents // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,excuses: null == excuses ? _self.excuses : excuses // ignore: cast_nullable_to_non_nullable
as int,absencesNonJustifiees: null == absencesNonJustifiees ? _self.absencesNonJustifiees : absencesNonJustifiees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceTotals].
extension AttendanceTotalsPatterns on AttendanceTotals {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceTotals value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceTotals() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceTotals value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceTotals():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceTotals value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceTotals() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seances, @JsonKey(name: 'PRESENT')  int presents, @JsonKey(name: 'ABSENT')  int absents, @JsonKey(name: 'RETARD')  int retards, @JsonKey(name: 'EXCUSE')  int excuses,  int absencesNonJustifiees)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceTotals() when $default != null:
return $default(_that.seances,_that.presents,_that.absents,_that.retards,_that.excuses,_that.absencesNonJustifiees);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seances, @JsonKey(name: 'PRESENT')  int presents, @JsonKey(name: 'ABSENT')  int absents, @JsonKey(name: 'RETARD')  int retards, @JsonKey(name: 'EXCUSE')  int excuses,  int absencesNonJustifiees)  $default,) {final _that = this;
switch (_that) {
case _AttendanceTotals():
return $default(_that.seances,_that.presents,_that.absents,_that.retards,_that.excuses,_that.absencesNonJustifiees);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seances, @JsonKey(name: 'PRESENT')  int presents, @JsonKey(name: 'ABSENT')  int absents, @JsonKey(name: 'RETARD')  int retards, @JsonKey(name: 'EXCUSE')  int excuses,  int absencesNonJustifiees)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceTotals() when $default != null:
return $default(_that.seances,_that.presents,_that.absents,_that.retards,_that.excuses,_that.absencesNonJustifiees);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceTotals implements AttendanceTotals {
  const _AttendanceTotals({this.seances = 0, @JsonKey(name: 'PRESENT') this.presents = 0, @JsonKey(name: 'ABSENT') this.absents = 0, @JsonKey(name: 'RETARD') this.retards = 0, @JsonKey(name: 'EXCUSE') this.excuses = 0, this.absencesNonJustifiees = 0});
  factory _AttendanceTotals.fromJson(Map<String, dynamic> json) => _$AttendanceTotalsFromJson(json);

@override@JsonKey() final  int seances;
@override@JsonKey(name: 'PRESENT') final  int presents;
@override@JsonKey(name: 'ABSENT') final  int absents;
@override@JsonKey(name: 'RETARD') final  int retards;
@override@JsonKey(name: 'EXCUSE') final  int excuses;
@override@JsonKey() final  int absencesNonJustifiees;

/// Create a copy of AttendanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceTotalsCopyWith<_AttendanceTotals> get copyWith => __$AttendanceTotalsCopyWithImpl<_AttendanceTotals>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceTotalsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceTotals&&(identical(other.seances, seances) || other.seances == seances)&&(identical(other.presents, presents) || other.presents == presents)&&(identical(other.absents, absents) || other.absents == absents)&&(identical(other.retards, retards) || other.retards == retards)&&(identical(other.excuses, excuses) || other.excuses == excuses)&&(identical(other.absencesNonJustifiees, absencesNonJustifiees) || other.absencesNonJustifiees == absencesNonJustifiees));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seances,presents,absents,retards,excuses,absencesNonJustifiees);
}

@override
String toString() {
    return 'AttendanceTotals(seances: $seances, presents: $presents, absents: $absents, retards: $retards, excuses: $excuses, absencesNonJustifiees: $absencesNonJustifiees)';
}


}

/// @nodoc
abstract mixin class _$AttendanceTotalsCopyWith<$Res> implements $AttendanceTotalsCopyWith<$Res> {
  factory _$AttendanceTotalsCopyWith(_AttendanceTotals value, $Res Function(_AttendanceTotals) _then) = __$AttendanceTotalsCopyWithImpl;
@override @useResult
$Res call({
 int seances,@JsonKey(name: 'PRESENT') int presents,@JsonKey(name: 'ABSENT') int absents,@JsonKey(name: 'RETARD') int retards,@JsonKey(name: 'EXCUSE') int excuses, int absencesNonJustifiees
});




}
/// @nodoc
class __$AttendanceTotalsCopyWithImpl<$Res>
    implements _$AttendanceTotalsCopyWith<$Res> {
  __$AttendanceTotalsCopyWithImpl(this._self, this._then);

  final _AttendanceTotals _self;
  final $Res Function(_AttendanceTotals) _then;

/// Create a copy of AttendanceTotals
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seances = null,Object? presents = null,Object? absents = null,Object? retards = null,Object? excuses = null,Object? absencesNonJustifiees = null,}) {
  return _then(_AttendanceTotals(
seances: null == seances ? _self.seances : seances // ignore: cast_nullable_to_non_nullable
as int,presents: null == presents ? _self.presents : presents // ignore: cast_nullable_to_non_nullable
as int,absents: null == absents ? _self.absents : absents // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,excuses: null == excuses ? _self.excuses : excuses // ignore: cast_nullable_to_non_nullable
as int,absencesNonJustifiees: null == absencesNonJustifiees ? _self.absencesNonJustifiees : absencesNonJustifiees // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CourseAttendance {

 String get courseId; String get matiere; double? get taux; int get absences; int get retards;
/// Create a copy of CourseAttendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseAttendanceCopyWith<CourseAttendance> get copyWith => _$CourseAttendanceCopyWithImpl<CourseAttendance>(this as CourseAttendance, _$identity);

  /// Serializes this CourseAttendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CourseAttendance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseAttendance&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.matiere, _this.matiere) || other.matiere == _this.matiere)&&(identical(other.taux, _this.taux) || other.taux == _this.taux)&&(identical(other.absences, _this.absences) || other.absences == _this.absences)&&(identical(other.retards, _this.retards) || other.retards == _this.retards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CourseAttendance;
  return Object.hash(runtimeType,_this.courseId,_this.matiere,_this.taux,_this.absences,_this.retards);
}

@override
String toString() {
  final _this = this as CourseAttendance;
  return 'CourseAttendance(courseId: ${_this.courseId}, matiere: ${_this.matiere}, taux: ${_this.taux}, absences: ${_this.absences}, retards: ${_this.retards})';
}


}

/// @nodoc
abstract mixin class $CourseAttendanceCopyWith<$Res>  {
  factory $CourseAttendanceCopyWith(CourseAttendance value, $Res Function(CourseAttendance) _then) = _$CourseAttendanceCopyWithImpl;
@useResult
$Res call({
 String courseId, String matiere, double? taux, int absences, int retards
});




}
/// @nodoc
class _$CourseAttendanceCopyWithImpl<$Res>
    implements $CourseAttendanceCopyWith<$Res> {
  _$CourseAttendanceCopyWithImpl(this._self, this._then);

  final CourseAttendance _self;
  final $Res Function(CourseAttendance) _then;

/// Create a copy of CourseAttendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? matiere = null,Object? taux = freezed,Object? absences = null,Object? retards = null,}) {
  return _then(CourseAttendance(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,taux: freezed == taux ? _self.taux : taux // ignore: cast_nullable_to_non_nullable
as double?,absences: null == absences ? _self.absences : absences // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseAttendance].
extension CourseAttendancePatterns on CourseAttendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseAttendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseAttendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseAttendance value)  $default,){
final _that = this;
switch (_that) {
case _CourseAttendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseAttendance value)?  $default,){
final _that = this;
switch (_that) {
case _CourseAttendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseId,  String matiere,  double? taux,  int absences,  int retards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseAttendance() when $default != null:
return $default(_that.courseId,_that.matiere,_that.taux,_that.absences,_that.retards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseId,  String matiere,  double? taux,  int absences,  int retards)  $default,) {final _that = this;
switch (_that) {
case _CourseAttendance():
return $default(_that.courseId,_that.matiere,_that.taux,_that.absences,_that.retards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseId,  String matiere,  double? taux,  int absences,  int retards)?  $default,) {final _that = this;
switch (_that) {
case _CourseAttendance() when $default != null:
return $default(_that.courseId,_that.matiere,_that.taux,_that.absences,_that.retards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseAttendance implements CourseAttendance {
  const _CourseAttendance({required this.courseId, required this.matiere, this.taux, this.absences = 0, this.retards = 0});
  factory _CourseAttendance.fromJson(Map<String, dynamic> json) => _$CourseAttendanceFromJson(json);

@override final  String courseId;
@override final  String matiere;
@override final  double? taux;
@override@JsonKey() final  int absences;
@override@JsonKey() final  int retards;

/// Create a copy of CourseAttendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseAttendanceCopyWith<_CourseAttendance> get copyWith => __$CourseAttendanceCopyWithImpl<_CourseAttendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseAttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseAttendance&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.matiere, matiere) || other.matiere == matiere)&&(identical(other.taux, taux) || other.taux == taux)&&(identical(other.absences, absences) || other.absences == absences)&&(identical(other.retards, retards) || other.retards == retards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,courseId,matiere,taux,absences,retards);
}

@override
String toString() {
    return 'CourseAttendance(courseId: $courseId, matiere: $matiere, taux: $taux, absences: $absences, retards: $retards)';
}


}

/// @nodoc
abstract mixin class _$CourseAttendanceCopyWith<$Res> implements $CourseAttendanceCopyWith<$Res> {
  factory _$CourseAttendanceCopyWith(_CourseAttendance value, $Res Function(_CourseAttendance) _then) = __$CourseAttendanceCopyWithImpl;
@override @useResult
$Res call({
 String courseId, String matiere, double? taux, int absences, int retards
});




}
/// @nodoc
class __$CourseAttendanceCopyWithImpl<$Res>
    implements _$CourseAttendanceCopyWith<$Res> {
  __$CourseAttendanceCopyWithImpl(this._self, this._then);

  final _CourseAttendance _self;
  final $Res Function(_CourseAttendance) _then;

/// Create a copy of CourseAttendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? matiere = null,Object? taux = freezed,Object? absences = null,Object? retards = null,}) {
  return _then(_CourseAttendance(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,taux: freezed == taux ? _self.taux : taux // ignore: cast_nullable_to_non_nullable
as double?,absences: null == absences ? _self.absences : absences // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WeekAttendance {

 String get semaine; int get absences; int get retards;
/// Create a copy of WeekAttendance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekAttendanceCopyWith<WeekAttendance> get copyWith => _$WeekAttendanceCopyWithImpl<WeekAttendance>(this as WeekAttendance, _$identity);

  /// Serializes this WeekAttendance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeekAttendance;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekAttendance&&(identical(other.semaine, _this.semaine) || other.semaine == _this.semaine)&&(identical(other.absences, _this.absences) || other.absences == _this.absences)&&(identical(other.retards, _this.retards) || other.retards == _this.retards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeekAttendance;
  return Object.hash(runtimeType,_this.semaine,_this.absences,_this.retards);
}

@override
String toString() {
  final _this = this as WeekAttendance;
  return 'WeekAttendance(semaine: ${_this.semaine}, absences: ${_this.absences}, retards: ${_this.retards})';
}


}

/// @nodoc
abstract mixin class $WeekAttendanceCopyWith<$Res>  {
  factory $WeekAttendanceCopyWith(WeekAttendance value, $Res Function(WeekAttendance) _then) = _$WeekAttendanceCopyWithImpl;
@useResult
$Res call({
 String semaine, int absences, int retards
});




}
/// @nodoc
class _$WeekAttendanceCopyWithImpl<$Res>
    implements $WeekAttendanceCopyWith<$Res> {
  _$WeekAttendanceCopyWithImpl(this._self, this._then);

  final WeekAttendance _self;
  final $Res Function(WeekAttendance) _then;

/// Create a copy of WeekAttendance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semaine = null,Object? absences = null,Object? retards = null,}) {
  return _then(WeekAttendance(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,absences: null == absences ? _self.absences : absences // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekAttendance].
extension WeekAttendancePatterns on WeekAttendance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekAttendance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekAttendance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekAttendance value)  $default,){
final _that = this;
switch (_that) {
case _WeekAttendance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekAttendance value)?  $default,){
final _that = this;
switch (_that) {
case _WeekAttendance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String semaine,  int absences,  int retards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekAttendance() when $default != null:
return $default(_that.semaine,_that.absences,_that.retards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String semaine,  int absences,  int retards)  $default,) {final _that = this;
switch (_that) {
case _WeekAttendance():
return $default(_that.semaine,_that.absences,_that.retards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String semaine,  int absences,  int retards)?  $default,) {final _that = this;
switch (_that) {
case _WeekAttendance() when $default != null:
return $default(_that.semaine,_that.absences,_that.retards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekAttendance implements WeekAttendance {
  const _WeekAttendance({required this.semaine, this.absences = 0, this.retards = 0});
  factory _WeekAttendance.fromJson(Map<String, dynamic> json) => _$WeekAttendanceFromJson(json);

@override final  String semaine;
@override@JsonKey() final  int absences;
@override@JsonKey() final  int retards;

/// Create a copy of WeekAttendance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekAttendanceCopyWith<_WeekAttendance> get copyWith => __$WeekAttendanceCopyWithImpl<_WeekAttendance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekAttendanceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekAttendance&&(identical(other.semaine, semaine) || other.semaine == semaine)&&(identical(other.absences, absences) || other.absences == absences)&&(identical(other.retards, retards) || other.retards == retards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,semaine,absences,retards);
}

@override
String toString() {
    return 'WeekAttendance(semaine: $semaine, absences: $absences, retards: $retards)';
}


}

/// @nodoc
abstract mixin class _$WeekAttendanceCopyWith<$Res> implements $WeekAttendanceCopyWith<$Res> {
  factory _$WeekAttendanceCopyWith(_WeekAttendance value, $Res Function(_WeekAttendance) _then) = __$WeekAttendanceCopyWithImpl;
@override @useResult
$Res call({
 String semaine, int absences, int retards
});




}
/// @nodoc
class __$WeekAttendanceCopyWithImpl<$Res>
    implements _$WeekAttendanceCopyWith<$Res> {
  __$WeekAttendanceCopyWithImpl(this._self, this._then);

  final _WeekAttendance _self;
  final $Res Function(_WeekAttendance) _then;

/// Create a copy of WeekAttendance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semaine = null,Object? absences = null,Object? retards = null,}) {
  return _then(_WeekAttendance(
semaine: null == semaine ? _self.semaine : semaine // ignore: cast_nullable_to_non_nullable
as String,absences: null == absences ? _self.absences : absences // ignore: cast_nullable_to_non_nullable
as int,retards: null == retards ? _self.retards : retards // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AttendanceStats {

 double? get tauxGlobal; AttendanceTotals get totaux; List<CourseAttendance> get parMatiere; List<WeekAttendance> get parSemaine;
/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceStatsCopyWith<AttendanceStats> get copyWith => _$AttendanceStatsCopyWithImpl<AttendanceStats>(this as AttendanceStats, _$identity);

  /// Serializes this AttendanceStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceStats&&(identical(other.tauxGlobal, _this.tauxGlobal) || other.tauxGlobal == _this.tauxGlobal)&&(identical(other.totaux, _this.totaux) || other.totaux == _this.totaux)&&const DeepCollectionEquality().equals(other.parMatiere, _this.parMatiere)&&const DeepCollectionEquality().equals(other.parSemaine, _this.parSemaine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceStats;
  return Object.hash(runtimeType,_this.tauxGlobal,_this.totaux,const DeepCollectionEquality().hash(_this.parMatiere),const DeepCollectionEquality().hash(_this.parSemaine));
}

@override
String toString() {
  final _this = this as AttendanceStats;
  return 'AttendanceStats(tauxGlobal: ${_this.tauxGlobal}, totaux: ${_this.totaux}, parMatiere: ${_this.parMatiere}, parSemaine: ${_this.parSemaine})';
}


}

/// @nodoc
abstract mixin class $AttendanceStatsCopyWith<$Res>  {
  factory $AttendanceStatsCopyWith(AttendanceStats value, $Res Function(AttendanceStats) _then) = _$AttendanceStatsCopyWithImpl;
@useResult
$Res call({
 double? tauxGlobal, AttendanceTotals totaux, List<CourseAttendance> parMatiere, List<WeekAttendance> parSemaine
});


$AttendanceTotalsCopyWith<$Res> get totaux;

}
/// @nodoc
class _$AttendanceStatsCopyWithImpl<$Res>
    implements $AttendanceStatsCopyWith<$Res> {
  _$AttendanceStatsCopyWithImpl(this._self, this._then);

  final AttendanceStats _self;
  final $Res Function(AttendanceStats) _then;

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tauxGlobal = freezed,Object? totaux = null,Object? parMatiere = null,Object? parSemaine = null,}) {
  return _then(AttendanceStats(
tauxGlobal: freezed == tauxGlobal ? _self.tauxGlobal : tauxGlobal // ignore: cast_nullable_to_non_nullable
as double?,totaux: null == totaux ? _self.totaux : totaux // ignore: cast_nullable_to_non_nullable
as AttendanceTotals,parMatiere: null == parMatiere ? _self.parMatiere : parMatiere // ignore: cast_nullable_to_non_nullable
as List<CourseAttendance>,parSemaine: null == parSemaine ? _self.parSemaine : parSemaine // ignore: cast_nullable_to_non_nullable
as List<WeekAttendance>,
  ));
}
/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceTotalsCopyWith<$Res> get totaux {
  
  return $AttendanceTotalsCopyWith<$Res>(_self.totaux, (value) {
    return _then(_self.copyWith(totaux: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendanceStats].
extension AttendanceStatsPatterns on AttendanceStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceStats value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceStats value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? tauxGlobal,  AttendanceTotals totaux,  List<CourseAttendance> parMatiere,  List<WeekAttendance> parSemaine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
return $default(_that.tauxGlobal,_that.totaux,_that.parMatiere,_that.parSemaine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? tauxGlobal,  AttendanceTotals totaux,  List<CourseAttendance> parMatiere,  List<WeekAttendance> parSemaine)  $default,) {final _that = this;
switch (_that) {
case _AttendanceStats():
return $default(_that.tauxGlobal,_that.totaux,_that.parMatiere,_that.parSemaine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? tauxGlobal,  AttendanceTotals totaux,  List<CourseAttendance> parMatiere,  List<WeekAttendance> parSemaine)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceStats() when $default != null:
return $default(_that.tauxGlobal,_that.totaux,_that.parMatiere,_that.parSemaine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceStats implements AttendanceStats {
  const _AttendanceStats({this.tauxGlobal, required this.totaux,  List<CourseAttendance> parMatiere = const [],  List<WeekAttendance> parSemaine = const []}): _parMatiere = parMatiere,_parSemaine = parSemaine;
  factory _AttendanceStats.fromJson(Map<String, dynamic> json) => _$AttendanceStatsFromJson(json);

@override final  double? tauxGlobal;
@override final  AttendanceTotals totaux;
 final  List<CourseAttendance> _parMatiere;
@override@JsonKey() List<CourseAttendance> get parMatiere {
  if (_parMatiere is EqualUnmodifiableListView) return _parMatiere;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parMatiere);
}

 final  List<WeekAttendance> _parSemaine;
@override@JsonKey() List<WeekAttendance> get parSemaine {
  if (_parSemaine is EqualUnmodifiableListView) return _parSemaine;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parSemaine);
}


/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceStatsCopyWith<_AttendanceStats> get copyWith => __$AttendanceStatsCopyWithImpl<_AttendanceStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceStats&&(identical(other.tauxGlobal, tauxGlobal) || other.tauxGlobal == tauxGlobal)&&(identical(other.totaux, totaux) || other.totaux == totaux)&&const DeepCollectionEquality().equals(other.parMatiere, _parMatiere)&&const DeepCollectionEquality().equals(other.parSemaine, _parSemaine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tauxGlobal,totaux,const DeepCollectionEquality().hash(_parMatiere),const DeepCollectionEquality().hash(_parSemaine));
}

@override
String toString() {
    return 'AttendanceStats(tauxGlobal: $tauxGlobal, totaux: $totaux, parMatiere: $parMatiere, parSemaine: $parSemaine)';
}


}

/// @nodoc
abstract mixin class _$AttendanceStatsCopyWith<$Res> implements $AttendanceStatsCopyWith<$Res> {
  factory _$AttendanceStatsCopyWith(_AttendanceStats value, $Res Function(_AttendanceStats) _then) = __$AttendanceStatsCopyWithImpl;
@override @useResult
$Res call({
 double? tauxGlobal, AttendanceTotals totaux, List<CourseAttendance> parMatiere, List<WeekAttendance> parSemaine
});


@override $AttendanceTotalsCopyWith<$Res> get totaux;

}
/// @nodoc
class __$AttendanceStatsCopyWithImpl<$Res>
    implements _$AttendanceStatsCopyWith<$Res> {
  __$AttendanceStatsCopyWithImpl(this._self, this._then);

  final _AttendanceStats _self;
  final $Res Function(_AttendanceStats) _then;

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tauxGlobal = freezed,Object? totaux = null,Object? parMatiere = null,Object? parSemaine = null,}) {
  return _then(_AttendanceStats(
tauxGlobal: freezed == tauxGlobal ? _self.tauxGlobal : tauxGlobal // ignore: cast_nullable_to_non_nullable
as double?,totaux: null == totaux ? _self.totaux : totaux // ignore: cast_nullable_to_non_nullable
as AttendanceTotals,parMatiere: null == parMatiere ? _self._parMatiere : parMatiere // ignore: cast_nullable_to_non_nullable
as List<CourseAttendance>,parSemaine: null == parSemaine ? _self._parSemaine : parSemaine // ignore: cast_nullable_to_non_nullable
as List<WeekAttendance>,
  ));
}

/// Create a copy of AttendanceStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceTotalsCopyWith<$Res> get totaux {
  
  return $AttendanceTotalsCopyWith<$Res>(_self.totaux, (value) {
    return _then(_self.copyWith(totaux: value));
  });
}
}

// dart format on
