// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grades_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GradeEntry {

 String get id; String get evaluation; String get type; double get valeur; double get bareme; double get coefficient; DateTime get date;
/// Create a copy of GradeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GradeEntryCopyWith<GradeEntry> get copyWith => _$GradeEntryCopyWithImpl<GradeEntry>(this as GradeEntry, _$identity);

  /// Serializes this GradeEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GradeEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GradeEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.evaluation, _this.evaluation) || other.evaluation == _this.evaluation)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.valeur, _this.valeur) || other.valeur == _this.valeur)&&(identical(other.bareme, _this.bareme) || other.bareme == _this.bareme)&&(identical(other.coefficient, _this.coefficient) || other.coefficient == _this.coefficient)&&(identical(other.date, _this.date) || other.date == _this.date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GradeEntry;
  return Object.hash(runtimeType,_this.id,_this.evaluation,_this.type,_this.valeur,_this.bareme,_this.coefficient,_this.date);
}

@override
String toString() {
  final _this = this as GradeEntry;
  return 'GradeEntry(id: ${_this.id}, evaluation: ${_this.evaluation}, type: ${_this.type}, valeur: ${_this.valeur}, bareme: ${_this.bareme}, coefficient: ${_this.coefficient}, date: ${_this.date})';
}


}

/// @nodoc
abstract mixin class $GradeEntryCopyWith<$Res>  {
  factory $GradeEntryCopyWith(GradeEntry value, $Res Function(GradeEntry) _then) = _$GradeEntryCopyWithImpl;
@useResult
$Res call({
 String id, String evaluation, String type, double valeur, double bareme, double coefficient, DateTime date
});




}
/// @nodoc
class _$GradeEntryCopyWithImpl<$Res>
    implements $GradeEntryCopyWith<$Res> {
  _$GradeEntryCopyWithImpl(this._self, this._then);

  final GradeEntry _self;
  final $Res Function(GradeEntry) _then;

/// Create a copy of GradeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? evaluation = null,Object? type = null,Object? valeur = null,Object? bareme = null,Object? coefficient = null,Object? date = null,}) {
  return _then(GradeEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,bareme: null == bareme ? _self.bareme : bareme // ignore: cast_nullable_to_non_nullable
as double,coefficient: null == coefficient ? _self.coefficient : coefficient // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GradeEntry].
extension GradeEntryPatterns on GradeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GradeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GradeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GradeEntry value)  $default,){
final _that = this;
switch (_that) {
case _GradeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GradeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _GradeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String evaluation,  String type,  double valeur,  double bareme,  double coefficient,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GradeEntry() when $default != null:
return $default(_that.id,_that.evaluation,_that.type,_that.valeur,_that.bareme,_that.coefficient,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String evaluation,  String type,  double valeur,  double bareme,  double coefficient,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _GradeEntry():
return $default(_that.id,_that.evaluation,_that.type,_that.valeur,_that.bareme,_that.coefficient,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String evaluation,  String type,  double valeur,  double bareme,  double coefficient,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _GradeEntry() when $default != null:
return $default(_that.id,_that.evaluation,_that.type,_that.valeur,_that.bareme,_that.coefficient,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GradeEntry implements GradeEntry {
  const _GradeEntry({required this.id, required this.evaluation, required this.type, required this.valeur, this.bareme = 20, this.coefficient = 1, required this.date});
  factory _GradeEntry.fromJson(Map<String, dynamic> json) => _$GradeEntryFromJson(json);

@override final  String id;
@override final  String evaluation;
@override final  String type;
@override final  double valeur;
@override@JsonKey() final  double bareme;
@override@JsonKey() final  double coefficient;
@override final  DateTime date;

/// Create a copy of GradeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GradeEntryCopyWith<_GradeEntry> get copyWith => __$GradeEntryCopyWithImpl<_GradeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GradeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GradeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.evaluation, evaluation) || other.evaluation == evaluation)&&(identical(other.type, type) || other.type == type)&&(identical(other.valeur, valeur) || other.valeur == valeur)&&(identical(other.bareme, bareme) || other.bareme == bareme)&&(identical(other.coefficient, coefficient) || other.coefficient == coefficient)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,evaluation,type,valeur,bareme,coefficient,date);
}

@override
String toString() {
    return 'GradeEntry(id: $id, evaluation: $evaluation, type: $type, valeur: $valeur, bareme: $bareme, coefficient: $coefficient, date: $date)';
}


}

/// @nodoc
abstract mixin class _$GradeEntryCopyWith<$Res> implements $GradeEntryCopyWith<$Res> {
  factory _$GradeEntryCopyWith(_GradeEntry value, $Res Function(_GradeEntry) _then) = __$GradeEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String evaluation, String type, double valeur, double bareme, double coefficient, DateTime date
});




}
/// @nodoc
class __$GradeEntryCopyWithImpl<$Res>
    implements _$GradeEntryCopyWith<$Res> {
  __$GradeEntryCopyWithImpl(this._self, this._then);

  final _GradeEntry _self;
  final $Res Function(_GradeEntry) _then;

/// Create a copy of GradeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? evaluation = null,Object? type = null,Object? valeur = null,Object? bareme = null,Object? coefficient = null,Object? date = null,}) {
  return _then(_GradeEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,evaluation: null == evaluation ? _self.evaluation : evaluation // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,valeur: null == valeur ? _self.valeur : valeur // ignore: cast_nullable_to_non_nullable
as double,bareme: null == bareme ? _self.bareme : bareme // ignore: cast_nullable_to_non_nullable
as double,coefficient: null == coefficient ? _self.coefficient : coefficient // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CourseResult {

 String get courseId; String get code; String get nom; double get coefficient; int get credits; double get moyenne; int get creditsAcquis; int get nombreNotes; double? get moyenneClasse; List<GradeEntry> get notes;
/// Create a copy of CourseResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseResultCopyWith<CourseResult> get copyWith => _$CourseResultCopyWithImpl<CourseResult>(this as CourseResult, _$identity);

  /// Serializes this CourseResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CourseResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseResult&&(identical(other.courseId, _this.courseId) || other.courseId == _this.courseId)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.coefficient, _this.coefficient) || other.coefficient == _this.coefficient)&&(identical(other.credits, _this.credits) || other.credits == _this.credits)&&(identical(other.moyenne, _this.moyenne) || other.moyenne == _this.moyenne)&&(identical(other.creditsAcquis, _this.creditsAcquis) || other.creditsAcquis == _this.creditsAcquis)&&(identical(other.nombreNotes, _this.nombreNotes) || other.nombreNotes == _this.nombreNotes)&&(identical(other.moyenneClasse, _this.moyenneClasse) || other.moyenneClasse == _this.moyenneClasse)&&const DeepCollectionEquality().equals(other.notes, _this.notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CourseResult;
  return Object.hash(runtimeType,_this.courseId,_this.code,_this.nom,_this.coefficient,_this.credits,_this.moyenne,_this.creditsAcquis,_this.nombreNotes,_this.moyenneClasse,const DeepCollectionEquality().hash(_this.notes));
}

@override
String toString() {
  final _this = this as CourseResult;
  return 'CourseResult(courseId: ${_this.courseId}, code: ${_this.code}, nom: ${_this.nom}, coefficient: ${_this.coefficient}, credits: ${_this.credits}, moyenne: ${_this.moyenne}, creditsAcquis: ${_this.creditsAcquis}, nombreNotes: ${_this.nombreNotes}, moyenneClasse: ${_this.moyenneClasse}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $CourseResultCopyWith<$Res>  {
  factory $CourseResultCopyWith(CourseResult value, $Res Function(CourseResult) _then) = _$CourseResultCopyWithImpl;
@useResult
$Res call({
 String courseId, String code, String nom, double coefficient, int credits, double moyenne, int creditsAcquis, int nombreNotes, double? moyenneClasse, List<GradeEntry> notes
});




}
/// @nodoc
class _$CourseResultCopyWithImpl<$Res>
    implements $CourseResultCopyWith<$Res> {
  _$CourseResultCopyWithImpl(this._self, this._then);

  final CourseResult _self;
  final $Res Function(CourseResult) _then;

/// Create a copy of CourseResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? courseId = null,Object? code = null,Object? nom = null,Object? coefficient = null,Object? credits = null,Object? moyenne = null,Object? creditsAcquis = null,Object? nombreNotes = null,Object? moyenneClasse = freezed,Object? notes = null,}) {
  return _then(CourseResult(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,coefficient: null == coefficient ? _self.coefficient : coefficient // ignore: cast_nullable_to_non_nullable
as double,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,moyenne: null == moyenne ? _self.moyenne : moyenne // ignore: cast_nullable_to_non_nullable
as double,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,nombreNotes: null == nombreNotes ? _self.nombreNotes : nombreNotes // ignore: cast_nullable_to_non_nullable
as int,moyenneClasse: freezed == moyenneClasse ? _self.moyenneClasse : moyenneClasse // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as List<GradeEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseResult].
extension CourseResultPatterns on CourseResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseResult value)  $default,){
final _that = this;
switch (_that) {
case _CourseResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseResult value)?  $default,){
final _that = this;
switch (_that) {
case _CourseResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String courseId,  String code,  String nom,  double coefficient,  int credits,  double moyenne,  int creditsAcquis,  int nombreNotes,  double? moyenneClasse,  List<GradeEntry> notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseResult() when $default != null:
return $default(_that.courseId,_that.code,_that.nom,_that.coefficient,_that.credits,_that.moyenne,_that.creditsAcquis,_that.nombreNotes,_that.moyenneClasse,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String courseId,  String code,  String nom,  double coefficient,  int credits,  double moyenne,  int creditsAcquis,  int nombreNotes,  double? moyenneClasse,  List<GradeEntry> notes)  $default,) {final _that = this;
switch (_that) {
case _CourseResult():
return $default(_that.courseId,_that.code,_that.nom,_that.coefficient,_that.credits,_that.moyenne,_that.creditsAcquis,_that.nombreNotes,_that.moyenneClasse,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String courseId,  String code,  String nom,  double coefficient,  int credits,  double moyenne,  int creditsAcquis,  int nombreNotes,  double? moyenneClasse,  List<GradeEntry> notes)?  $default,) {final _that = this;
switch (_that) {
case _CourseResult() when $default != null:
return $default(_that.courseId,_that.code,_that.nom,_that.coefficient,_that.credits,_that.moyenne,_that.creditsAcquis,_that.nombreNotes,_that.moyenneClasse,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseResult implements CourseResult {
  const _CourseResult({required this.courseId, required this.code, required this.nom, this.coefficient = 1, this.credits = 0, required this.moyenne, this.creditsAcquis = 0, this.nombreNotes = 0, this.moyenneClasse,  List<GradeEntry> notes = const []}): _notes = notes;
  factory _CourseResult.fromJson(Map<String, dynamic> json) => _$CourseResultFromJson(json);

@override final  String courseId;
@override final  String code;
@override final  String nom;
@override@JsonKey() final  double coefficient;
@override@JsonKey() final  int credits;
@override final  double moyenne;
@override@JsonKey() final  int creditsAcquis;
@override@JsonKey() final  int nombreNotes;
@override final  double? moyenneClasse;
 final  List<GradeEntry> _notes;
@override@JsonKey() List<GradeEntry> get notes {
  if (_notes is EqualUnmodifiableListView) return _notes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notes);
}


/// Create a copy of CourseResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseResultCopyWith<_CourseResult> get copyWith => __$CourseResultCopyWithImpl<_CourseResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseResult&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.code, code) || other.code == code)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.coefficient, coefficient) || other.coefficient == coefficient)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.moyenne, moyenne) || other.moyenne == moyenne)&&(identical(other.creditsAcquis, creditsAcquis) || other.creditsAcquis == creditsAcquis)&&(identical(other.nombreNotes, nombreNotes) || other.nombreNotes == nombreNotes)&&(identical(other.moyenneClasse, moyenneClasse) || other.moyenneClasse == moyenneClasse)&&const DeepCollectionEquality().equals(other.notes, _notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,courseId,code,nom,coefficient,credits,moyenne,creditsAcquis,nombreNotes,moyenneClasse,const DeepCollectionEquality().hash(_notes));
}

@override
String toString() {
    return 'CourseResult(courseId: $courseId, code: $code, nom: $nom, coefficient: $coefficient, credits: $credits, moyenne: $moyenne, creditsAcquis: $creditsAcquis, nombreNotes: $nombreNotes, moyenneClasse: $moyenneClasse, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CourseResultCopyWith<$Res> implements $CourseResultCopyWith<$Res> {
  factory _$CourseResultCopyWith(_CourseResult value, $Res Function(_CourseResult) _then) = __$CourseResultCopyWithImpl;
@override @useResult
$Res call({
 String courseId, String code, String nom, double coefficient, int credits, double moyenne, int creditsAcquis, int nombreNotes, double? moyenneClasse, List<GradeEntry> notes
});




}
/// @nodoc
class __$CourseResultCopyWithImpl<$Res>
    implements _$CourseResultCopyWith<$Res> {
  __$CourseResultCopyWithImpl(this._self, this._then);

  final _CourseResult _self;
  final $Res Function(_CourseResult) _then;

/// Create a copy of CourseResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? courseId = null,Object? code = null,Object? nom = null,Object? coefficient = null,Object? credits = null,Object? moyenne = null,Object? creditsAcquis = null,Object? nombreNotes = null,Object? moyenneClasse = freezed,Object? notes = null,}) {
  return _then(_CourseResult(
courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,coefficient: null == coefficient ? _self.coefficient : coefficient // ignore: cast_nullable_to_non_nullable
as double,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,moyenne: null == moyenne ? _self.moyenne : moyenne // ignore: cast_nullable_to_non_nullable
as double,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,nombreNotes: null == nombreNotes ? _self.nombreNotes : nombreNotes // ignore: cast_nullable_to_non_nullable
as int,moyenneClasse: freezed == moyenneClasse ? _self.moyenneClasse : moyenneClasse // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self._notes : notes // ignore: cast_nullable_to_non_nullable
as List<GradeEntry>,
  ));
}


}


/// @nodoc
mixin _$SemesterResults {

 SemesterRef get semestre; double? get moyenneGenerale; double? get moyenneClasse; int? get rang; int? get effectif; int get creditsAcquis; int get creditsTotal; String? get mention; String? get decision; List<CourseResult> get matieres;
/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterResultsCopyWith<SemesterResults> get copyWith => _$SemesterResultsCopyWithImpl<SemesterResults>(this as SemesterResults, _$identity);

  /// Serializes this SemesterResults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SemesterResults;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterResults&&(identical(other.semestre, _this.semestre) || other.semestre == _this.semestre)&&(identical(other.moyenneGenerale, _this.moyenneGenerale) || other.moyenneGenerale == _this.moyenneGenerale)&&(identical(other.moyenneClasse, _this.moyenneClasse) || other.moyenneClasse == _this.moyenneClasse)&&(identical(other.rang, _this.rang) || other.rang == _this.rang)&&(identical(other.effectif, _this.effectif) || other.effectif == _this.effectif)&&(identical(other.creditsAcquis, _this.creditsAcquis) || other.creditsAcquis == _this.creditsAcquis)&&(identical(other.creditsTotal, _this.creditsTotal) || other.creditsTotal == _this.creditsTotal)&&(identical(other.mention, _this.mention) || other.mention == _this.mention)&&(identical(other.decision, _this.decision) || other.decision == _this.decision)&&const DeepCollectionEquality().equals(other.matieres, _this.matieres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SemesterResults;
  return Object.hash(runtimeType,_this.semestre,_this.moyenneGenerale,_this.moyenneClasse,_this.rang,_this.effectif,_this.creditsAcquis,_this.creditsTotal,_this.mention,_this.decision,const DeepCollectionEquality().hash(_this.matieres));
}

@override
String toString() {
  final _this = this as SemesterResults;
  return 'SemesterResults(semestre: ${_this.semestre}, moyenneGenerale: ${_this.moyenneGenerale}, moyenneClasse: ${_this.moyenneClasse}, rang: ${_this.rang}, effectif: ${_this.effectif}, creditsAcquis: ${_this.creditsAcquis}, creditsTotal: ${_this.creditsTotal}, mention: ${_this.mention}, decision: ${_this.decision}, matieres: ${_this.matieres})';
}


}

/// @nodoc
abstract mixin class $SemesterResultsCopyWith<$Res>  {
  factory $SemesterResultsCopyWith(SemesterResults value, $Res Function(SemesterResults) _then) = _$SemesterResultsCopyWithImpl;
@useResult
$Res call({
 SemesterRef semestre, double? moyenneGenerale, double? moyenneClasse, int? rang, int? effectif, int creditsAcquis, int creditsTotal, String? mention, String? decision, List<CourseResult> matieres
});


$SemesterRefCopyWith<$Res> get semestre;

}
/// @nodoc
class _$SemesterResultsCopyWithImpl<$Res>
    implements $SemesterResultsCopyWith<$Res> {
  _$SemesterResultsCopyWithImpl(this._self, this._then);

  final SemesterResults _self;
  final $Res Function(SemesterResults) _then;

/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semestre = null,Object? moyenneGenerale = freezed,Object? moyenneClasse = freezed,Object? rang = freezed,Object? effectif = freezed,Object? creditsAcquis = null,Object? creditsTotal = null,Object? mention = freezed,Object? decision = freezed,Object? matieres = null,}) {
  return _then(SemesterResults(
semestre: null == semestre ? _self.semestre : semestre // ignore: cast_nullable_to_non_nullable
as SemesterRef,moyenneGenerale: freezed == moyenneGenerale ? _self.moyenneGenerale : moyenneGenerale // ignore: cast_nullable_to_non_nullable
as double?,moyenneClasse: freezed == moyenneClasse ? _self.moyenneClasse : moyenneClasse // ignore: cast_nullable_to_non_nullable
as double?,rang: freezed == rang ? _self.rang : rang // ignore: cast_nullable_to_non_nullable
as int?,effectif: freezed == effectif ? _self.effectif : effectif // ignore: cast_nullable_to_non_nullable
as int?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,creditsTotal: null == creditsTotal ? _self.creditsTotal : creditsTotal // ignore: cast_nullable_to_non_nullable
as int,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,matieres: null == matieres ? _self.matieres : matieres // ignore: cast_nullable_to_non_nullable
as List<CourseResult>,
  ));
}
/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterRefCopyWith<$Res> get semestre {
  
  return $SemesterRefCopyWith<$Res>(_self.semestre, (value) {
    return _then(_self.copyWith(semestre: value));
  });
}
}


/// Adds pattern-matching-related methods to [SemesterResults].
extension SemesterResultsPatterns on SemesterResults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterResults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterResults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterResults value)  $default,){
final _that = this;
switch (_that) {
case _SemesterResults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterResults value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterResults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SemesterRef semestre,  double? moyenneGenerale,  double? moyenneClasse,  int? rang,  int? effectif,  int creditsAcquis,  int creditsTotal,  String? mention,  String? decision,  List<CourseResult> matieres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SemesterResults() when $default != null:
return $default(_that.semestre,_that.moyenneGenerale,_that.moyenneClasse,_that.rang,_that.effectif,_that.creditsAcquis,_that.creditsTotal,_that.mention,_that.decision,_that.matieres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SemesterRef semestre,  double? moyenneGenerale,  double? moyenneClasse,  int? rang,  int? effectif,  int creditsAcquis,  int creditsTotal,  String? mention,  String? decision,  List<CourseResult> matieres)  $default,) {final _that = this;
switch (_that) {
case _SemesterResults():
return $default(_that.semestre,_that.moyenneGenerale,_that.moyenneClasse,_that.rang,_that.effectif,_that.creditsAcquis,_that.creditsTotal,_that.mention,_that.decision,_that.matieres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SemesterRef semestre,  double? moyenneGenerale,  double? moyenneClasse,  int? rang,  int? effectif,  int creditsAcquis,  int creditsTotal,  String? mention,  String? decision,  List<CourseResult> matieres)?  $default,) {final _that = this;
switch (_that) {
case _SemesterResults() when $default != null:
return $default(_that.semestre,_that.moyenneGenerale,_that.moyenneClasse,_that.rang,_that.effectif,_that.creditsAcquis,_that.creditsTotal,_that.mention,_that.decision,_that.matieres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SemesterResults implements SemesterResults {
  const _SemesterResults({required this.semestre, this.moyenneGenerale, this.moyenneClasse, this.rang, this.effectif, this.creditsAcquis = 0, this.creditsTotal = 0, this.mention, this.decision,  List<CourseResult> matieres = const []}): _matieres = matieres;
  factory _SemesterResults.fromJson(Map<String, dynamic> json) => _$SemesterResultsFromJson(json);

@override final  SemesterRef semestre;
@override final  double? moyenneGenerale;
@override final  double? moyenneClasse;
@override final  int? rang;
@override final  int? effectif;
@override@JsonKey() final  int creditsAcquis;
@override@JsonKey() final  int creditsTotal;
@override final  String? mention;
@override final  String? decision;
 final  List<CourseResult> _matieres;
@override@JsonKey() List<CourseResult> get matieres {
  if (_matieres is EqualUnmodifiableListView) return _matieres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matieres);
}


/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterResultsCopyWith<_SemesterResults> get copyWith => __$SemesterResultsCopyWithImpl<_SemesterResults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SemesterResultsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterResults&&(identical(other.semestre, semestre) || other.semestre == semestre)&&(identical(other.moyenneGenerale, moyenneGenerale) || other.moyenneGenerale == moyenneGenerale)&&(identical(other.moyenneClasse, moyenneClasse) || other.moyenneClasse == moyenneClasse)&&(identical(other.rang, rang) || other.rang == rang)&&(identical(other.effectif, effectif) || other.effectif == effectif)&&(identical(other.creditsAcquis, creditsAcquis) || other.creditsAcquis == creditsAcquis)&&(identical(other.creditsTotal, creditsTotal) || other.creditsTotal == creditsTotal)&&(identical(other.mention, mention) || other.mention == mention)&&(identical(other.decision, decision) || other.decision == decision)&&const DeepCollectionEquality().equals(other.matieres, _matieres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,semestre,moyenneGenerale,moyenneClasse,rang,effectif,creditsAcquis,creditsTotal,mention,decision,const DeepCollectionEquality().hash(_matieres));
}

@override
String toString() {
    return 'SemesterResults(semestre: $semestre, moyenneGenerale: $moyenneGenerale, moyenneClasse: $moyenneClasse, rang: $rang, effectif: $effectif, creditsAcquis: $creditsAcquis, creditsTotal: $creditsTotal, mention: $mention, decision: $decision, matieres: $matieres)';
}


}

/// @nodoc
abstract mixin class _$SemesterResultsCopyWith<$Res> implements $SemesterResultsCopyWith<$Res> {
  factory _$SemesterResultsCopyWith(_SemesterResults value, $Res Function(_SemesterResults) _then) = __$SemesterResultsCopyWithImpl;
@override @useResult
$Res call({
 SemesterRef semestre, double? moyenneGenerale, double? moyenneClasse, int? rang, int? effectif, int creditsAcquis, int creditsTotal, String? mention, String? decision, List<CourseResult> matieres
});


@override $SemesterRefCopyWith<$Res> get semestre;

}
/// @nodoc
class __$SemesterResultsCopyWithImpl<$Res>
    implements _$SemesterResultsCopyWith<$Res> {
  __$SemesterResultsCopyWithImpl(this._self, this._then);

  final _SemesterResults _self;
  final $Res Function(_SemesterResults) _then;

/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semestre = null,Object? moyenneGenerale = freezed,Object? moyenneClasse = freezed,Object? rang = freezed,Object? effectif = freezed,Object? creditsAcquis = null,Object? creditsTotal = null,Object? mention = freezed,Object? decision = freezed,Object? matieres = null,}) {
  return _then(_SemesterResults(
semestre: null == semestre ? _self.semestre : semestre // ignore: cast_nullable_to_non_nullable
as SemesterRef,moyenneGenerale: freezed == moyenneGenerale ? _self.moyenneGenerale : moyenneGenerale // ignore: cast_nullable_to_non_nullable
as double?,moyenneClasse: freezed == moyenneClasse ? _self.moyenneClasse : moyenneClasse // ignore: cast_nullable_to_non_nullable
as double?,rang: freezed == rang ? _self.rang : rang // ignore: cast_nullable_to_non_nullable
as int?,effectif: freezed == effectif ? _self.effectif : effectif // ignore: cast_nullable_to_non_nullable
as int?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,creditsTotal: null == creditsTotal ? _self.creditsTotal : creditsTotal // ignore: cast_nullable_to_non_nullable
as int,mention: freezed == mention ? _self.mention : mention // ignore: cast_nullable_to_non_nullable
as String?,decision: freezed == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String?,matieres: null == matieres ? _self._matieres : matieres // ignore: cast_nullable_to_non_nullable
as List<CourseResult>,
  ));
}

/// Create a copy of SemesterResults
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SemesterRefCopyWith<$Res> get semestre {
  
  return $SemesterRefCopyWith<$Res>(_self.semestre, (value) {
    return _then(_self.copyWith(semestre: value));
  });
}
}


/// @nodoc
mixin _$SemesterAverage {

 String get semesterId; String get code; String get libelle; String get annee; double? get moyenne; int get creditsAcquis; bool get estActif;
/// Create a copy of SemesterAverage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SemesterAverageCopyWith<SemesterAverage> get copyWith => _$SemesterAverageCopyWithImpl<SemesterAverage>(this as SemesterAverage, _$identity);

  /// Serializes this SemesterAverage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SemesterAverage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SemesterAverage&&(identical(other.semesterId, _this.semesterId) || other.semesterId == _this.semesterId)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.libelle, _this.libelle) || other.libelle == _this.libelle)&&(identical(other.annee, _this.annee) || other.annee == _this.annee)&&(identical(other.moyenne, _this.moyenne) || other.moyenne == _this.moyenne)&&(identical(other.creditsAcquis, _this.creditsAcquis) || other.creditsAcquis == _this.creditsAcquis)&&(identical(other.estActif, _this.estActif) || other.estActif == _this.estActif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SemesterAverage;
  return Object.hash(runtimeType,_this.semesterId,_this.code,_this.libelle,_this.annee,_this.moyenne,_this.creditsAcquis,_this.estActif);
}

@override
String toString() {
  final _this = this as SemesterAverage;
  return 'SemesterAverage(semesterId: ${_this.semesterId}, code: ${_this.code}, libelle: ${_this.libelle}, annee: ${_this.annee}, moyenne: ${_this.moyenne}, creditsAcquis: ${_this.creditsAcquis}, estActif: ${_this.estActif})';
}


}

/// @nodoc
abstract mixin class $SemesterAverageCopyWith<$Res>  {
  factory $SemesterAverageCopyWith(SemesterAverage value, $Res Function(SemesterAverage) _then) = _$SemesterAverageCopyWithImpl;
@useResult
$Res call({
 String semesterId, String code, String libelle, String annee, double? moyenne, int creditsAcquis, bool estActif
});




}
/// @nodoc
class _$SemesterAverageCopyWithImpl<$Res>
    implements $SemesterAverageCopyWith<$Res> {
  _$SemesterAverageCopyWithImpl(this._self, this._then);

  final SemesterAverage _self;
  final $Res Function(SemesterAverage) _then;

/// Create a copy of SemesterAverage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? semesterId = null,Object? code = null,Object? libelle = null,Object? annee = null,Object? moyenne = freezed,Object? creditsAcquis = null,Object? estActif = null,}) {
  return _then(SemesterAverage(
semesterId: null == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,annee: null == annee ? _self.annee : annee // ignore: cast_nullable_to_non_nullable
as String,moyenne: freezed == moyenne ? _self.moyenne : moyenne // ignore: cast_nullable_to_non_nullable
as double?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,estActif: null == estActif ? _self.estActif : estActif // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SemesterAverage].
extension SemesterAveragePatterns on SemesterAverage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SemesterAverage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SemesterAverage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SemesterAverage value)  $default,){
final _that = this;
switch (_that) {
case _SemesterAverage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SemesterAverage value)?  $default,){
final _that = this;
switch (_that) {
case _SemesterAverage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String semesterId,  String code,  String libelle,  String annee,  double? moyenne,  int creditsAcquis,  bool estActif)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SemesterAverage() when $default != null:
return $default(_that.semesterId,_that.code,_that.libelle,_that.annee,_that.moyenne,_that.creditsAcquis,_that.estActif);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String semesterId,  String code,  String libelle,  String annee,  double? moyenne,  int creditsAcquis,  bool estActif)  $default,) {final _that = this;
switch (_that) {
case _SemesterAverage():
return $default(_that.semesterId,_that.code,_that.libelle,_that.annee,_that.moyenne,_that.creditsAcquis,_that.estActif);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String semesterId,  String code,  String libelle,  String annee,  double? moyenne,  int creditsAcquis,  bool estActif)?  $default,) {final _that = this;
switch (_that) {
case _SemesterAverage() when $default != null:
return $default(_that.semesterId,_that.code,_that.libelle,_that.annee,_that.moyenne,_that.creditsAcquis,_that.estActif);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SemesterAverage implements SemesterAverage {
  const _SemesterAverage({required this.semesterId, required this.code, required this.libelle, required this.annee, this.moyenne, this.creditsAcquis = 0, this.estActif = false});
  factory _SemesterAverage.fromJson(Map<String, dynamic> json) => _$SemesterAverageFromJson(json);

@override final  String semesterId;
@override final  String code;
@override final  String libelle;
@override final  String annee;
@override final  double? moyenne;
@override@JsonKey() final  int creditsAcquis;
@override@JsonKey() final  bool estActif;

/// Create a copy of SemesterAverage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SemesterAverageCopyWith<_SemesterAverage> get copyWith => __$SemesterAverageCopyWithImpl<_SemesterAverage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SemesterAverageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SemesterAverage&&(identical(other.semesterId, semesterId) || other.semesterId == semesterId)&&(identical(other.code, code) || other.code == code)&&(identical(other.libelle, libelle) || other.libelle == libelle)&&(identical(other.annee, annee) || other.annee == annee)&&(identical(other.moyenne, moyenne) || other.moyenne == moyenne)&&(identical(other.creditsAcquis, creditsAcquis) || other.creditsAcquis == creditsAcquis)&&(identical(other.estActif, estActif) || other.estActif == estActif));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,semesterId,code,libelle,annee,moyenne,creditsAcquis,estActif);
}

@override
String toString() {
    return 'SemesterAverage(semesterId: $semesterId, code: $code, libelle: $libelle, annee: $annee, moyenne: $moyenne, creditsAcquis: $creditsAcquis, estActif: $estActif)';
}


}

/// @nodoc
abstract mixin class _$SemesterAverageCopyWith<$Res> implements $SemesterAverageCopyWith<$Res> {
  factory _$SemesterAverageCopyWith(_SemesterAverage value, $Res Function(_SemesterAverage) _then) = __$SemesterAverageCopyWithImpl;
@override @useResult
$Res call({
 String semesterId, String code, String libelle, String annee, double? moyenne, int creditsAcquis, bool estActif
});




}
/// @nodoc
class __$SemesterAverageCopyWithImpl<$Res>
    implements _$SemesterAverageCopyWith<$Res> {
  __$SemesterAverageCopyWithImpl(this._self, this._then);

  final _SemesterAverage _self;
  final $Res Function(_SemesterAverage) _then;

/// Create a copy of SemesterAverage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? semesterId = null,Object? code = null,Object? libelle = null,Object? annee = null,Object? moyenne = freezed,Object? creditsAcquis = null,Object? estActif = null,}) {
  return _then(_SemesterAverage(
semesterId: null == semesterId ? _self.semesterId : semesterId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,libelle: null == libelle ? _self.libelle : libelle // ignore: cast_nullable_to_non_nullable
as String,annee: null == annee ? _self.annee : annee // ignore: cast_nullable_to_non_nullable
as String,moyenne: freezed == moyenne ? _self.moyenne : moyenne // ignore: cast_nullable_to_non_nullable
as double?,creditsAcquis: null == creditsAcquis ? _self.creditsAcquis : creditsAcquis // ignore: cast_nullable_to_non_nullable
as int,estActif: null == estActif ? _self.estActif : estActif // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
