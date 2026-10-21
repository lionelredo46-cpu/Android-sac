// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Program {

 String get id; String get code; String get nom; String get niveau;
/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgramCopyWith<Program> get copyWith => _$ProgramCopyWithImpl<Program>(this as Program, _$identity);

  /// Serializes this Program to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Program;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Program&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.niveau, _this.niveau) || other.niveau == _this.niveau));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Program;
  return Object.hash(runtimeType,_this.id,_this.code,_this.nom,_this.niveau);
}

@override
String toString() {
  final _this = this as Program;
  return 'Program(id: ${_this.id}, code: ${_this.code}, nom: ${_this.nom}, niveau: ${_this.niveau})';
}


}

/// @nodoc
abstract mixin class $ProgramCopyWith<$Res>  {
  factory $ProgramCopyWith(Program value, $Res Function(Program) _then) = _$ProgramCopyWithImpl;
@useResult
$Res call({
 String id, String code, String nom, String niveau
});




}
/// @nodoc
class _$ProgramCopyWithImpl<$Res>
    implements $ProgramCopyWith<$Res> {
  _$ProgramCopyWithImpl(this._self, this._then);

  final Program _self;
  final $Res Function(Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? nom = null,Object? niveau = null,}) {
  return _then(Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,niveau: null == niveau ? _self.niveau : niveau // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Program].
extension ProgramPatterns on Program {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Program value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Program() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Program value)  $default,){
final _that = this;
switch (_that) {
case _Program():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Program value)?  $default,){
final _that = this;
switch (_that) {
case _Program() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String code,  String nom,  String niveau)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.code,_that.nom,_that.niveau);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String code,  String nom,  String niveau)  $default,) {final _that = this;
switch (_that) {
case _Program():
return $default(_that.id,_that.code,_that.nom,_that.niveau);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String code,  String nom,  String niveau)?  $default,) {final _that = this;
switch (_that) {
case _Program() when $default != null:
return $default(_that.id,_that.code,_that.nom,_that.niveau);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Program implements Program {
  const _Program({required this.id, required this.code, required this.nom, this.niveau = 'LICENCE'});
  factory _Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

@override final  String id;
@override final  String code;
@override final  String nom;
@override@JsonKey() final  String niveau;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgramCopyWith<_Program> get copyWith => __$ProgramCopyWithImpl<_Program>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProgramToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Program&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.niveau, niveau) || other.niveau == niveau));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code,nom,niveau);
}

@override
String toString() {
    return 'Program(id: $id, code: $code, nom: $nom, niveau: $niveau)';
}


}

/// @nodoc
abstract mixin class _$ProgramCopyWith<$Res> implements $ProgramCopyWith<$Res> {
  factory _$ProgramCopyWith(_Program value, $Res Function(_Program) _then) = __$ProgramCopyWithImpl;
@override @useResult
$Res call({
 String id, String code, String nom, String niveau
});




}
/// @nodoc
class __$ProgramCopyWithImpl<$Res>
    implements _$ProgramCopyWith<$Res> {
  __$ProgramCopyWithImpl(this._self, this._then);

  final _Program _self;
  final $Res Function(_Program) _then;

/// Create a copy of Program
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? nom = null,Object? niveau = null,}) {
  return _then(_Program(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,niveau: null == niveau ? _self.niveau : niveau // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$StudentGroup {

 String get id; String get nom; int get anneeNiveau; Program get program;
/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentGroupCopyWith<StudentGroup> get copyWith => _$StudentGroupCopyWithImpl<StudentGroup>(this as StudentGroup, _$identity);

  /// Serializes this StudentGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StudentGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.anneeNiveau, _this.anneeNiveau) || other.anneeNiveau == _this.anneeNiveau)&&(identical(other.program, _this.program) || other.program == _this.program));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StudentGroup;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.anneeNiveau,_this.program);
}

@override
String toString() {
  final _this = this as StudentGroup;
  return 'StudentGroup(id: ${_this.id}, nom: ${_this.nom}, anneeNiveau: ${_this.anneeNiveau}, program: ${_this.program})';
}


}

/// @nodoc
abstract mixin class $StudentGroupCopyWith<$Res>  {
  factory $StudentGroupCopyWith(StudentGroup value, $Res Function(StudentGroup) _then) = _$StudentGroupCopyWithImpl;
@useResult
$Res call({
 String id, String nom, int anneeNiveau, Program program
});


$ProgramCopyWith<$Res> get program;

}
/// @nodoc
class _$StudentGroupCopyWithImpl<$Res>
    implements $StudentGroupCopyWith<$Res> {
  _$StudentGroupCopyWithImpl(this._self, this._then);

  final StudentGroup _self;
  final $Res Function(StudentGroup) _then;

/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? anneeNiveau = null,Object? program = null,}) {
  return _then(StudentGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,anneeNiveau: null == anneeNiveau ? _self.anneeNiveau : anneeNiveau // ignore: cast_nullable_to_non_nullable
as int,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,
  ));
}
/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgramCopyWith<$Res> get program {
  
  return $ProgramCopyWith<$Res>(_self.program, (value) {
    return _then(_self.copyWith(program: value));
  });
}
}


/// Adds pattern-matching-related methods to [StudentGroup].
extension StudentGroupPatterns on StudentGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentGroup value)  $default,){
final _that = this;
switch (_that) {
case _StudentGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentGroup value)?  $default,){
final _that = this;
switch (_that) {
case _StudentGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nom,  int anneeNiveau,  Program program)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentGroup() when $default != null:
return $default(_that.id,_that.nom,_that.anneeNiveau,_that.program);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nom,  int anneeNiveau,  Program program)  $default,) {final _that = this;
switch (_that) {
case _StudentGroup():
return $default(_that.id,_that.nom,_that.anneeNiveau,_that.program);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nom,  int anneeNiveau,  Program program)?  $default,) {final _that = this;
switch (_that) {
case _StudentGroup() when $default != null:
return $default(_that.id,_that.nom,_that.anneeNiveau,_that.program);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentGroup implements StudentGroup {
  const _StudentGroup({required this.id, required this.nom, this.anneeNiveau = 1, required this.program});
  factory _StudentGroup.fromJson(Map<String, dynamic> json) => _$StudentGroupFromJson(json);

@override final  String id;
@override final  String nom;
@override@JsonKey() final  int anneeNiveau;
@override final  Program program;

/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentGroupCopyWith<_StudentGroup> get copyWith => __$StudentGroupCopyWithImpl<_StudentGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.anneeNiveau, anneeNiveau) || other.anneeNiveau == anneeNiveau)&&(identical(other.program, program) || other.program == program));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,anneeNiveau,program);
}

@override
String toString() {
    return 'StudentGroup(id: $id, nom: $nom, anneeNiveau: $anneeNiveau, program: $program)';
}


}

/// @nodoc
abstract mixin class _$StudentGroupCopyWith<$Res> implements $StudentGroupCopyWith<$Res> {
  factory _$StudentGroupCopyWith(_StudentGroup value, $Res Function(_StudentGroup) _then) = __$StudentGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String nom, int anneeNiveau, Program program
});


@override $ProgramCopyWith<$Res> get program;

}
/// @nodoc
class __$StudentGroupCopyWithImpl<$Res>
    implements _$StudentGroupCopyWith<$Res> {
  __$StudentGroupCopyWithImpl(this._self, this._then);

  final _StudentGroup _self;
  final $Res Function(_StudentGroup) _then;

/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? anneeNiveau = null,Object? program = null,}) {
  return _then(_StudentGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,anneeNiveau: null == anneeNiveau ? _self.anneeNiveau : anneeNiveau // ignore: cast_nullable_to_non_nullable
as int,program: null == program ? _self.program : program // ignore: cast_nullable_to_non_nullable
as Program,
  ));
}

/// Create a copy of StudentGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProgramCopyWith<$Res> get program {
  
  return $ProgramCopyWith<$Res>(_self.program, (value) {
    return _then(_self.copyWith(program: value));
  });
}
}


/// @nodoc
mixin _$Child {

 String get id; String get matricule; String get nom; String get prenom; String? get photoUrl; String get statut; DateTime? get dateNaissance; DateTime? get dateInscription; String? get responsablePeda; StudentGroup get group; String get relation; bool get estPayeur; bool get peutConsulter;
/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChildCopyWith<Child> get copyWith => _$ChildCopyWithImpl<Child>(this as Child, _$identity);

  /// Serializes this Child to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Child;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Child&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.matricule, _this.matricule) || other.matricule == _this.matricule)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.prenom, _this.prenom) || other.prenom == _this.prenom)&&(identical(other.photoUrl, _this.photoUrl) || other.photoUrl == _this.photoUrl)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.dateNaissance, _this.dateNaissance) || other.dateNaissance == _this.dateNaissance)&&(identical(other.dateInscription, _this.dateInscription) || other.dateInscription == _this.dateInscription)&&(identical(other.responsablePeda, _this.responsablePeda) || other.responsablePeda == _this.responsablePeda)&&(identical(other.group, _this.group) || other.group == _this.group)&&(identical(other.relation, _this.relation) || other.relation == _this.relation)&&(identical(other.estPayeur, _this.estPayeur) || other.estPayeur == _this.estPayeur)&&(identical(other.peutConsulter, _this.peutConsulter) || other.peutConsulter == _this.peutConsulter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Child;
  return Object.hash(runtimeType,_this.id,_this.matricule,_this.nom,_this.prenom,_this.photoUrl,_this.statut,_this.dateNaissance,_this.dateInscription,_this.responsablePeda,_this.group,_this.relation,_this.estPayeur,_this.peutConsulter);
}

@override
String toString() {
  final _this = this as Child;
  return 'Child(id: ${_this.id}, matricule: ${_this.matricule}, nom: ${_this.nom}, prenom: ${_this.prenom}, photoUrl: ${_this.photoUrl}, statut: ${_this.statut}, dateNaissance: ${_this.dateNaissance}, dateInscription: ${_this.dateInscription}, responsablePeda: ${_this.responsablePeda}, group: ${_this.group}, relation: ${_this.relation}, estPayeur: ${_this.estPayeur}, peutConsulter: ${_this.peutConsulter})';
}


}

/// @nodoc
abstract mixin class $ChildCopyWith<$Res>  {
  factory $ChildCopyWith(Child value, $Res Function(Child) _then) = _$ChildCopyWithImpl;
@useResult
$Res call({
 String id, String matricule, String nom, String prenom, String? photoUrl, String statut, DateTime? dateNaissance, DateTime? dateInscription, String? responsablePeda, StudentGroup group, String relation, bool estPayeur, bool peutConsulter
});


$StudentGroupCopyWith<$Res> get group;

}
/// @nodoc
class _$ChildCopyWithImpl<$Res>
    implements $ChildCopyWith<$Res> {
  _$ChildCopyWithImpl(this._self, this._then);

  final Child _self;
  final $Res Function(Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? matricule = null,Object? nom = null,Object? prenom = null,Object? photoUrl = freezed,Object? statut = null,Object? dateNaissance = freezed,Object? dateInscription = freezed,Object? responsablePeda = freezed,Object? group = null,Object? relation = null,Object? estPayeur = null,Object? peutConsulter = null,}) {
  return _then(Child(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matricule: null == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,dateNaissance: freezed == dateNaissance ? _self.dateNaissance : dateNaissance // ignore: cast_nullable_to_non_nullable
as DateTime?,dateInscription: freezed == dateInscription ? _self.dateInscription : dateInscription // ignore: cast_nullable_to_non_nullable
as DateTime?,responsablePeda: freezed == responsablePeda ? _self.responsablePeda : responsablePeda // ignore: cast_nullable_to_non_nullable
as String?,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as StudentGroup,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,estPayeur: null == estPayeur ? _self.estPayeur : estPayeur // ignore: cast_nullable_to_non_nullable
as bool,peutConsulter: null == peutConsulter ? _self.peutConsulter : peutConsulter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentGroupCopyWith<$Res> get group {
  
  return $StudentGroupCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}


/// Adds pattern-matching-related methods to [Child].
extension ChildPatterns on Child {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Child value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Child() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Child value)  $default,){
final _that = this;
switch (_that) {
case _Child():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Child value)?  $default,){
final _that = this;
switch (_that) {
case _Child() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String matricule,  String nom,  String prenom,  String? photoUrl,  String statut,  DateTime? dateNaissance,  DateTime? dateInscription,  String? responsablePeda,  StudentGroup group,  String relation,  bool estPayeur,  bool peutConsulter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Child() when $default != null:
return $default(_that.id,_that.matricule,_that.nom,_that.prenom,_that.photoUrl,_that.statut,_that.dateNaissance,_that.dateInscription,_that.responsablePeda,_that.group,_that.relation,_that.estPayeur,_that.peutConsulter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String matricule,  String nom,  String prenom,  String? photoUrl,  String statut,  DateTime? dateNaissance,  DateTime? dateInscription,  String? responsablePeda,  StudentGroup group,  String relation,  bool estPayeur,  bool peutConsulter)  $default,) {final _that = this;
switch (_that) {
case _Child():
return $default(_that.id,_that.matricule,_that.nom,_that.prenom,_that.photoUrl,_that.statut,_that.dateNaissance,_that.dateInscription,_that.responsablePeda,_that.group,_that.relation,_that.estPayeur,_that.peutConsulter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String matricule,  String nom,  String prenom,  String? photoUrl,  String statut,  DateTime? dateNaissance,  DateTime? dateInscription,  String? responsablePeda,  StudentGroup group,  String relation,  bool estPayeur,  bool peutConsulter)?  $default,) {final _that = this;
switch (_that) {
case _Child() when $default != null:
return $default(_that.id,_that.matricule,_that.nom,_that.prenom,_that.photoUrl,_that.statut,_that.dateNaissance,_that.dateInscription,_that.responsablePeda,_that.group,_that.relation,_that.estPayeur,_that.peutConsulter);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Child extends Child {
  const _Child({required this.id, required this.matricule, required this.nom, required this.prenom, this.photoUrl, this.statut = 'INSCRIT', this.dateNaissance, this.dateInscription, this.responsablePeda, required this.group, this.relation = 'SOI', this.estPayeur = false, this.peutConsulter = true}): super._();
  factory _Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

@override final  String id;
@override final  String matricule;
@override final  String nom;
@override final  String prenom;
@override final  String? photoUrl;
@override@JsonKey() final  String statut;
@override final  DateTime? dateNaissance;
@override final  DateTime? dateInscription;
@override final  String? responsablePeda;
@override final  StudentGroup group;
@override@JsonKey() final  String relation;
@override@JsonKey() final  bool estPayeur;
@override@JsonKey() final  bool peutConsulter;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChildCopyWith<_Child> get copyWith => __$ChildCopyWithImpl<_Child>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChildToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Child&&(identical(other.id, id) || other.id == id)&&(identical(other.matricule, matricule) || other.matricule == matricule)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.prenom, prenom) || other.prenom == prenom)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.dateNaissance, dateNaissance) || other.dateNaissance == dateNaissance)&&(identical(other.dateInscription, dateInscription) || other.dateInscription == dateInscription)&&(identical(other.responsablePeda, responsablePeda) || other.responsablePeda == responsablePeda)&&(identical(other.group, group) || other.group == group)&&(identical(other.relation, relation) || other.relation == relation)&&(identical(other.estPayeur, estPayeur) || other.estPayeur == estPayeur)&&(identical(other.peutConsulter, peutConsulter) || other.peutConsulter == peutConsulter));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,matricule,nom,prenom,photoUrl,statut,dateNaissance,dateInscription,responsablePeda,group,relation,estPayeur,peutConsulter);
}

@override
String toString() {
    return 'Child(id: $id, matricule: $matricule, nom: $nom, prenom: $prenom, photoUrl: $photoUrl, statut: $statut, dateNaissance: $dateNaissance, dateInscription: $dateInscription, responsablePeda: $responsablePeda, group: $group, relation: $relation, estPayeur: $estPayeur, peutConsulter: $peutConsulter)';
}


}

/// @nodoc
abstract mixin class _$ChildCopyWith<$Res> implements $ChildCopyWith<$Res> {
  factory _$ChildCopyWith(_Child value, $Res Function(_Child) _then) = __$ChildCopyWithImpl;
@override @useResult
$Res call({
 String id, String matricule, String nom, String prenom, String? photoUrl, String statut, DateTime? dateNaissance, DateTime? dateInscription, String? responsablePeda, StudentGroup group, String relation, bool estPayeur, bool peutConsulter
});


@override $StudentGroupCopyWith<$Res> get group;

}
/// @nodoc
class __$ChildCopyWithImpl<$Res>
    implements _$ChildCopyWith<$Res> {
  __$ChildCopyWithImpl(this._self, this._then);

  final _Child _self;
  final $Res Function(_Child) _then;

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? matricule = null,Object? nom = null,Object? prenom = null,Object? photoUrl = freezed,Object? statut = null,Object? dateNaissance = freezed,Object? dateInscription = freezed,Object? responsablePeda = freezed,Object? group = null,Object? relation = null,Object? estPayeur = null,Object? peutConsulter = null,}) {
  return _then(_Child(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,matricule: null == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,dateNaissance: freezed == dateNaissance ? _self.dateNaissance : dateNaissance // ignore: cast_nullable_to_non_nullable
as DateTime?,dateInscription: freezed == dateInscription ? _self.dateInscription : dateInscription // ignore: cast_nullable_to_non_nullable
as DateTime?,responsablePeda: freezed == responsablePeda ? _self.responsablePeda : responsablePeda // ignore: cast_nullable_to_non_nullable
as String?,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as StudentGroup,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,estPayeur: null == estPayeur ? _self.estPayeur : estPayeur // ignore: cast_nullable_to_non_nullable
as bool,peutConsulter: null == peutConsulter ? _self.peutConsulter : peutConsulter // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Child
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentGroupCopyWith<$Res> get group {
  
  return $StudentGroupCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

// dart format on
