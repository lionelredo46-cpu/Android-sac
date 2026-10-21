// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedSlot {

@JsonKey(name: 'd') DateTime get debut;@JsonKey(name: 'f') DateTime get fin;@JsonKey(name: 'm') String get matiere;@JsonKey(name: 'c') String get code;@JsonKey(name: 's') String get salle;@JsonKey(name: 'p') String get campus;@JsonKey(name: 'e') String get enseignant;@JsonKey(name: 't') String get statut;
/// Create a copy of SharedSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSlotCopyWith<SharedSlot> get copyWith => _$SharedSlotCopyWithImpl<SharedSlot>(this as SharedSlot, _$identity);

  /// Serializes this SharedSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SharedSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSlot&&(identical(other.debut, _this.debut) || other.debut == _this.debut)&&(identical(other.fin, _this.fin) || other.fin == _this.fin)&&(identical(other.matiere, _this.matiere) || other.matiere == _this.matiere)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.salle, _this.salle) || other.salle == _this.salle)&&(identical(other.campus, _this.campus) || other.campus == _this.campus)&&(identical(other.enseignant, _this.enseignant) || other.enseignant == _this.enseignant)&&(identical(other.statut, _this.statut) || other.statut == _this.statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SharedSlot;
  return Object.hash(runtimeType,_this.debut,_this.fin,_this.matiere,_this.code,_this.salle,_this.campus,_this.enseignant,_this.statut);
}

@override
String toString() {
  final _this = this as SharedSlot;
  return 'SharedSlot(debut: ${_this.debut}, fin: ${_this.fin}, matiere: ${_this.matiere}, code: ${_this.code}, salle: ${_this.salle}, campus: ${_this.campus}, enseignant: ${_this.enseignant}, statut: ${_this.statut})';
}


}

/// @nodoc
abstract mixin class $SharedSlotCopyWith<$Res>  {
  factory $SharedSlotCopyWith(SharedSlot value, $Res Function(SharedSlot) _then) = _$SharedSlotCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'd') DateTime debut,@JsonKey(name: 'f') DateTime fin,@JsonKey(name: 'm') String matiere,@JsonKey(name: 'c') String code,@JsonKey(name: 's') String salle,@JsonKey(name: 'p') String campus,@JsonKey(name: 'e') String enseignant,@JsonKey(name: 't') String statut
});




}
/// @nodoc
class _$SharedSlotCopyWithImpl<$Res>
    implements $SharedSlotCopyWith<$Res> {
  _$SharedSlotCopyWithImpl(this._self, this._then);

  final SharedSlot _self;
  final $Res Function(SharedSlot) _then;

/// Create a copy of SharedSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? debut = null,Object? fin = null,Object? matiere = null,Object? code = null,Object? salle = null,Object? campus = null,Object? enseignant = null,Object? statut = null,}) {
  return _then(SharedSlot(
debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSlot].
extension SharedSlotPatterns on SharedSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSlot value)  $default,){
final _that = this;
switch (_that) {
case _SharedSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSlot value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'd')  DateTime debut, @JsonKey(name: 'f')  DateTime fin, @JsonKey(name: 'm')  String matiere, @JsonKey(name: 'c')  String code, @JsonKey(name: 's')  String salle, @JsonKey(name: 'p')  String campus, @JsonKey(name: 'e')  String enseignant, @JsonKey(name: 't')  String statut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSlot() when $default != null:
return $default(_that.debut,_that.fin,_that.matiere,_that.code,_that.salle,_that.campus,_that.enseignant,_that.statut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'd')  DateTime debut, @JsonKey(name: 'f')  DateTime fin, @JsonKey(name: 'm')  String matiere, @JsonKey(name: 'c')  String code, @JsonKey(name: 's')  String salle, @JsonKey(name: 'p')  String campus, @JsonKey(name: 'e')  String enseignant, @JsonKey(name: 't')  String statut)  $default,) {final _that = this;
switch (_that) {
case _SharedSlot():
return $default(_that.debut,_that.fin,_that.matiere,_that.code,_that.salle,_that.campus,_that.enseignant,_that.statut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'd')  DateTime debut, @JsonKey(name: 'f')  DateTime fin, @JsonKey(name: 'm')  String matiere, @JsonKey(name: 'c')  String code, @JsonKey(name: 's')  String salle, @JsonKey(name: 'p')  String campus, @JsonKey(name: 'e')  String enseignant, @JsonKey(name: 't')  String statut)?  $default,) {final _that = this;
switch (_that) {
case _SharedSlot() when $default != null:
return $default(_that.debut,_that.fin,_that.matiere,_that.code,_that.salle,_that.campus,_that.enseignant,_that.statut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedSlot extends SharedSlot {
  const _SharedSlot({@JsonKey(name: 'd') required this.debut, @JsonKey(name: 'f') required this.fin, @JsonKey(name: 'm') required this.matiere, @JsonKey(name: 'c') required this.code, @JsonKey(name: 's') required this.salle, @JsonKey(name: 'p') required this.campus, @JsonKey(name: 'e') required this.enseignant, @JsonKey(name: 't') this.statut = 'PLANIFIE'}): super._();
  factory _SharedSlot.fromJson(Map<String, dynamic> json) => _$SharedSlotFromJson(json);

@override@JsonKey(name: 'd') final  DateTime debut;
@override@JsonKey(name: 'f') final  DateTime fin;
@override@JsonKey(name: 'm') final  String matiere;
@override@JsonKey(name: 'c') final  String code;
@override@JsonKey(name: 's') final  String salle;
@override@JsonKey(name: 'p') final  String campus;
@override@JsonKey(name: 'e') final  String enseignant;
@override@JsonKey(name: 't') final  String statut;

/// Create a copy of SharedSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSlotCopyWith<_SharedSlot> get copyWith => __$SharedSlotCopyWithImpl<_SharedSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedSlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSlot&&(identical(other.debut, debut) || other.debut == debut)&&(identical(other.fin, fin) || other.fin == fin)&&(identical(other.matiere, matiere) || other.matiere == matiere)&&(identical(other.code, code) || other.code == code)&&(identical(other.salle, salle) || other.salle == salle)&&(identical(other.campus, campus) || other.campus == campus)&&(identical(other.enseignant, enseignant) || other.enseignant == enseignant)&&(identical(other.statut, statut) || other.statut == statut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,debut,fin,matiere,code,salle,campus,enseignant,statut);
}

@override
String toString() {
    return 'SharedSlot(debut: $debut, fin: $fin, matiere: $matiere, code: $code, salle: $salle, campus: $campus, enseignant: $enseignant, statut: $statut)';
}


}

/// @nodoc
abstract mixin class _$SharedSlotCopyWith<$Res> implements $SharedSlotCopyWith<$Res> {
  factory _$SharedSlotCopyWith(_SharedSlot value, $Res Function(_SharedSlot) _then) = __$SharedSlotCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'd') DateTime debut,@JsonKey(name: 'f') DateTime fin,@JsonKey(name: 'm') String matiere,@JsonKey(name: 'c') String code,@JsonKey(name: 's') String salle,@JsonKey(name: 'p') String campus,@JsonKey(name: 'e') String enseignant,@JsonKey(name: 't') String statut
});




}
/// @nodoc
class __$SharedSlotCopyWithImpl<$Res>
    implements _$SharedSlotCopyWith<$Res> {
  __$SharedSlotCopyWithImpl(this._self, this._then);

  final _SharedSlot _self;
  final $Res Function(_SharedSlot) _then;

/// Create a copy of SharedSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? debut = null,Object? fin = null,Object? matiere = null,Object? code = null,Object? salle = null,Object? campus = null,Object? enseignant = null,Object? statut = null,}) {
  return _then(_SharedSlot(
debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,matiere: null == matiere ? _self.matiere : matiere // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,salle: null == salle ? _self.salle : salle // ignore: cast_nullable_to_non_nullable
as String,campus: null == campus ? _self.campus : campus // ignore: cast_nullable_to_non_nullable
as String,enseignant: null == enseignant ? _self.enseignant : enseignant // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

NfcPayload _$NfcPayloadFromJson(
  Map<String, dynamic> json
) {
        switch (json['k']) {
                  case 'timetableShare':
          return NfcTimetableShare.fromJson(
            json
          );
                case 'room':
          return NfcRoomTag.fromJson(
            json
          );
                case 'attendance':
          return NfcAttendanceTag.fromJson(
            json
          );
                case 'studentCard':
          return NfcStudentCard.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'k',
  'NfcPayload',
  'Invalid union type "${json['k']}"!'
);
        }
      
}

/// @nodoc
mixin _$NfcPayload {



  /// Serializes this NfcPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcPayload);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NfcPayload()';
}


}

/// @nodoc
class $NfcPayloadCopyWith<$Res>  {
$NfcPayloadCopyWith(NfcPayload _, $Res Function(NfcPayload) __);
}


/// Adds pattern-matching-related methods to [NfcPayload].
extension NfcPayloadPatterns on NfcPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NfcTimetableShare value)?  timetableShare,TResult Function( NfcRoomTag value)?  room,TResult Function( NfcAttendanceTag value)?  attendance,TResult Function( NfcStudentCard value)?  studentCard,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NfcTimetableShare() when timetableShare != null:
return timetableShare(_that);case NfcRoomTag() when room != null:
return room(_that);case NfcAttendanceTag() when attendance != null:
return attendance(_that);case NfcStudentCard() when studentCard != null:
return studentCard(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NfcTimetableShare value)  timetableShare,required TResult Function( NfcRoomTag value)  room,required TResult Function( NfcAttendanceTag value)  attendance,required TResult Function( NfcStudentCard value)  studentCard,}){
final _that = this;
switch (_that) {
case NfcTimetableShare():
return timetableShare(_that);case NfcRoomTag():
return room(_that);case NfcAttendanceTag():
return attendance(_that);case NfcStudentCard():
return studentCard(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NfcTimetableShare value)?  timetableShare,TResult? Function( NfcRoomTag value)?  room,TResult? Function( NfcAttendanceTag value)?  attendance,TResult? Function( NfcStudentCard value)?  studentCard,}){
final _that = this;
switch (_that) {
case NfcTimetableShare() when timetableShare != null:
return timetableShare(_that);case NfcRoomTag() when room != null:
return room(_that);case NfcAttendanceTag() when attendance != null:
return attendance(_that);case NfcStudentCard() when studentCard != null:
return studentCard(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int v,  String owner,  String? group,  DateTime weekStart,  DateTime sharedAt,  List<SharedSlot> slots)?  timetableShare,TResult Function( String roomCode)?  room,TResult Function( String code)?  attendance,TResult Function( String uid,  String technology)?  studentCard,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NfcTimetableShare() when timetableShare != null:
return timetableShare(_that.v,_that.owner,_that.group,_that.weekStart,_that.sharedAt,_that.slots);case NfcRoomTag() when room != null:
return room(_that.roomCode);case NfcAttendanceTag() when attendance != null:
return attendance(_that.code);case NfcStudentCard() when studentCard != null:
return studentCard(_that.uid,_that.technology);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int v,  String owner,  String? group,  DateTime weekStart,  DateTime sharedAt,  List<SharedSlot> slots)  timetableShare,required TResult Function( String roomCode)  room,required TResult Function( String code)  attendance,required TResult Function( String uid,  String technology)  studentCard,}) {final _that = this;
switch (_that) {
case NfcTimetableShare():
return timetableShare(_that.v,_that.owner,_that.group,_that.weekStart,_that.sharedAt,_that.slots);case NfcRoomTag():
return room(_that.roomCode);case NfcAttendanceTag():
return attendance(_that.code);case NfcStudentCard():
return studentCard(_that.uid,_that.technology);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int v,  String owner,  String? group,  DateTime weekStart,  DateTime sharedAt,  List<SharedSlot> slots)?  timetableShare,TResult? Function( String roomCode)?  room,TResult? Function( String code)?  attendance,TResult? Function( String uid,  String technology)?  studentCard,}) {final _that = this;
switch (_that) {
case NfcTimetableShare() when timetableShare != null:
return timetableShare(_that.v,_that.owner,_that.group,_that.weekStart,_that.sharedAt,_that.slots);case NfcRoomTag() when room != null:
return room(_that.roomCode);case NfcAttendanceTag() when attendance != null:
return attendance(_that.code);case NfcStudentCard() when studentCard != null:
return studentCard(_that.uid,_that.technology);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NfcTimetableShare implements NfcPayload {
  const NfcTimetableShare({this.v = 1, required this.owner, this.group, required this.weekStart, required this.sharedAt,  List<SharedSlot> slots = const [],  String? $type}): _slots = slots,$type = $type ?? 'timetableShare';
  factory NfcTimetableShare.fromJson(Map<String, dynamic> json) => _$NfcTimetableShareFromJson(json);

@JsonKey() final  int v;
 final  String owner;
 final  String? group;
 final  DateTime weekStart;
 final  DateTime sharedAt;
 final  List<SharedSlot> _slots;
@JsonKey() List<SharedSlot> get slots {
  if (_slots is EqualUnmodifiableListView) return _slots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slots);
}


@JsonKey(name: 'k')
final String $type;


/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcTimetableShareCopyWith<NfcTimetableShare> get copyWith => _$NfcTimetableShareCopyWithImpl<NfcTimetableShare>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NfcTimetableShareToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcTimetableShare&&(identical(other.v, v) || other.v == v)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.group, group) || other.group == group)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.sharedAt, sharedAt) || other.sharedAt == sharedAt)&&const DeepCollectionEquality().equals(other.slots, _slots));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,v,owner,group,weekStart,sharedAt,const DeepCollectionEquality().hash(_slots));
}

@override
String toString() {
    return 'NfcPayload.timetableShare(v: $v, owner: $owner, group: $group, weekStart: $weekStart, sharedAt: $sharedAt, slots: $slots)';
}


}

/// @nodoc
abstract mixin class $NfcTimetableShareCopyWith<$Res> implements $NfcPayloadCopyWith<$Res> {
  factory $NfcTimetableShareCopyWith(NfcTimetableShare value, $Res Function(NfcTimetableShare) _then) = _$NfcTimetableShareCopyWithImpl;
@useResult
$Res call({
 int v, String owner, String? group, DateTime weekStart, DateTime sharedAt, List<SharedSlot> slots
});




}
/// @nodoc
class _$NfcTimetableShareCopyWithImpl<$Res>
    implements $NfcTimetableShareCopyWith<$Res> {
  _$NfcTimetableShareCopyWithImpl(this._self, this._then);

  final NfcTimetableShare _self;
  final $Res Function(NfcTimetableShare) _then;

/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? v = null,Object? owner = null,Object? group = freezed,Object? weekStart = null,Object? sharedAt = null,Object? slots = null,}) {
  return _then(NfcTimetableShare(
v: null == v ? _self.v : v // ignore: cast_nullable_to_non_nullable
as int,owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,sharedAt: null == sharedAt ? _self.sharedAt : sharedAt // ignore: cast_nullable_to_non_nullable
as DateTime,slots: null == slots ? _self._slots : slots // ignore: cast_nullable_to_non_nullable
as List<SharedSlot>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NfcRoomTag implements NfcPayload {
  const NfcRoomTag({required this.roomCode,  String? $type}): $type = $type ?? 'room';
  factory NfcRoomTag.fromJson(Map<String, dynamic> json) => _$NfcRoomTagFromJson(json);

 final  String roomCode;

@JsonKey(name: 'k')
final String $type;


/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcRoomTagCopyWith<NfcRoomTag> get copyWith => _$NfcRoomTagCopyWithImpl<NfcRoomTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NfcRoomTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcRoomTag&&(identical(other.roomCode, roomCode) || other.roomCode == roomCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,roomCode);
}

@override
String toString() {
    return 'NfcPayload.room(roomCode: $roomCode)';
}


}

/// @nodoc
abstract mixin class $NfcRoomTagCopyWith<$Res> implements $NfcPayloadCopyWith<$Res> {
  factory $NfcRoomTagCopyWith(NfcRoomTag value, $Res Function(NfcRoomTag) _then) = _$NfcRoomTagCopyWithImpl;
@useResult
$Res call({
 String roomCode
});




}
/// @nodoc
class _$NfcRoomTagCopyWithImpl<$Res>
    implements $NfcRoomTagCopyWith<$Res> {
  _$NfcRoomTagCopyWithImpl(this._self, this._then);

  final NfcRoomTag _self;
  final $Res Function(NfcRoomTag) _then;

/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomCode = null,}) {
  return _then(NfcRoomTag(
roomCode: null == roomCode ? _self.roomCode : roomCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NfcAttendanceTag implements NfcPayload {
  const NfcAttendanceTag({required this.code,  String? $type}): $type = $type ?? 'attendance';
  factory NfcAttendanceTag.fromJson(Map<String, dynamic> json) => _$NfcAttendanceTagFromJson(json);

 final  String code;

@JsonKey(name: 'k')
final String $type;


/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcAttendanceTagCopyWith<NfcAttendanceTag> get copyWith => _$NfcAttendanceTagCopyWithImpl<NfcAttendanceTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NfcAttendanceTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcAttendanceTag&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'NfcPayload.attendance(code: $code)';
}


}

/// @nodoc
abstract mixin class $NfcAttendanceTagCopyWith<$Res> implements $NfcPayloadCopyWith<$Res> {
  factory $NfcAttendanceTagCopyWith(NfcAttendanceTag value, $Res Function(NfcAttendanceTag) _then) = _$NfcAttendanceTagCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$NfcAttendanceTagCopyWithImpl<$Res>
    implements $NfcAttendanceTagCopyWith<$Res> {
  _$NfcAttendanceTagCopyWithImpl(this._self, this._then);

  final NfcAttendanceTag _self;
  final $Res Function(NfcAttendanceTag) _then;

/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(NfcAttendanceTag(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NfcStudentCard implements NfcPayload {
  const NfcStudentCard({required this.uid, required this.technology,  String? $type}): $type = $type ?? 'studentCard';
  factory NfcStudentCard.fromJson(Map<String, dynamic> json) => _$NfcStudentCardFromJson(json);

 final  String uid;
 final  String technology;

@JsonKey(name: 'k')
final String $type;


/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcStudentCardCopyWith<NfcStudentCard> get copyWith => _$NfcStudentCardCopyWithImpl<NfcStudentCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NfcStudentCardToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcStudentCard&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.technology, technology) || other.technology == technology));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uid,technology);
}

@override
String toString() {
    return 'NfcPayload.studentCard(uid: $uid, technology: $technology)';
}


}

/// @nodoc
abstract mixin class $NfcStudentCardCopyWith<$Res> implements $NfcPayloadCopyWith<$Res> {
  factory $NfcStudentCardCopyWith(NfcStudentCard value, $Res Function(NfcStudentCard) _then) = _$NfcStudentCardCopyWithImpl;
@useResult
$Res call({
 String uid, String technology
});




}
/// @nodoc
class _$NfcStudentCardCopyWithImpl<$Res>
    implements $NfcStudentCardCopyWith<$Res> {
  _$NfcStudentCardCopyWithImpl(this._self, this._then);

  final NfcStudentCard _self;
  final $Res Function(NfcStudentCard) _then;

/// Create a copy of NfcPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? technology = null,}) {
  return _then(NfcStudentCard(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,technology: null == technology ? _self.technology : technology // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
