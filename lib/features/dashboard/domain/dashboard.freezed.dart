// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NextDue {

 String get invoiceId; DateTime get date; int get montant;
/// Create a copy of NextDue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NextDueCopyWith<NextDue> get copyWith => _$NextDueCopyWithImpl<NextDue>(this as NextDue, _$identity);

  /// Serializes this NextDue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NextDue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NextDue&&(identical(other.invoiceId, _this.invoiceId) || other.invoiceId == _this.invoiceId)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.montant, _this.montant) || other.montant == _this.montant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NextDue;
  return Object.hash(runtimeType,_this.invoiceId,_this.date,_this.montant);
}

@override
String toString() {
  final _this = this as NextDue;
  return 'NextDue(invoiceId: ${_this.invoiceId}, date: ${_this.date}, montant: ${_this.montant})';
}


}

/// @nodoc
abstract mixin class $NextDueCopyWith<$Res>  {
  factory $NextDueCopyWith(NextDue value, $Res Function(NextDue) _then) = _$NextDueCopyWithImpl;
@useResult
$Res call({
 String invoiceId, DateTime date, int montant
});




}
/// @nodoc
class _$NextDueCopyWithImpl<$Res>
    implements $NextDueCopyWith<$Res> {
  _$NextDueCopyWithImpl(this._self, this._then);

  final NextDue _self;
  final $Res Function(NextDue) _then;

/// Create a copy of NextDue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? invoiceId = null,Object? date = null,Object? montant = null,}) {
  return _then(NextDue(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NextDue].
extension NextDuePatterns on NextDue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NextDue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NextDue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NextDue value)  $default,){
final _that = this;
switch (_that) {
case _NextDue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NextDue value)?  $default,){
final _that = this;
switch (_that) {
case _NextDue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String invoiceId,  DateTime date,  int montant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NextDue() when $default != null:
return $default(_that.invoiceId,_that.date,_that.montant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String invoiceId,  DateTime date,  int montant)  $default,) {final _that = this;
switch (_that) {
case _NextDue():
return $default(_that.invoiceId,_that.date,_that.montant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String invoiceId,  DateTime date,  int montant)?  $default,) {final _that = this;
switch (_that) {
case _NextDue() when $default != null:
return $default(_that.invoiceId,_that.date,_that.montant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NextDue implements NextDue {
  const _NextDue({required this.invoiceId, required this.date, required this.montant});
  factory _NextDue.fromJson(Map<String, dynamic> json) => _$NextDueFromJson(json);

@override final  String invoiceId;
@override final  DateTime date;
@override final  int montant;

/// Create a copy of NextDue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NextDueCopyWith<_NextDue> get copyWith => __$NextDueCopyWithImpl<_NextDue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NextDueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NextDue&&(identical(other.invoiceId, invoiceId) || other.invoiceId == invoiceId)&&(identical(other.date, date) || other.date == date)&&(identical(other.montant, montant) || other.montant == montant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,invoiceId,date,montant);
}

@override
String toString() {
    return 'NextDue(invoiceId: $invoiceId, date: $date, montant: $montant)';
}


}

/// @nodoc
abstract mixin class _$NextDueCopyWith<$Res> implements $NextDueCopyWith<$Res> {
  factory _$NextDueCopyWith(_NextDue value, $Res Function(_NextDue) _then) = __$NextDueCopyWithImpl;
@override @useResult
$Res call({
 String invoiceId, DateTime date, int montant
});




}
/// @nodoc
class __$NextDueCopyWithImpl<$Res>
    implements _$NextDueCopyWith<$Res> {
  __$NextDueCopyWithImpl(this._self, this._then);

  final _NextDue _self;
  final $Res Function(_NextDue) _then;

/// Create a copy of NextDue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? invoiceId = null,Object? date = null,Object? montant = null,}) {
  return _then(_NextDue(
invoiceId: null == invoiceId ? _self.invoiceId : invoiceId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,montant: null == montant ? _self.montant : montant // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DashboardFinances {

 String get devise; int get totalDu; int get totalPaye; int get resteAPayer; NextDue? get prochaineEcheance; String get statut;
/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardFinancesCopyWith<DashboardFinances> get copyWith => _$DashboardFinancesCopyWithImpl<DashboardFinances>(this as DashboardFinances, _$identity);

  /// Serializes this DashboardFinances to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardFinances;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardFinances&&(identical(other.devise, _this.devise) || other.devise == _this.devise)&&(identical(other.totalDu, _this.totalDu) || other.totalDu == _this.totalDu)&&(identical(other.totalPaye, _this.totalPaye) || other.totalPaye == _this.totalPaye)&&(identical(other.resteAPayer, _this.resteAPayer) || other.resteAPayer == _this.resteAPayer)&&(identical(other.prochaineEcheance, _this.prochaineEcheance) || other.prochaineEcheance == _this.prochaineEcheance)&&(identical(other.statut, _this.statut) || other.statut == _this.statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardFinances;
  return Object.hash(runtimeType,_this.devise,_this.totalDu,_this.totalPaye,_this.resteAPayer,_this.prochaineEcheance,_this.statut);
}

@override
String toString() {
  final _this = this as DashboardFinances;
  return 'DashboardFinances(devise: ${_this.devise}, totalDu: ${_this.totalDu}, totalPaye: ${_this.totalPaye}, resteAPayer: ${_this.resteAPayer}, prochaineEcheance: ${_this.prochaineEcheance}, statut: ${_this.statut})';
}


}

/// @nodoc
abstract mixin class $DashboardFinancesCopyWith<$Res>  {
  factory $DashboardFinancesCopyWith(DashboardFinances value, $Res Function(DashboardFinances) _then) = _$DashboardFinancesCopyWithImpl;
@useResult
$Res call({
 String devise, int totalDu, int totalPaye, int resteAPayer, NextDue? prochaineEcheance, String statut
});


$NextDueCopyWith<$Res>? get prochaineEcheance;

}
/// @nodoc
class _$DashboardFinancesCopyWithImpl<$Res>
    implements $DashboardFinancesCopyWith<$Res> {
  _$DashboardFinancesCopyWithImpl(this._self, this._then);

  final DashboardFinances _self;
  final $Res Function(DashboardFinances) _then;

/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devise = null,Object? totalDu = null,Object? totalPaye = null,Object? resteAPayer = null,Object? prochaineEcheance = freezed,Object? statut = null,}) {
  return _then(DashboardFinances(
devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,totalDu: null == totalDu ? _self.totalDu : totalDu // ignore: cast_nullable_to_non_nullable
as int,totalPaye: null == totalPaye ? _self.totalPaye : totalPaye // ignore: cast_nullable_to_non_nullable
as int,resteAPayer: null == resteAPayer ? _self.resteAPayer : resteAPayer // ignore: cast_nullable_to_non_nullable
as int,prochaineEcheance: freezed == prochaineEcheance ? _self.prochaineEcheance : prochaineEcheance // ignore: cast_nullable_to_non_nullable
as NextDue?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextDueCopyWith<$Res>? get prochaineEcheance {
    if (_self.prochaineEcheance == null) {
    return null;
  }

  return $NextDueCopyWith<$Res>(_self.prochaineEcheance!, (value) {
    return _then(_self.copyWith(prochaineEcheance: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardFinances].
extension DashboardFinancesPatterns on DashboardFinances {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardFinances value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardFinances() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardFinances value)  $default,){
final _that = this;
switch (_that) {
case _DashboardFinances():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardFinances value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardFinances() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String devise,  int totalDu,  int totalPaye,  int resteAPayer,  NextDue? prochaineEcheance,  String statut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardFinances() when $default != null:
return $default(_that.devise,_that.totalDu,_that.totalPaye,_that.resteAPayer,_that.prochaineEcheance,_that.statut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String devise,  int totalDu,  int totalPaye,  int resteAPayer,  NextDue? prochaineEcheance,  String statut)  $default,) {final _that = this;
switch (_that) {
case _DashboardFinances():
return $default(_that.devise,_that.totalDu,_that.totalPaye,_that.resteAPayer,_that.prochaineEcheance,_that.statut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String devise,  int totalDu,  int totalPaye,  int resteAPayer,  NextDue? prochaineEcheance,  String statut)?  $default,) {final _that = this;
switch (_that) {
case _DashboardFinances() when $default != null:
return $default(_that.devise,_that.totalDu,_that.totalPaye,_that.resteAPayer,_that.prochaineEcheance,_that.statut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardFinances implements DashboardFinances {
  const _DashboardFinances({this.devise = 'XAF', this.totalDu = 0, this.totalPaye = 0, this.resteAPayer = 0, this.prochaineEcheance, this.statut = 'A_JOUR'});
  factory _DashboardFinances.fromJson(Map<String, dynamic> json) => _$DashboardFinancesFromJson(json);

@override@JsonKey() final  String devise;
@override@JsonKey() final  int totalDu;
@override@JsonKey() final  int totalPaye;
@override@JsonKey() final  int resteAPayer;
@override final  NextDue? prochaineEcheance;
@override@JsonKey() final  String statut;

/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardFinancesCopyWith<_DashboardFinances> get copyWith => __$DashboardFinancesCopyWithImpl<_DashboardFinances>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardFinancesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardFinances&&(identical(other.devise, devise) || other.devise == devise)&&(identical(other.totalDu, totalDu) || other.totalDu == totalDu)&&(identical(other.totalPaye, totalPaye) || other.totalPaye == totalPaye)&&(identical(other.resteAPayer, resteAPayer) || other.resteAPayer == resteAPayer)&&(identical(other.prochaineEcheance, prochaineEcheance) || other.prochaineEcheance == prochaineEcheance)&&(identical(other.statut, statut) || other.statut == statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,devise,totalDu,totalPaye,resteAPayer,prochaineEcheance,statut);
}

@override
String toString() {
    return 'DashboardFinances(devise: $devise, totalDu: $totalDu, totalPaye: $totalPaye, resteAPayer: $resteAPayer, prochaineEcheance: $prochaineEcheance, statut: $statut)';
}


}

/// @nodoc
abstract mixin class _$DashboardFinancesCopyWith<$Res> implements $DashboardFinancesCopyWith<$Res> {
  factory _$DashboardFinancesCopyWith(_DashboardFinances value, $Res Function(_DashboardFinances) _then) = __$DashboardFinancesCopyWithImpl;
@override @useResult
$Res call({
 String devise, int totalDu, int totalPaye, int resteAPayer, NextDue? prochaineEcheance, String statut
});


@override $NextDueCopyWith<$Res>? get prochaineEcheance;

}
/// @nodoc
class __$DashboardFinancesCopyWithImpl<$Res>
    implements _$DashboardFinancesCopyWith<$Res> {
  __$DashboardFinancesCopyWithImpl(this._self, this._then);

  final _DashboardFinances _self;
  final $Res Function(_DashboardFinances) _then;

/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devise = null,Object? totalDu = null,Object? totalPaye = null,Object? resteAPayer = null,Object? prochaineEcheance = freezed,Object? statut = null,}) {
  return _then(_DashboardFinances(
devise: null == devise ? _self.devise : devise // ignore: cast_nullable_to_non_nullable
as String,totalDu: null == totalDu ? _self.totalDu : totalDu // ignore: cast_nullable_to_non_nullable
as int,totalPaye: null == totalPaye ? _self.totalPaye : totalPaye // ignore: cast_nullable_to_non_nullable
as int,resteAPayer: null == resteAPayer ? _self.resteAPayer : resteAPayer // ignore: cast_nullable_to_non_nullable
as int,prochaineEcheance: freezed == prochaineEcheance ? _self.prochaineEcheance : prochaineEcheance // ignore: cast_nullable_to_non_nullable
as NextDue?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of DashboardFinances
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NextDueCopyWith<$Res>? get prochaineEcheance {
    if (_self.prochaineEcheance == null) {
    return null;
  }

  return $NextDueCopyWith<$Res>(_self.prochaineEcheance!, (value) {
    return _then(_self.copyWith(prochaineEcheance: value));
  });
}
}


/// @nodoc
mixin _$RecentAbsence {

 String get id; String get statut; DateTime get date; String get cours; int get minutesRetard; String? get justification;
/// Create a copy of RecentAbsence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentAbsenceCopyWith<RecentAbsence> get copyWith => _$RecentAbsenceCopyWithImpl<RecentAbsence>(this as RecentAbsence, _$identity);

  /// Serializes this RecentAbsence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecentAbsence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentAbsence&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.cours, _this.cours) || other.cours == _this.cours)&&(identical(other.minutesRetard, _this.minutesRetard) || other.minutesRetard == _this.minutesRetard)&&(identical(other.justification, _this.justification) || other.justification == _this.justification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecentAbsence;
  return Object.hash(runtimeType,_this.id,_this.statut,_this.date,_this.cours,_this.minutesRetard,_this.justification);
}

@override
String toString() {
  final _this = this as RecentAbsence;
  return 'RecentAbsence(id: ${_this.id}, statut: ${_this.statut}, date: ${_this.date}, cours: ${_this.cours}, minutesRetard: ${_this.minutesRetard}, justification: ${_this.justification})';
}


}

/// @nodoc
abstract mixin class $RecentAbsenceCopyWith<$Res>  {
  factory $RecentAbsenceCopyWith(RecentAbsence value, $Res Function(RecentAbsence) _then) = _$RecentAbsenceCopyWithImpl;
@useResult
$Res call({
 String id, String statut, DateTime date, String cours, int minutesRetard, String? justification
});




}
/// @nodoc
class _$RecentAbsenceCopyWithImpl<$Res>
    implements $RecentAbsenceCopyWith<$Res> {
  _$RecentAbsenceCopyWithImpl(this._self, this._then);

  final RecentAbsence _self;
  final $Res Function(RecentAbsence) _then;

/// Create a copy of RecentAbsence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statut = null,Object? date = null,Object? cours = null,Object? minutesRetard = null,Object? justification = freezed,}) {
  return _then(RecentAbsence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,cours: null == cours ? _self.cours : cours // ignore: cast_nullable_to_non_nullable
as String,minutesRetard: null == minutesRetard ? _self.minutesRetard : minutesRetard // ignore: cast_nullable_to_non_nullable
as int,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentAbsence].
extension RecentAbsencePatterns on RecentAbsence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentAbsence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentAbsence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentAbsence value)  $default,){
final _that = this;
switch (_that) {
case _RecentAbsence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentAbsence value)?  $default,){
final _that = this;
switch (_that) {
case _RecentAbsence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String statut,  DateTime date,  String cours,  int minutesRetard,  String? justification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentAbsence() when $default != null:
return $default(_that.id,_that.statut,_that.date,_that.cours,_that.minutesRetard,_that.justification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String statut,  DateTime date,  String cours,  int minutesRetard,  String? justification)  $default,) {final _that = this;
switch (_that) {
case _RecentAbsence():
return $default(_that.id,_that.statut,_that.date,_that.cours,_that.minutesRetard,_that.justification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String statut,  DateTime date,  String cours,  int minutesRetard,  String? justification)?  $default,) {final _that = this;
switch (_that) {
case _RecentAbsence() when $default != null:
return $default(_that.id,_that.statut,_that.date,_that.cours,_that.minutesRetard,_that.justification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentAbsence implements RecentAbsence {
  const _RecentAbsence({required this.id, required this.statut, required this.date, required this.cours, this.minutesRetard = 0, this.justification});
  factory _RecentAbsence.fromJson(Map<String, dynamic> json) => _$RecentAbsenceFromJson(json);

@override final  String id;
@override final  String statut;
@override final  DateTime date;
@override final  String cours;
@override@JsonKey() final  int minutesRetard;
@override final  String? justification;

/// Create a copy of RecentAbsence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentAbsenceCopyWith<_RecentAbsence> get copyWith => __$RecentAbsenceCopyWithImpl<_RecentAbsence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentAbsenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentAbsence&&(identical(other.id, id) || other.id == id)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.date, date) || other.date == date)&&(identical(other.cours, cours) || other.cours == cours)&&(identical(other.minutesRetard, minutesRetard) || other.minutesRetard == minutesRetard)&&(identical(other.justification, justification) || other.justification == justification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,statut,date,cours,minutesRetard,justification);
}

@override
String toString() {
    return 'RecentAbsence(id: $id, statut: $statut, date: $date, cours: $cours, minutesRetard: $minutesRetard, justification: $justification)';
}


}

/// @nodoc
abstract mixin class _$RecentAbsenceCopyWith<$Res> implements $RecentAbsenceCopyWith<$Res> {
  factory _$RecentAbsenceCopyWith(_RecentAbsence value, $Res Function(_RecentAbsence) _then) = __$RecentAbsenceCopyWithImpl;
@override @useResult
$Res call({
 String id, String statut, DateTime date, String cours, int minutesRetard, String? justification
});




}
/// @nodoc
class __$RecentAbsenceCopyWithImpl<$Res>
    implements _$RecentAbsenceCopyWith<$Res> {
  __$RecentAbsenceCopyWithImpl(this._self, this._then);

  final _RecentAbsence _self;
  final $Res Function(_RecentAbsence) _then;

/// Create a copy of RecentAbsence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statut = null,Object? date = null,Object? cours = null,Object? minutesRetard = null,Object? justification = freezed,}) {
  return _then(_RecentAbsence(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,cours: null == cours ? _self.cours : cours // ignore: cast_nullable_to_non_nullable
as String,minutesRetard: null == minutesRetard ? _self.minutesRetard : minutesRetard // ignore: cast_nullable_to_non_nullable
as int,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DashboardPresence {

 double? get tauxAssiduiteMois; int get seancesMois; int get absencesMois; int get retardsMois; List<RecentAbsence> get dernieresAbsences;
/// Create a copy of DashboardPresence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPresenceCopyWith<DashboardPresence> get copyWith => _$DashboardPresenceCopyWithImpl<DashboardPresence>(this as DashboardPresence, _$identity);

  /// Serializes this DashboardPresence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardPresence;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPresence&&(identical(other.tauxAssiduiteMois, _this.tauxAssiduiteMois) || other.tauxAssiduiteMois == _this.tauxAssiduiteMois)&&(identical(other.seancesMois, _this.seancesMois) || other.seancesMois == _this.seancesMois)&&(identical(other.absencesMois, _this.absencesMois) || other.absencesMois == _this.absencesMois)&&(identical(other.retardsMois, _this.retardsMois) || other.retardsMois == _this.retardsMois)&&const DeepCollectionEquality().equals(other.dernieresAbsences, _this.dernieresAbsences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardPresence;
  return Object.hash(runtimeType,_this.tauxAssiduiteMois,_this.seancesMois,_this.absencesMois,_this.retardsMois,const DeepCollectionEquality().hash(_this.dernieresAbsences));
}

@override
String toString() {
  final _this = this as DashboardPresence;
  return 'DashboardPresence(tauxAssiduiteMois: ${_this.tauxAssiduiteMois}, seancesMois: ${_this.seancesMois}, absencesMois: ${_this.absencesMois}, retardsMois: ${_this.retardsMois}, dernieresAbsences: ${_this.dernieresAbsences})';
}


}

/// @nodoc
abstract mixin class $DashboardPresenceCopyWith<$Res>  {
  factory $DashboardPresenceCopyWith(DashboardPresence value, $Res Function(DashboardPresence) _then) = _$DashboardPresenceCopyWithImpl;
@useResult
$Res call({
 double? tauxAssiduiteMois, int seancesMois, int absencesMois, int retardsMois, List<RecentAbsence> dernieresAbsences
});




}
/// @nodoc
class _$DashboardPresenceCopyWithImpl<$Res>
    implements $DashboardPresenceCopyWith<$Res> {
  _$DashboardPresenceCopyWithImpl(this._self, this._then);

  final DashboardPresence _self;
  final $Res Function(DashboardPresence) _then;

/// Create a copy of DashboardPresence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tauxAssiduiteMois = freezed,Object? seancesMois = null,Object? absencesMois = null,Object? retardsMois = null,Object? dernieresAbsences = null,}) {
  return _then(DashboardPresence(
tauxAssiduiteMois: freezed == tauxAssiduiteMois ? _self.tauxAssiduiteMois : tauxAssiduiteMois // ignore: cast_nullable_to_non_nullable
as double?,seancesMois: null == seancesMois ? _self.seancesMois : seancesMois // ignore: cast_nullable_to_non_nullable
as int,absencesMois: null == absencesMois ? _self.absencesMois : absencesMois // ignore: cast_nullable_to_non_nullable
as int,retardsMois: null == retardsMois ? _self.retardsMois : retardsMois // ignore: cast_nullable_to_non_nullable
as int,dernieresAbsences: null == dernieresAbsences ? _self.dernieresAbsences : dernieresAbsences // ignore: cast_nullable_to_non_nullable
as List<RecentAbsence>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPresence].
extension DashboardPresencePatterns on DashboardPresence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPresence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPresence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPresence value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPresence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPresence value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPresence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? tauxAssiduiteMois,  int seancesMois,  int absencesMois,  int retardsMois,  List<RecentAbsence> dernieresAbsences)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPresence() when $default != null:
return $default(_that.tauxAssiduiteMois,_that.seancesMois,_that.absencesMois,_that.retardsMois,_that.dernieresAbsences);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? tauxAssiduiteMois,  int seancesMois,  int absencesMois,  int retardsMois,  List<RecentAbsence> dernieresAbsences)  $default,) {final _that = this;
switch (_that) {
case _DashboardPresence():
return $default(_that.tauxAssiduiteMois,_that.seancesMois,_that.absencesMois,_that.retardsMois,_that.dernieresAbsences);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? tauxAssiduiteMois,  int seancesMois,  int absencesMois,  int retardsMois,  List<RecentAbsence> dernieresAbsences)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPresence() when $default != null:
return $default(_that.tauxAssiduiteMois,_that.seancesMois,_that.absencesMois,_that.retardsMois,_that.dernieresAbsences);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardPresence implements DashboardPresence {
  const _DashboardPresence({this.tauxAssiduiteMois, this.seancesMois = 0, this.absencesMois = 0, this.retardsMois = 0,  List<RecentAbsence> dernieresAbsences = const []}): _dernieresAbsences = dernieresAbsences;
  factory _DashboardPresence.fromJson(Map<String, dynamic> json) => _$DashboardPresenceFromJson(json);

@override final  double? tauxAssiduiteMois;
@override@JsonKey() final  int seancesMois;
@override@JsonKey() final  int absencesMois;
@override@JsonKey() final  int retardsMois;
 final  List<RecentAbsence> _dernieresAbsences;
@override@JsonKey() List<RecentAbsence> get dernieresAbsences {
  if (_dernieresAbsences is EqualUnmodifiableListView) return _dernieresAbsences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dernieresAbsences);
}


/// Create a copy of DashboardPresence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPresenceCopyWith<_DashboardPresence> get copyWith => __$DashboardPresenceCopyWithImpl<_DashboardPresence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardPresenceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPresence&&(identical(other.tauxAssiduiteMois, tauxAssiduiteMois) || other.tauxAssiduiteMois == tauxAssiduiteMois)&&(identical(other.seancesMois, seancesMois) || other.seancesMois == seancesMois)&&(identical(other.absencesMois, absencesMois) || other.absencesMois == absencesMois)&&(identical(other.retardsMois, retardsMois) || other.retardsMois == retardsMois)&&const DeepCollectionEquality().equals(other.dernieresAbsences, _dernieresAbsences));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tauxAssiduiteMois,seancesMois,absencesMois,retardsMois,const DeepCollectionEquality().hash(_dernieresAbsences));
}

@override
String toString() {
    return 'DashboardPresence(tauxAssiduiteMois: $tauxAssiduiteMois, seancesMois: $seancesMois, absencesMois: $absencesMois, retardsMois: $retardsMois, dernieresAbsences: $dernieresAbsences)';
}


}

/// @nodoc
abstract mixin class _$DashboardPresenceCopyWith<$Res> implements $DashboardPresenceCopyWith<$Res> {
  factory _$DashboardPresenceCopyWith(_DashboardPresence value, $Res Function(_DashboardPresence) _then) = __$DashboardPresenceCopyWithImpl;
@override @useResult
$Res call({
 double? tauxAssiduiteMois, int seancesMois, int absencesMois, int retardsMois, List<RecentAbsence> dernieresAbsences
});




}
/// @nodoc
class __$DashboardPresenceCopyWithImpl<$Res>
    implements _$DashboardPresenceCopyWith<$Res> {
  __$DashboardPresenceCopyWithImpl(this._self, this._then);

  final _DashboardPresence _self;
  final $Res Function(_DashboardPresence) _then;

/// Create a copy of DashboardPresence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tauxAssiduiteMois = freezed,Object? seancesMois = null,Object? absencesMois = null,Object? retardsMois = null,Object? dernieresAbsences = null,}) {
  return _then(_DashboardPresence(
tauxAssiduiteMois: freezed == tauxAssiduiteMois ? _self.tauxAssiduiteMois : tauxAssiduiteMois // ignore: cast_nullable_to_non_nullable
as double?,seancesMois: null == seancesMois ? _self.seancesMois : seancesMois // ignore: cast_nullable_to_non_nullable
as int,absencesMois: null == absencesMois ? _self.absencesMois : absencesMois // ignore: cast_nullable_to_non_nullable
as int,retardsMois: null == retardsMois ? _self.retardsMois : retardsMois // ignore: cast_nullable_to_non_nullable
as int,dernieresAbsences: null == dernieresAbsences ? _self._dernieresAbsences : dernieresAbsences // ignore: cast_nullable_to_non_nullable
as List<RecentAbsence>,
  ));
}


}


/// @nodoc
mixin _$SemesterRef {

 String get id; String get code; String get libelle;
/// Create a copy of SemesterRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterRefCopyWith<SemesterRef> get copyWith => _$SemesterRefCopyWithImpl<SemesterRef>(this as SemesterRef, _$identity);

  /// Serializes this SemesterRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SemesterRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SemesterRef;
  return Object.hash(runtimeType,_this.id,_this.code,_this.libelle);
}

@override
String toString() {
  final _this = this as SemesterRef;
  return 'SemesterRef(id: ${_this.id}, code: ${_this.code}, libelle: ${_this.libelle})';
}


}

/// @nodoc
abstract mixin class $SemesterRefCopyWith<$Res>  {
  factory $SemesterRefCopyWith(SemesterRef value, $Res Function(SemesterRef) _then) = _$SemesterRefCopyWithImpl;
@useResult
$Res call({
 String id, String code, String libelle
});




}
/// @nodoc
class _$SemesterRefCopyWithImpl<$Res>
    implements $SemesterRefCopyWith<$Res> {
  _$SemesterRefCopyWithImpl(this._self, this._then);

  final SemesterRef _self;
  final $Res Function(SemesterRef) _then;

/// Create a copy of SemesterRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? libelle = null,}) {
  return _then(SemesterRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SemesterRef].
extension SemesterRefPatterns on SemesterRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterRef value)  $default,){
final _that = this;
switch (_that) {
case _SemesterRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterRef value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String libelle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SemesterRef() when $default != null:
return $default(_that.id,_that.code,_that.libelle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String libelle)  $default,) {final _that = this;
switch (_that) {
case _SemesterRef():
return $default(_that.id,_that.code,_that.libelle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String libelle)?  $default,) {final _that = this;
switch (_that) {
case _SemesterRef() when $default != null:
return $default(_that.id,_that.code,_that.libelle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SemesterRef implements SemesterRef {
  const _SemesterRef({required this.id, required this.code, required this.libelle});
  factory _SemesterRef.fromJson(Map<String, dynamic> json) => _$SemesterRefFromJson(json);

@override final  String id;
@override final  String code;
@override final  String libelle;

/// Create a copy of SemesterRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterRefCopyWith<_SemesterRef> get copyWith => __$SemesterRefCopyWithImpl<_SemesterRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SemesterRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.libelle, libelle) || other.libelle == libelle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,libelle);
}

@override
String toString() {
    return 'SemesterRef(id: $id, code: $code, libelle: $libelle)';
}


}

/// @nodoc
abstract mixin class _$SemesterRefCopyWith<$Res> implements $SemesterRefCopyWith<$Res> {
  factory _$SemesterRefCopyWith(_SemesterRef value, $Res Function(_SemesterRef) _then) = __$SemesterRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String libelle
});




}
/// @nodoc
class __$SemesterRefCopyWithImpl<$Res>
    implements _$SemesterRefCopyWith<$Res> {
  __$SemesterRefCopyWithImpl(this._self, this._then);

  final _SemesterRef _self;
  final $Res Function(_SemesterRef) _then;

/// Create a copy of SemesterRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? libelle = null,}) {
  return _then(_SemesterRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RecentGrade {

 String get id; String get matiere; String get evaluation; double get valeur; double get bareme; DateTime get date;
/// Create a copy of RecentGrade
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentGradeCopyWith<RecentGrade> get copyWith => _$RecentGradeCopyWithImpl<RecentGrade>(this as RecentGrade, _$identity);

  /// Serializes this RecentGrade to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecentGrade;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentGrade&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.matiere, _this.matiere) || other.matiere == _this.matiere)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation)&&(identical(other.valeur, _this.valeur) || other.valeur == _this.valeur)&&(identical(other.bareme, _this.bareme) || other.bareme == _this.bareme)&&(identical(other.date, _this.date) || other.date == _this.date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecentGrade;
  return Object.hash(runtimeType,_this.id,_this.matiere,_this.evaluation,_this.valeur,_this.bareme,_this.date);
}

@override
String toString() {
  final _this = this as RecentGrade;
  return 'RecentGrade(id: ${_this.id}, matiere: ${_this.matiere}, evaluation: ${_this.evaluation}, valeur: ${_this.valeur}, bareme: ${_this.bareme}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $RecentGradeCopyWith<$Res>  {
  factory $RecentGradeCopyWith(RecentGrade value, $Res Function(RecentGrade) _then) = _$RecentGradeCopyWithImpl;
@useResult
$Res call({
 String id, String matiere, String evaluation, double valeur, double bareme, DateTime date
});




}
/// @nodoc
class _$RecentGradeCopyWithImpl<$Res>
    implements $RecentGradeCopyWith<$Res> {
  _$RecentGradeCopyWithImpl(this._self, this._then);

  final RecentGrade _self;
  final $Res Function(RecentGrade) _then;

/// Create a copy of RecentGrade
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? matiere = null,Object? evaluation = null,Object? valeur = null,Object? bareme = null,Object? date = null,}) {
  return _then(RecentGrade(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as String,valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,bareme: null == bareme ? _self.bareme : bareme // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentGrade].
extension RecentGradePatterns on RecentGrade {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentGrade value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentGrade() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentGrade value)  $default,){
final _that = this;
switch (_that) {
case _RecentGrade():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentGrade value)?  $default,){
final _that = this;
switch (_that) {
case _RecentGrade() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String matiere,  String evaluation,  double valeur,  double bareme,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentGrade() when $default != null:
return $default(_that.id,_that.matiere,_that.evaluation,_that.valeur,_that.bareme,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String matiere,  String evaluation,  double valeur,  double bareme,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _RecentGrade():
return $default(_that.id,_that.matiere,_that.evaluation,_that.valeur,_that.bareme,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String matiere,  String evaluation,  double valeur,  double bareme,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _RecentGrade() when $default != null:
return $default(_that.id,_that.matiere,_that.evaluation,_that.valeur,_that.bareme,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentGrade implements RecentGrade {
  const _RecentGrade({required this.id, required this.matiere, required this.evaluation, required this.valeur, this.bareme = 20, required this.date});
  factory _RecentGrade.fromJson(Map<String, dynamic> json) => _$RecentGradeFromJson(json);

@override final  String id;
@override final  String matiere;
@override final  String evaluation;
@override final  double valeur;
@override@JsonKey() final  double bareme;
@override final  DateTime date;

/// Create a copy of RecentGrade
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentGradeCopyWith<_RecentGrade> get copyWith => __$RecentGradeCopyWithImpl<_RecentGrade>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentGradeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentGrade&&(identical(other.id, id) || other.id == id)&&(identical(other.matiere, matiere) || other.matiere == matiere)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation)&&(identical(other.valeur, valeur) || other.valeur == valeur)&&(identical(other.bareme, bareme) || other.bareme == bareme)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,matiere,evaluation,valeur,bareme,date);
}

@override
String toString() {
    return 'RecentGrade(id: $id, matiere: $matiere, evaluation: $evaluation, valeur: $valeur, bareme: $bareme, date: $date)';
}


}

/// @nodoc
abstract mixin class _$RecentGradeCopyWith<$Res> implements $RecentGradeCopyWith<$Res> {
  factory _$RecentGradeCopyWith(_RecentGrade value, $Res Function(_RecentGrade) _then) = __$RecentGradeCopyWithImpl;
@override @useResult
$Res call({
 String id, String matiere, String evaluation, double valeur, double bareme, DateTime date
});




}
/// @nodoc
class __$RecentGradeCopyWithImpl<$Res>
    implements _$RecentGradeCopyWith<$Res> {
  __$RecentGradeCopyWithImpl(this._self, this._then);

  final _RecentGrade _self;
  final $Res Function(_RecentGrade) _then;

/// Create a copy of RecentGrade
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? matiere = null,Object? evaluation = null,Object? valeur = null,Object? bareme = null,Object? date = null,}) {
  return _then(_RecentGrade(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as String,valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,bareme: null == bareme ? _self.bareme : bareme // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DashboardResults {

 SemesterRef? get semestre; double? get moyenneGenerale; int get creditsAcquis; List<RecentGrade> get dernieresNotes;
/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardResultsCopyWith<DashboardResults> get copyWith => _$DashboardResultsCopyWithImpl<DashboardResults>(this as DashboardResults, _$identity);

  /// Serializes this DashboardResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardResults;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardResults&&(identical(other.semestre, _this.semestre) || other.semestre == _this.semestre)&&(identical(other.moyenneGenerale, _this.moyenneGenerale) || other.moyenneGenerale == _this.moyenneGenerale)&&(identical(other.creditsAcquis, _this.creditsAcquis) || other.creditsAcquis == _this.creditsAcquis)&&const DeepCollectionEquality().equals(other.dernieresNotes, _this.dernieresNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardResults;
  return Object.hash(runtimeType,_this.semestre,_this.moyenneGenerale,_this.creditsAcquis,const DeepCollectionEquality().hash(_this.dernieresNotes));
}

@override
String toString() {
  final _this = this as DashboardResults;
  return 'DashboardResults(semestre: ${_this.semestre}, moyenneGenerale: ${_this.moyenneGenerale}, creditsAcquis: ${_this.creditsAcquis}, dernieresNotes: ${_this.dernieresNotes})';
}


}

/// @nodoc
abstract mixin class $DashboardResultsCopyWith<$Res>  {
  factory $DashboardResultsCopyWith(DashboardResults value, $Res Function(DashboardResults) _then) = _$DashboardResultsCopyWithImpl;
@useResult
$Res call({
 SemesterRef? semestre, double? moyenneGenerale, int creditsAcquis, List<RecentGrade> dernieresNotes
});


$SemesterRefCopyWith<$Res>? get semestre;

}
/// @nodoc
class _$DashboardResultsCopyWithImpl<$Res>
    implements $DashboardResultsCopyWith<$Res> {
  _$DashboardResultsCopyWithImpl(this._self, this._then);

  final DashboardResults _self;
  final $Res Function(DashboardResults) _then;

/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semestre = freezed,Object? moyenneGenerale = freezed,Object? creditsAcquis = null,Object? dernieresNotes = null,}) {
  return _then(DashboardResults(
semestre: freezed == semestre ? _self.semestre : semestre // ignore: cast_nullable_to_non_nullable
as SemesterRef?,moyenneGenerale: freezed == moyenneGenerale ? _self.moyenneGenerale : moyenneGenerale // ignore: cast_nullable_to_non_nullable
as double?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,dernieresNotes: null == dernieresNotes ? _self.dernieresNotes : dernieresNotes // ignore: cast_nullable_to_non_nullable
as List<RecentGrade>,
  ));
}
/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterRefCopyWith<$Res>? get semestre {
    if (_self.semestre == null) {
    return null;
  }

  return $SemesterRefCopyWith<$Res>(_self.semestre!, (value) {
    return _then(_self.copyWith(semestre: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardResults].
extension DashboardResultsPatterns on DashboardResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardResults value)  $default,){
final _that = this;
switch (_that) {
case _DashboardResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardResults value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SemesterRef? semestre,  double? moyenneGenerale,  int creditsAcquis,  List<RecentGrade> dernieresNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardResults() when $default != null:
return $default(_that.semestre,_that.moyenneGenerale,_that.creditsAcquis,_that.dernieresNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SemesterRef? semestre,  double? moyenneGenerale,  int creditsAcquis,  List<RecentGrade> dernieresNotes)  $default,) {final _that = this;
switch (_that) {
case _DashboardResults():
return $default(_that.semestre,_that.moyenneGenerale,_that.creditsAcquis,_that.dernieresNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SemesterRef? semestre,  double? moyenneGenerale,  int creditsAcquis,  List<RecentGrade> dernieresNotes)?  $default,) {final _that = this;
switch (_that) {
case _DashboardResults() when $default != null:
return $default(_that.semestre,_that.moyenneGenerale,_that.creditsAcquis,_that.dernieresNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardResults implements DashboardResults {
  const _DashboardResults({this.semestre, this.moyenneGenerale, this.creditsAcquis = 0,  List<RecentGrade> dernieresNotes = const []}): _dernieresNotes = dernieresNotes;
  factory _DashboardResults.fromJson(Map<String, dynamic> json) => _$DashboardResultsFromJson(json);

@override final  SemesterRef? semestre;
@override final  double? moyenneGenerale;
@override@JsonKey() final  int creditsAcquis;
 final  List<RecentGrade> _dernieresNotes;
@override@JsonKey() List<RecentGrade> get dernieresNotes {
  if (_dernieresNotes is EqualUnmodifiableListView) return _dernieresNotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dernieresNotes);
}


/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardResultsCopyWith<_DashboardResults> get copyWith => __$DashboardResultsCopyWithImpl<_DashboardResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardResultsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardResults&&(identical(other.semestre, semestre) || other.semestre == semestre)&&(identical(other.moyenneGenerale, moyenneGenerale) || other.moyenneGenerale == moyenneGenerale)&&(identical(other.creditsAcquis, creditsAcquis) || other.creditsAcquis == creditsAcquis)&&const DeepCollectionEquality().equals(other.dernieresNotes, _dernieresNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,semestre,moyenneGenerale,creditsAcquis,const DeepCollectionEquality().hash(_dernieresNotes));
}

@override
String toString() {
    return 'DashboardResults(semestre: $semestre, moyenneGenerale: $moyenneGenerale, creditsAcquis: $creditsAcquis, dernieresNotes: $dernieresNotes)';
}


}

/// @nodoc
abstract mixin class _$DashboardResultsCopyWith<$Res> implements $DashboardResultsCopyWith<$Res> {
  factory _$DashboardResultsCopyWith(_DashboardResults value, $Res Function(_DashboardResults) _then) = __$DashboardResultsCopyWithImpl;
@override @useResult
$Res call({
 SemesterRef? semestre, double? moyenneGenerale, int creditsAcquis, List<RecentGrade> dernieresNotes
});


@override $SemesterRefCopyWith<$Res>? get semestre;

}
/// @nodoc
class __$DashboardResultsCopyWithImpl<$Res>
    implements _$DashboardResultsCopyWith<$Res> {
  __$DashboardResultsCopyWithImpl(this._self, this._then);

  final _DashboardResults _self;
  final $Res Function(_DashboardResults) _then;

/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semestre = freezed,Object? moyenneGenerale = freezed,Object? creditsAcquis = null,Object? dernieresNotes = null,}) {
  return _then(_DashboardResults(
semestre: freezed == semestre ? _self.semestre : semestre // ignore: cast_nullable_to_non_nullable
as SemesterRef?,moyenneGenerale: freezed == moyenneGenerale ? _self.moyenneGenerale : moyenneGenerale // ignore: cast_nullable_to_non_nullable
as double?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,dernieresNotes: null == dernieresNotes ? _self._dernieresNotes : dernieresNotes // ignore: cast_nullable_to_non_nullable
as List<RecentGrade>,
  ));
}

/// Create a copy of DashboardResults
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterRefCopyWith<$Res>? get semestre {
    if (_self.semestre == null) {
    return null;
  }

  return $SemesterRefCopyWith<$Res>(_self.semestre!, (value) {
    return _then(_self.copyWith(semestre: value));
  });
}
}


/// @nodoc
mixin _$TodaySlot {

 String get id; DateTime get debut; DateTime get fin; String get statut; String get matiere; String get salle; String get campus; String get enseignant;
/// Create a copy of TodaySlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodaySlotCopyWith<TodaySlot> get copyWith => _$TodaySlotCopyWithImpl<TodaySlot>(this as TodaySlot, _$identity);

  /// Serializes this TodaySlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TodaySlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodaySlot&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.debut, _this.debut) || other.debut == _this.debut)&&(identical(other.fin, _this.fin) || other.fin == _this.fin)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.matiere, _this.matiere) || other.matiere == _this.matiere)&&(identical(other.salle, _this.salle) || other.salle == _this.salle)&&(identical(other.campus, _this.campus) || other.campus == _this.campus)&&(identical(other.enseignant, _this.enseignant) || other.enseignant == _this.enseignant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TodaySlot;
  return Object.hash(runtimeType,_this.id,_this.debut,_this.fin,_this.statut,_this.matiere,_this.salle,_this.campus,_this.enseignant);
}

@override
String toString() {
  final _this = this as TodaySlot;
  return 'TodaySlot(id: ${_this.id}, debut: ${_this.debut}, fin: ${_this.fin}, statut: ${_this.statut}, matiere: ${_this.matiere}, salle: ${_this.salle}, campus: ${_this.campus}, enseignant: ${_this.enseignant})';
}


}

/// @nodoc
abstract mixin class $TodaySlotCopyWith<$Res>  {
  factory $TodaySlotCopyWith(TodaySlot value, $Res Function(TodaySlot) _then) = _$TodaySlotCopyWithImpl;
@useResult
$Res call({
 String id, DateTime debut, DateTime fin, String statut, String matiere, String salle, String campus, String enseignant
});




}
/// @nodoc
class _$TodaySlotCopyWithImpl<$Res>
    implements $TodaySlotCopyWith<$Res> {
  _$TodaySlotCopyWithImpl(this._self, this._then);

  final TodaySlot _self;
  final $Res Function(TodaySlot) _then;

/// Create a copy of TodaySlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? matiere = null,Object? salle = null,Object? campus = null,Object? enseignant = null,}) {
  return _then(TodaySlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TodaySlot].
extension TodaySlotPatterns on TodaySlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodaySlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodaySlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodaySlot value)  $default,){
final _that = this;
switch (_that) {
case _TodaySlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodaySlot value)?  $default,){
final _that = this;
switch (_that) {
case _TodaySlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime debut,  DateTime fin,  String statut,  String matiere,  String salle,  String campus,  String enseignant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodaySlot() when $default != null:
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.matiere,_that.salle,_that.campus,_that.enseignant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime debut,  DateTime fin,  String statut,  String matiere,  String salle,  String campus,  String enseignant)  $default,) {final _that = this;
switch (_that) {
case _TodaySlot():
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.matiere,_that.salle,_that.campus,_that.enseignant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime debut,  DateTime fin,  String statut,  String matiere,  String salle,  String campus,  String enseignant)?  $default,) {final _that = this;
switch (_that) {
case _TodaySlot() when $default != null:
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.matiere,_that.salle,_that.campus,_that.enseignant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TodaySlot implements TodaySlot {
  const _TodaySlot({required this.id, required this.debut, required this.fin, required this.statut, required this.matiere, required this.salle, required this.campus, required this.enseignant});
  factory _TodaySlot.fromJson(Map<String, dynamic> json) => _$TodaySlotFromJson(json);

@override final  String id;
@override final  DateTime debut;
@override final  DateTime fin;
@override final  String statut;
@override final  String matiere;
@override final  String salle;
@override final  String campus;
@override final  String enseignant;

/// Create a copy of TodaySlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodaySlotCopyWith<_TodaySlot> get copyWith => __$TodaySlotCopyWithImpl<_TodaySlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TodaySlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodaySlot&&(identical(other.id, id) || other.id == id)&&(identical(other.debut, debut) || other.debut == debut)&&(identical(other.fin, fin) || other.fin == fin)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.matiere, matiere) || other.matiere == matiere)&&(identical(other.salle, salle) || other.salle == salle)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.enseignant, enseignant) || other.enseignant == enseignant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,debut,fin,statut,matiere,salle,campus,enseignant);
}

@override
String toString() {
    return 'TodaySlot(id: $id, debut: $debut, fin: $fin, statut: $statut, matiere: $matiere, salle: $salle, campus: $campus, enseignant: $enseignant)';
}


}

/// @nodoc
abstract mixin class _$TodaySlotCopyWith<$Res> implements $TodaySlotCopyWith<$Res> {
  factory _$TodaySlotCopyWith(_TodaySlot value, $Res Function(_TodaySlot) _then) = __$TodaySlotCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime debut, DateTime fin, String statut, String matiere, String salle, String campus, String enseignant
});




}
/// @nodoc
class __$TodaySlotCopyWithImpl<$Res>
    implements _$TodaySlotCopyWith<$Res> {
  __$TodaySlotCopyWithImpl(this._self, this._then);

  final _TodaySlot _self;
  final $Res Function(_TodaySlot) _then;

/// Create a copy of TodaySlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? matiere = null,Object? salle = null,Object? campus = null,Object? enseignant = null,}) {
  return _then(_TodaySlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DashboardAlert {

 String get type; String get niveau; String get message; String? get refId;
/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAlertCopyWith<DashboardAlert> get copyWith => _$DashboardAlertCopyWithImpl<DashboardAlert>(this as DashboardAlert, _$identity);

  /// Serializes this DashboardAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DashboardAlert;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAlert&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.niveau, _this.niveau) || other.niveau == _this.niveau)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.refId, _this.refId) || other.refId == _this.refId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DashboardAlert;
  return Object.hash(runtimeType,_this.type,_this.niveau,_this.message,_this.refId);
}

@override
String toString() {
  final _this = this as DashboardAlert;
  return 'DashboardAlert(type: ${_this.type}, niveau: ${_this.niveau}, message: ${_this.message}, refId: ${_this.refId})';
}


}

/// @nodoc
abstract mixin class $DashboardAlertCopyWith<$Res>  {
  factory $DashboardAlertCopyWith(DashboardAlert value, $Res Function(DashboardAlert) _then) = _$DashboardAlertCopyWithImpl;
@useResult
$Res call({
 String type, String niveau, String message, String? refId
});




}
/// @nodoc
class _$DashboardAlertCopyWithImpl<$Res>
    implements $DashboardAlertCopyWith<$Res> {
  _$DashboardAlertCopyWithImpl(this._self, this._then);

  final DashboardAlert _self;
  final $Res Function(DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? niveau = null,Object? message = null,Object? refId = freezed,}) {
  return _then(DashboardAlert(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,niveau: null == niveau ? _self.niveau : niveau // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardAlert].
extension DashboardAlertPatterns on DashboardAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAlert value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAlert value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String niveau,  String message,  String? refId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.type,_that.niveau,_that.message,_that.refId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String niveau,  String message,  String? refId)  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert():
return $default(_that.type,_that.niveau,_that.message,_that.refId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String niveau,  String message,  String? refId)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.type,_that.niveau,_that.message,_that.refId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardAlert implements DashboardAlert {
  const _DashboardAlert({required this.type, required this.niveau, required this.message, this.refId});
  factory _DashboardAlert.fromJson(Map<String, dynamic> json) => _$DashboardAlertFromJson(json);

@override final  String type;
@override final  String niveau;
@override final  String message;
@override final  String? refId;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAlertCopyWith<_DashboardAlert> get copyWith => __$DashboardAlertCopyWithImpl<_DashboardAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardAlertToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAlert&&(identical(other.type, type) || other.type == type)&&(identical(other.niveau, niveau) || other.niveau == niveau)&&(identical(other.message, message) || other.message == message)&&(identical(other.refId, refId) || other.refId == refId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,niveau,message,refId);
}

@override
String toString() {
    return 'DashboardAlert(type: $type, niveau: $niveau, message: $message, refId: $refId)';
}


}

/// @nodoc
abstract mixin class _$DashboardAlertCopyWith<$Res> implements $DashboardAlertCopyWith<$Res> {
  factory _$DashboardAlertCopyWith(_DashboardAlert value, $Res Function(_DashboardAlert) _then) = __$DashboardAlertCopyWithImpl;
@override @useResult
$Res call({
 String type, String niveau, String message, String? refId
});




}
/// @nodoc
class __$DashboardAlertCopyWithImpl<$Res>
    implements _$DashboardAlertCopyWith<$Res> {
  __$DashboardAlertCopyWithImpl(this._self, this._then);

  final _DashboardAlert _self;
  final $Res Function(_DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? niveau = null,Object? message = null,Object? refId = freezed,}) {
  return _then(_DashboardAlert(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,niveau: null == niveau ? _self.niveau : niveau // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,refId: freezed == refId ? _self.refId : refId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NewsItem {

 String get id; String get titre; String get contenu; DateTime get datePublication;
/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsItemCopyWith<NewsItem> get copyWith => _$NewsItemCopyWithImpl<NewsItem>(this as NewsItem, _$identity);

  /// Serializes this NewsItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NewsItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.titre, _this.titre) || other.titre == _this.titre)&&(identical(other.contenu, _this.contenu) || other.contenu == _this.contenu)&&(identical(other.datePublication, _this.datePublication) || other.datePublication == _this.datePublication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NewsItem;
  return Object.hash(runtimeType,_this.id,_this.titre,_this.contenu,_this.datePublication);
}

@override
String toString() {
  final _this = this as NewsItem;
  return 'NewsItem(id: ${_this.id}, titre: ${_this.titre}, contenu: ${_this.contenu}, datePublication: ${_this.datePublication})';
}


}

/// @nodoc
abstract mixin class $NewsItemCopyWith<$Res>  {
  factory $NewsItemCopyWith(NewsItem value, $Res Function(NewsItem) _then) = _$NewsItemCopyWithImpl;
@useResult
$Res call({
 String id, String titre, String contenu, DateTime datePublication
});




}
/// @nodoc
class _$NewsItemCopyWithImpl<$Res>
    implements $NewsItemCopyWith<$Res> {
  _$NewsItemCopyWithImpl(this._self, this._then);

  final NewsItem _self;
  final $Res Function(NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? contenu = null,Object? datePublication = null,}) {
  return _then(NewsItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,datePublication: null == datePublication ? _self.datePublication : datePublication // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsItem].
extension NewsItemPatterns on NewsItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsItem value)  $default,){
final _that = this;
switch (_that) {
case _NewsItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsItem value)?  $default,){
final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titre,  String contenu,  DateTime datePublication)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
return $default(_that.id,_that.titre,_that.contenu,_that.datePublication);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titre,  String contenu,  DateTime datePublication)  $default,) {final _that = this;
switch (_that) {
case _NewsItem():
return $default(_that.id,_that.titre,_that.contenu,_that.datePublication);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titre,  String contenu,  DateTime datePublication)?  $default,) {final _that = this;
switch (_that) {
case _NewsItem() when $default != null:
return $default(_that.id,_that.titre,_that.contenu,_that.datePublication);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsItem implements NewsItem {
  const _NewsItem({required this.id, required this.titre, required this.contenu, required this.datePublication});
  factory _NewsItem.fromJson(Map<String, dynamic> json) => _$NewsItemFromJson(json);

@override final  String id;
@override final  String titre;
@override final  String contenu;
@override final  DateTime datePublication;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsItemCopyWith<_NewsItem> get copyWith => __$NewsItemCopyWithImpl<_NewsItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsItem&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.datePublication, datePublication) || other.datePublication == datePublication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,titre,contenu,datePublication);
}

@override
String toString() {
    return 'NewsItem(id: $id, titre: $titre, contenu: $contenu, datePublication: $datePublication)';
}


}

/// @nodoc
abstract mixin class _$NewsItemCopyWith<$Res> implements $NewsItemCopyWith<$Res> {
  factory _$NewsItemCopyWith(_NewsItem value, $Res Function(_NewsItem) _then) = __$NewsItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String titre, String contenu, DateTime datePublication
});




}
/// @nodoc
class __$NewsItemCopyWithImpl<$Res>
    implements _$NewsItemCopyWith<$Res> {
  __$NewsItemCopyWithImpl(this._self, this._then);

  final _NewsItem _self;
  final $Res Function(_NewsItem) _then;

/// Create a copy of NewsItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? contenu = null,Object? datePublication = null,}) {
  return _then(_NewsItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,datePublication: null == datePublication ? _self.datePublication : datePublication // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Dashboard {

 DashboardFinances get finances; DashboardPresence get presence; DashboardResults get resultats; List<TodaySlot> get aujourdhui; List<DashboardAlert> get alertes; List<NewsItem> get actualites;
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardCopyWith<Dashboard> get copyWith => _$DashboardCopyWithImpl<Dashboard>(this as Dashboard, _$identity);

  /// Serializes this Dashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Dashboard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dashboard&&(identical(other.finances, _this.finances) || other.finances == _this.finances)&&(identical(other.presence, _this.presence) || other.presence == _this.presence)&&(identical(other.resultats, _this.resultats) || other.resultats == _this.resultats)&&const DeepCollectionEquality().equals(other.aujourdhui, _this.aujourdhui)&&const DeepCollectionEquality().equals(other.alertes, _this.alertes)&&const DeepCollectionEquality().equals(other.actualites, _this.actualites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Dashboard;
  return Object.hash(runtimeType,_this.finances,_this.presence,_this.resultats,const DeepCollectionEquality().hash(_this.aujourdhui),const DeepCollectionEquality().hash(_this.alertes),const DeepCollectionEquality().hash(_this.actualites));
}

@override
String toString() {
  final _this = this as Dashboard;
  return 'Dashboard(finances: ${_this.finances}, presence: ${_this.presence}, resultats: ${_this.resultats}, aujourdhui: ${_this.aujourdhui}, alertes: ${_this.alertes}, actualites: ${_this.actualites})';
}


}

/// @nodoc
abstract mixin class $DashboardCopyWith<$Res>  {
  factory $DashboardCopyWith(Dashboard value, $Res Function(Dashboard) _then) = _$DashboardCopyWithImpl;
@useResult
$Res call({
 DashboardFinances finances, DashboardPresence presence, DashboardResults resultats, List<TodaySlot> aujourdhui, List<DashboardAlert> alertes, List<NewsItem> actualites
});


$DashboardFinancesCopyWith<$Res> get finances;$DashboardPresenceCopyWith<$Res> get presence;$DashboardResultsCopyWith<$Res> get resultats;

}
/// @nodoc
class _$DashboardCopyWithImpl<$Res>
    implements $DashboardCopyWith<$Res> {
  _$DashboardCopyWithImpl(this._self, this._then);

  final Dashboard _self;
  final $Res Function(Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finances = null,Object? presence = null,Object? resultats = null,Object? aujourdhui = null,Object? alertes = null,Object? actualites = null,}) {
  return _then(Dashboard(
finances: null == finances ? _self.finances : finances // ignore: cast_nullable_to_non_nullable
as DashboardFinances,presence: null == presence ? _self.presence : presence // ignore: cast_nullable_to_non_nullable
as DashboardPresence,resultats: null == resultats ? _self.resultats : resultats // ignore: cast_nullable_to_non_nullable
as DashboardResults,aujourdhui: null == aujourdhui ? _self.aujourdhui : aujourdhui // ignore: cast_nullable_to_non_nullable
as List<TodaySlot>,alertes: null == alertes ? _self.alertes : alertes // ignore: cast_nullable_to_non_nullable
as List<DashboardAlert>,actualites: null == actualites ? _self.actualites : actualites // ignore: cast_nullable_to_non_nullable
as List<NewsItem>,
  ));
}
/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFinancesCopyWith<$Res> get finances {
  
  return $DashboardFinancesCopyWith<$Res>(_self.finances, (value) {
    return _then(_self.copyWith(finances: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPresenceCopyWith<$Res> get presence {
  
  return $DashboardPresenceCopyWith<$Res>(_self.presence, (value) {
    return _then(_self.copyWith(presence: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardResultsCopyWith<$Res> get resultats {
  
  return $DashboardResultsCopyWith<$Res>(_self.resultats, (value) {
    return _then(_self.copyWith(resultats: value));
  });
}
}


/// Adds pattern-matching-related methods to [Dashboard].
extension DashboardPatterns on Dashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dashboard value)  $default,){
final _that = this;
switch (_that) {
case _Dashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dashboard value)?  $default,){
final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DashboardFinances finances,  DashboardPresence presence,  DashboardResults resultats,  List<TodaySlot> aujourdhui,  List<DashboardAlert> alertes,  List<NewsItem> actualites)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.finances,_that.presence,_that.resultats,_that.aujourdhui,_that.alertes,_that.actualites);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DashboardFinances finances,  DashboardPresence presence,  DashboardResults resultats,  List<TodaySlot> aujourdhui,  List<DashboardAlert> alertes,  List<NewsItem> actualites)  $default,) {final _that = this;
switch (_that) {
case _Dashboard():
return $default(_that.finances,_that.presence,_that.resultats,_that.aujourdhui,_that.alertes,_that.actualites);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DashboardFinances finances,  DashboardPresence presence,  DashboardResults resultats,  List<TodaySlot> aujourdhui,  List<DashboardAlert> alertes,  List<NewsItem> actualites)?  $default,) {final _that = this;
switch (_that) {
case _Dashboard() when $default != null:
return $default(_that.finances,_that.presence,_that.resultats,_that.aujourdhui,_that.alertes,_that.actualites);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dashboard implements Dashboard {
  const _Dashboard({required this.finances, required this.presence, required this.resultats,  List<TodaySlot> aujourdhui = const [],  List<DashboardAlert> alertes = const [],  List<NewsItem> actualites = const []}): _aujourdhui = aujourdhui,_alertes = alertes,_actualites = actualites;
  factory _Dashboard.fromJson(Map<String, dynamic> json) => _$DashboardFromJson(json);

@override final  DashboardFinances finances;
@override final  DashboardPresence presence;
@override final  DashboardResults resultats;
 final  List<TodaySlot> _aujourdhui;
@override@JsonKey() List<TodaySlot> get aujourdhui {
  if (_aujourdhui is EqualUnmodifiableListView) return _aujourdhui;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_aujourdhui);
}

 final  List<DashboardAlert> _alertes;
@override@JsonKey() List<DashboardAlert> get alertes {
  if (_alertes is EqualUnmodifiableListView) return _alertes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alertes);
}

 final  List<NewsItem> _actualites;
@override@JsonKey() List<NewsItem> get actualites {
  if (_actualites is EqualUnmodifiableListView) return _actualites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actualites);
}


/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardCopyWith<_Dashboard> get copyWith => __$DashboardCopyWithImpl<_Dashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dashboard&&(identical(other.finances, finances) || other.finances == finances)&&(identical(other.presence, presence) || other.presence == presence)&&(identical(other.resultats, resultats) || other.resultats == resultats)&&const DeepCollectionEquality().equals(other.aujourdhui, _aujourdhui)&&const DeepCollectionEquality().equals(other.alertes, _alertes)&&const DeepCollectionEquality().equals(other.actualites, _actualites));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,finances,presence,resultats,const DeepCollectionEquality().hash(_aujourdhui),const DeepCollectionEquality().hash(_alertes),const DeepCollectionEquality().hash(_actualites));
}

@override
String toString() {
    return 'Dashboard(finances: $finances, presence: $presence, resultats: $resultats, aujourdhui: $aujourdhui, alertes: $alertes, actualites: $actualites)';
}


}

/// @nodoc
abstract mixin class _$DashboardCopyWith<$Res> implements $DashboardCopyWith<$Res> {
  factory _$DashboardCopyWith(_Dashboard value, $Res Function(_Dashboard) _then) = __$DashboardCopyWithImpl;
@override @useResult
$Res call({
 DashboardFinances finances, DashboardPresence presence, DashboardResults resultats, List<TodaySlot> aujourdhui, List<DashboardAlert> alertes, List<NewsItem> actualites
});


@override $DashboardFinancesCopyWith<$Res> get finances;@override $DashboardPresenceCopyWith<$Res> get presence;@override $DashboardResultsCopyWith<$Res> get resultats;

}
/// @nodoc
class __$DashboardCopyWithImpl<$Res>
    implements _$DashboardCopyWith<$Res> {
  __$DashboardCopyWithImpl(this._self, this._then);

  final _Dashboard _self;
  final $Res Function(_Dashboard) _then;

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finances = null,Object? presence = null,Object? resultats = null,Object? aujourdhui = null,Object? alertes = null,Object? actualites = null,}) {
  return _then(_Dashboard(
finances: null == finances ? _self.finances : finances // ignore: cast_nullable_to_non_nullable
as DashboardFinances,presence: null == presence ? _self.presence : presence // ignore: cast_nullable_to_non_nullable
as DashboardPresence,resultats: null == resultats ? _self.resultats : resultats // ignore: cast_nullable_to_non_nullable
as DashboardResults,aujourdhui: null == aujourdhui ? _self._aujourdhui : aujourdhui // ignore: cast_nullable_to_non_nullable
as List<TodaySlot>,alertes: null == alertes ? _self._alertes : alertes // ignore: cast_nullable_to_non_nullable
as List<DashboardAlert>,actualites: null == actualites ? _self._actualites : actualites // ignore: cast_nullable_to_non_nullable
as List<NewsItem>,
  ));
}

/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFinancesCopyWith<$Res> get finances {
  
  return $DashboardFinancesCopyWith<$Res>(_self.finances, (value) {
    return _then(_self.copyWith(finances: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardPresenceCopyWith<$Res> get presence {
  
  return $DashboardPresenceCopyWith<$Res>(_self.presence, (value) {
    return _then(_self.copyWith(presence: value));
  });
}/// Create a copy of Dashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardResultsCopyWith<$Res> get resultats {
  
  return $DashboardResultsCopyWith<$Res>(_self.resultats, (value) {
    return _then(_self.copyWith(resultats: value));
  });
}
}

// dart format on
