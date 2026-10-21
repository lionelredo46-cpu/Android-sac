// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timetable_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimetableSlot {

 String get id; DateTime get debut; DateTime get fin; String get statut; String? get motif; String get matiere; String get code; String get enseignant; String get salle; String get campus;
/// Create a copy of TimetableSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableSlotCopyWith<TimetableSlot> get copyWith => _$TimetableSlotCopyWithImpl<TimetableSlot>(this as TimetableSlot, _$identity);

  /// Serializes this TimetableSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimetableSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableSlot&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.debut, _this.debut) || other.debut == _this.debut)&&(identical(other.fin, _this.fin) || other.fin == _this.fin)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.motif, _this.motif) || other.motif == _this.motif)&&(identical(other.matiere, _this.matiere) || other.matiere == _this.matiere)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.enseignant, _this.enseignant) || other.enseignant == _this.enseignant)&&(identical(other.salle, _this.salle) || other.salle == _this.salle)&&(identical(other.campus, _this.campus) || other.campus == _this.campus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimetableSlot;
  return Object.hash(runtimeType,_this.id,_this.debut,_this.fin,_this.statut,_this.motif,_this.matiere,_this.code,_this.enseignant,_this.salle,_this.campus);
}

@override
String toString() {
  final _this = this as TimetableSlot;
  return 'TimetableSlot(id: ${_this.id}, debut: ${_this.debut}, fin: ${_this.fin}, statut: ${_this.statut}, motif: ${_this.motif}, matiere: ${_this.matiere}, code: ${_this.code}, enseignant: ${_this.enseignant}, salle: ${_this.salle}, campus: ${_this.campus})';
}


}

/// @nodoc
abstract mixin class $TimetableSlotCopyWith<$Res>  {
  factory $TimetableSlotCopyWith(TimetableSlot value, $Res Function(TimetableSlot) _then) = _$TimetableSlotCopyWithImpl;
@useResult
$Res call({
 String id, DateTime debut, DateTime fin, String statut, String? motif, String matiere, String code, String enseignant, String salle, String campus
});




}
/// @nodoc
class _$TimetableSlotCopyWithImpl<$Res>
    implements $TimetableSlotCopyWith<$Res> {
  _$TimetableSlotCopyWithImpl(this._self, this._then);

  final TimetableSlot _self;
  final $Res Function(TimetableSlot) _then;

/// Create a copy of TimetableSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? motif = freezed,Object? matiere = null,Object? code = null,Object? enseignant = null,Object? salle = null,Object? campus = null,}) {
  return _then(TimetableSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableSlot].
extension TimetableSlotPatterns on TimetableSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableSlot value)  $default,){
final _that = this;
switch (_that) {
case _TimetableSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableSlot value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime debut,  DateTime fin,  String statut,  String? motif,  String matiere,  String code,  String enseignant,  String salle,  String campus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableSlot() when $default != null:
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.motif,_that.matiere,_that.code,_that.enseignant,_that.salle,_that.campus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime debut,  DateTime fin,  String statut,  String? motif,  String matiere,  String code,  String enseignant,  String salle,  String campus)  $default,) {final _that = this;
switch (_that) {
case _TimetableSlot():
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.motif,_that.matiere,_that.code,_that.enseignant,_that.salle,_that.campus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime debut,  DateTime fin,  String statut,  String? motif,  String matiere,  String code,  String enseignant,  String salle,  String campus)?  $default,) {final _that = this;
switch (_that) {
case _TimetableSlot() when $default != null:
return $default(_that.id,_that.debut,_that.fin,_that.statut,_that.motif,_that.matiere,_that.code,_that.enseignant,_that.salle,_that.campus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableSlot extends TimetableSlot {
  const _TimetableSlot({required this.id, required this.debut, required this.fin, required this.statut, this.motif, required this.matiere, required this.code, required this.enseignant, required this.salle, required this.campus}): super._();
  factory _TimetableSlot.fromJson(Map<String, dynamic> json) => _$TimetableSlotFromJson(json);

@override final  String id;
@override final  DateTime debut;
@override final  DateTime fin;
@override final  String statut;
@override final  String? motif;
@override final  String matiere;
@override final  String code;
@override final  String enseignant;
@override final  String salle;
@override final  String campus;

/// Create a copy of TimetableSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableSlotCopyWith<_TimetableSlot> get copyWith => __$TimetableSlotCopyWithImpl<_TimetableSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableSlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableSlot&&(identical(other.id, id) || other.id == id)&&(identical(other.debut, debut) || other.debut == debut)&&(identical(other.fin, fin) || other.fin == fin)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.motif, motif) || other.motif == motif)&&(identical(other.matiere, matiere) || other.matiere == matiere)&&(identical(other.code, code) || other.code == code)&&(identical(other.enseignant, enseignant) || other.enseignant == enseignant)&&(identical(other.salle, salle) || other.salle == salle)&&(identical(other.campus, campus) || other.campus == campus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,debut,fin,statut,motif,matiere,code,enseignant,salle,campus);
}

@override
String toString() {
    return 'TimetableSlot(id: $id, debut: $debut, fin: $fin, statut: $statut, motif: $motif, matiere: $matiere, code: $code, enseignant: $enseignant, salle: $salle, campus: $campus)';
}


}

/// @nodoc
abstract mixin class _$TimetableSlotCopyWith<$Res> implements $TimetableSlotCopyWith<$Res> {
  factory _$TimetableSlotCopyWith(_TimetableSlot value, $Res Function(_TimetableSlot) _then) = __$TimetableSlotCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime debut, DateTime fin, String statut, String? motif, String matiere, String code, String enseignant, String salle, String campus
});




}
/// @nodoc
class __$TimetableSlotCopyWithImpl<$Res>
    implements _$TimetableSlotCopyWith<$Res> {
  __$TimetableSlotCopyWithImpl(this._self, this._then);

  final _TimetableSlot _self;
  final $Res Function(_TimetableSlot) _then;

/// Create a copy of TimetableSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? motif = freezed,Object? matiere = null,Object? code = null,Object? enseignant = null,Object? salle = null,Object? campus = null,}) {
  return _then(_TimetableSlot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,motif: freezed == motif ? _self.motif : motif // ignore: cast_nullable_to_non_nullable
as String?,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TimetableExportRequest {

 ExportChannel get channel; DateTime get weekStart; String get studentId; String get studentName; String? get matricule; String? get groupName; String? get programName; PdfLayout get layout; ImageFormat get imageFormat; bool get includeCancelled; int get alarmMinutes;
/// Create a copy of TimetableExportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableExportRequestCopyWith<TimetableExportRequest> get copyWith => _$TimetableExportRequestCopyWithImpl<TimetableExportRequest>(this as TimetableExportRequest, _$identity);

  /// Serializes this TimetableExportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TimetableExportRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimetableExportRequest&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.weekStart, _this.weekStart) || other.weekStart == _this.weekStart)&&(identical(other.studentId, _this.studentId) || other.studentId == _this.studentId)&&(identical(other.studentName, _this.studentName) || other.studentName == _this.studentName)&&(identical(other.matricule, _this.matricule) || other.matricule == _this.matricule)&&(identical(other.groupName, _this.groupName) || other.groupName == _this.groupName)&&(identical(other.programName, _this.programName) || other.programName == _this.programName)&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.imageFormat, _this.imageFormat) || other.imageFormat == _this.imageFormat)&&(identical(other.includeCancelled, _this.includeCancelled) || other.includeCancelled == _this.includeCancelled)&&(identical(other.alarmMinutes, _this.alarmMinutes) || other.alarmMinutes == _this.alarmMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TimetableExportRequest;
  return Object.hash(runtimeType,_this.channel,_this.weekStart,_this.studentId,_this.studentName,_this.matricule,_this.groupName,_this.programName,_this.layout,_this.imageFormat,_this.includeCancelled,_this.alarmMinutes);
}

@override
String toString() {
  final _this = this as TimetableExportRequest;
  return 'TimetableExportRequest(channel: ${_this.channel}, weekStart: ${_this.weekStart}, studentId: ${_this.studentId}, studentName: ${_this.studentName}, matricule: ${_this.matricule}, groupName: ${_this.groupName}, programName: ${_this.programName}, layout: ${_this.layout}, imageFormat: ${_this.imageFormat}, includeCancelled: ${_this.includeCancelled}, alarmMinutes: ${_this.alarmMinutes})';
}


}

/// @nodoc
abstract mixin class $TimetableExportRequestCopyWith<$Res>  {
  factory $TimetableExportRequestCopyWith(TimetableExportRequest value, $Res Function(TimetableExportRequest) _then) = _$TimetableExportRequestCopyWithImpl;
@useResult
$Res call({
 ExportChannel channel, DateTime weekStart, String studentId, String studentName, String? matricule, String? groupName, String? programName, PdfLayout layout, ImageFormat imageFormat, bool includeCancelled, int alarmMinutes
});




}
/// @nodoc
class _$TimetableExportRequestCopyWithImpl<$Res>
    implements $TimetableExportRequestCopyWith<$Res> {
  _$TimetableExportRequestCopyWithImpl(this._self, this._then);

  final TimetableExportRequest _self;
  final $Res Function(TimetableExportRequest) _then;

/// Create a copy of TimetableExportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channel = null,Object? weekStart = null,Object? studentId = null,Object? studentName = null,Object? matricule = freezed,Object? groupName = freezed,Object? programName = freezed,Object? layout = null,Object? imageFormat = null,Object? includeCancelled = null,Object? alarmMinutes = null,}) {
  return _then(TimetableExportRequest(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ExportChannel,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,matricule: freezed == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as PdfLayout,imageFormat: null == imageFormat ? _self.imageFormat : imageFormat // ignore: cast_nullable_to_non_nullable
as ImageFormat,includeCancelled: null == includeCancelled ? _self.includeCancelled : includeCancelled // ignore: cast_nullable_to_non_nullable
as bool,alarmMinutes: null == alarmMinutes ? _self.alarmMinutes : alarmMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TimetableExportRequest].
extension TimetableExportRequestPatterns on TimetableExportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimetableExportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimetableExportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimetableExportRequest value)  $default,){
final _that = this;
switch (_that) {
case _TimetableExportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimetableExportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TimetableExportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExportChannel channel,  DateTime weekStart,  String studentId,  String studentName,  String? matricule,  String? groupName,  String? programName,  PdfLayout layout,  ImageFormat imageFormat,  bool includeCancelled,  int alarmMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimetableExportRequest() when $default != null:
return $default(_that.channel,_that.weekStart,_that.studentId,_that.studentName,_that.matricule,_that.groupName,_that.programName,_that.layout,_that.imageFormat,_that.includeCancelled,_that.alarmMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExportChannel channel,  DateTime weekStart,  String studentId,  String studentName,  String? matricule,  String? groupName,  String? programName,  PdfLayout layout,  ImageFormat imageFormat,  bool includeCancelled,  int alarmMinutes)  $default,) {final _that = this;
switch (_that) {
case _TimetableExportRequest():
return $default(_that.channel,_that.weekStart,_that.studentId,_that.studentName,_that.matricule,_that.groupName,_that.programName,_that.layout,_that.imageFormat,_that.includeCancelled,_that.alarmMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExportChannel channel,  DateTime weekStart,  String studentId,  String studentName,  String? matricule,  String? groupName,  String? programName,  PdfLayout layout,  ImageFormat imageFormat,  bool includeCancelled,  int alarmMinutes)?  $default,) {final _that = this;
switch (_that) {
case _TimetableExportRequest() when $default != null:
return $default(_that.channel,_that.weekStart,_that.studentId,_that.studentName,_that.matricule,_that.groupName,_that.programName,_that.layout,_that.imageFormat,_that.includeCancelled,_that.alarmMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimetableExportRequest implements TimetableExportRequest {
  const _TimetableExportRequest({required this.channel, required this.weekStart, required this.studentId, required this.studentName, this.matricule, this.groupName, this.programName, this.layout = PdfLayout.landscape, this.imageFormat = ImageFormat.story, this.includeCancelled = true, this.alarmMinutes = 15});
  factory _TimetableExportRequest.fromJson(Map<String, dynamic> json) => _$TimetableExportRequestFromJson(json);

@override final  ExportChannel channel;
@override final  DateTime weekStart;
@override final  String studentId;
@override final  String studentName;
@override final  String? matricule;
@override final  String? groupName;
@override final  String? programName;
@override@JsonKey() final  PdfLayout layout;
@override@JsonKey() final  ImageFormat imageFormat;
@override@JsonKey() final  bool includeCancelled;
@override@JsonKey() final  int alarmMinutes;

/// Create a copy of TimetableExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableExportRequestCopyWith<_TimetableExportRequest> get copyWith => __$TimetableExportRequestCopyWithImpl<_TimetableExportRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableExportRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimetableExportRequest&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.studentName, studentName) || other.studentName == studentName)&&(identical(other.matricule, matricule) || other.matricule == matricule)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.programName, programName) || other.programName == programName)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.imageFormat, imageFormat) || other.imageFormat == imageFormat)&&(identical(other.includeCancelled, includeCancelled) || other.includeCancelled == includeCancelled)&&(identical(other.alarmMinutes, alarmMinutes) || other.alarmMinutes == alarmMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,channel,weekStart,studentId,studentName,matricule,groupName,programName,layout,imageFormat,includeCancelled,alarmMinutes);
}

@override
String toString() {
    return 'TimetableExportRequest(channel: $channel, weekStart: $weekStart, studentId: $studentId, studentName: $studentName, matricule: $matricule, groupName: $groupName, programName: $programName, layout: $layout, imageFormat: $imageFormat, includeCancelled: $includeCancelled, alarmMinutes: $alarmMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimetableExportRequestCopyWith<$Res> implements $TimetableExportRequestCopyWith<$Res> {
  factory _$TimetableExportRequestCopyWith(_TimetableExportRequest value, $Res Function(_TimetableExportRequest) _then) = __$TimetableExportRequestCopyWithImpl;
@override @useResult
$Res call({
 ExportChannel channel, DateTime weekStart, String studentId, String studentName, String? matricule, String? groupName, String? programName, PdfLayout layout, ImageFormat imageFormat, bool includeCancelled, int alarmMinutes
});




}
/// @nodoc
class __$TimetableExportRequestCopyWithImpl<$Res>
    implements _$TimetableExportRequestCopyWith<$Res> {
  __$TimetableExportRequestCopyWithImpl(this._self, this._then);

  final _TimetableExportRequest _self;
  final $Res Function(_TimetableExportRequest) _then;

/// Create a copy of TimetableExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channel = null,Object? weekStart = null,Object? studentId = null,Object? studentName = null,Object? matricule = freezed,Object? groupName = freezed,Object? programName = freezed,Object? layout = null,Object? imageFormat = null,Object? includeCancelled = null,Object? alarmMinutes = null,}) {
  return _then(_TimetableExportRequest(
channel: null == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as ExportChannel,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,studentName: null == studentName ? _self.studentName : studentName // ignore: cast_nullable_to_non_nullable
as String,matricule: freezed == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String?,groupName: freezed == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String?,programName: freezed == programName ? _self.programName : programName // ignore: cast_nullable_to_non_nullable
as String?,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as PdfLayout,imageFormat: null == imageFormat ? _self.imageFormat : imageFormat // ignore: cast_nullable_to_non_nullable
as ImageFormat,includeCancelled: null == includeCancelled ? _self.includeCancelled : includeCancelled // ignore: cast_nullable_to_non_nullable
as bool,alarmMinutes: null == alarmMinutes ? _self.alarmMinutes : alarmMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Timetable {

 List<TimetableSlot> get creneaux;
/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimetableCopyWith<Timetable> get copyWith => _$TimetableCopyWithImpl<Timetable>(this as Timetable, _$identity);

  /// Serializes this Timetable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Timetable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timetable&&const DeepCollectionEquality().equals(other.creneaux, _this.creneaux));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Timetable;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.creneaux));
}

@override
String toString() {
  final _this = this as Timetable;
  return 'Timetable(creneaux: ${_this.creneaux})';
}


}

/// @nodoc
abstract mixin class $TimetableCopyWith<$Res>  {
  factory $TimetableCopyWith(Timetable value, $Res Function(Timetable) _then) = _$TimetableCopyWithImpl;
@useResult
$Res call({
 List<TimetableSlot> creneaux
});




}
/// @nodoc
class _$TimetableCopyWithImpl<$Res>
    implements $TimetableCopyWith<$Res> {
  _$TimetableCopyWithImpl(this._self, this._then);

  final Timetable _self;
  final $Res Function(Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creneaux = null,}) {
  return _then(Timetable(
creneaux: null == creneaux ? _self.creneaux : creneaux // ignore: cast_nullable_to_non_nullable
as List<TimetableSlot>,
  ));
}

}


/// Adds pattern-matching-related methods to [Timetable].
extension TimetablePatterns on Timetable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Timetable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Timetable value)  $default,){
final _that = this;
switch (_that) {
case _Timetable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Timetable value)?  $default,){
final _that = this;
switch (_that) {
case _Timetable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TimetableSlot> creneaux)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.creneaux);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TimetableSlot> creneaux)  $default,) {final _that = this;
switch (_that) {
case _Timetable():
return $default(_that.creneaux);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TimetableSlot> creneaux)?  $default,) {final _that = this;
switch (_that) {
case _Timetable() when $default != null:
return $default(_that.creneaux);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Timetable implements Timetable {
  const _Timetable({ List<TimetableSlot> creneaux = const []}): _creneaux = creneaux;
  factory _Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);

 final  List<TimetableSlot> _creneaux;
@override@JsonKey() List<TimetableSlot> get creneaux {
  if (_creneaux is EqualUnmodifiableListView) return _creneaux;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_creneaux);
}


/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimetableCopyWith<_Timetable> get copyWith => __$TimetableCopyWithImpl<_Timetable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimetableToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timetable&&const DeepCollectionEquality().equals(other.creneaux, _creneaux));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_creneaux));
}

@override
String toString() {
    return 'Timetable(creneaux: $creneaux)';
}


}

/// @nodoc
abstract mixin class _$TimetableCopyWith<$Res> implements $TimetableCopyWith<$Res> {
  factory _$TimetableCopyWith(_Timetable value, $Res Function(_Timetable) _then) = __$TimetableCopyWithImpl;
@override @useResult
$Res call({
 List<TimetableSlot> creneaux
});




}
/// @nodoc
class __$TimetableCopyWithImpl<$Res>
    implements _$TimetableCopyWith<$Res> {
  __$TimetableCopyWithImpl(this._self, this._then);

  final _Timetable _self;
  final $Res Function(_Timetable) _then;

/// Create a copy of Timetable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creneaux = null,}) {
  return _then(_Timetable(
creneaux: null == creneaux ? _self._creneaux : creneaux // ignore: cast_nullable_to_non_nullable
as List<TimetableSlot>,
  ));
}


}


/// @nodoc
mixin _$CalendarEvent {

 String get id; String get titre; String? get description; String get type; DateTime get debut; DateTime get fin;
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<CalendarEvent> get copyWith => _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CalendarEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.titre, _this.titre) || other.titre == _this.titre)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.debut, _this.debut) || other.debut == _this.debut)&&(identical(other.fin, _this.fin) || other.fin == _this.fin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CalendarEvent;
  return Object.hash(runtimeType,_this.id,_this.titre,_this.description,_this.type,_this.debut,_this.fin);
}

@override
String toString() {
  final _this = this as CalendarEvent;
  return 'CalendarEvent(id: ${_this.id}, titre: ${_this.titre}, description: ${_this.description}, type: ${_this.type}, debut: ${_this.debut}, fin: ${_this.fin})';
}


}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res>  {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) = _$CalendarEventCopyWithImpl;
@useResult
$Res call({
 String id, String titre, String? description, String type, DateTime debut, DateTime fin
});




}
/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? description = freezed,Object? type = null,Object? debut = null,Object? fin = null,}) {
  return _then(CalendarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarEvent].
extension CalendarEventPatterns on CalendarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEvent value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titre,  String? description,  String type,  DateTime debut,  DateTime fin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.titre,_that.description,_that.type,_that.debut,_that.fin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titre,  String? description,  String type,  DateTime debut,  DateTime fin)  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent():
return $default(_that.id,_that.titre,_that.description,_that.type,_that.debut,_that.fin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titre,  String? description,  String type,  DateTime debut,  DateTime fin)?  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.titre,_that.description,_that.type,_that.debut,_that.fin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarEvent implements CalendarEvent {
  const _CalendarEvent({required this.id, required this.titre, this.description, required this.type, required this.debut, required this.fin});
  factory _CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

@override final  String id;
@override final  String titre;
@override final  String? description;
@override final  String type;
@override final  DateTime debut;
@override final  DateTime fin;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventCopyWith<_CalendarEvent> get copyWith => __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.debut, debut) || other.debut == debut)&&(identical(other.fin, fin) || other.fin == fin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,titre,description,type,debut,fin);
}

@override
String toString() {
    return 'CalendarEvent(id: $id, titre: $titre, description: $description, type: $type, debut: $debut, fin: $fin)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) = __$CalendarEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String titre, String? description, String type, DateTime debut, DateTime fin
});




}
/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? description = freezed,Object? type = null,Object? debut = null,Object? fin = null,}) {
  return _then(_CalendarEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
