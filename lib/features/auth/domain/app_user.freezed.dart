// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonProfile {

 String get id; String get nom; String get prenom; String? get matricule; String? get profession; String? get adresse; String? get contactUrgence; String? get specialite;
/// Create a copy of PersonProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<PersonProfile> get copyWith => _$PersonProfileCopyWithImpl<PersonProfile>(this as PersonProfile, _$identity);

  /// Serializes this PersonProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.prenom, _this.prenom) || other.prenom == _this.prenom)&&(identical(other.matricule, _this.matricule) || other.matricule == _this.matricule)&&(identical(other.profession, _this.profession) || other.profession == _this.profession)&&(identical(other.adresse, _this.adresse) || other.adresse == _this.adresse)&&(identical(other.contactUrgence, _this.contactUrgence) || other.contactUrgence == _this.contactUrgence)&&(identical(other.specialite, _this.specialite) || other.specialite == _this.specialite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonProfile;
  return Object.hash(runtimeType,_this.id,_this.nom,_this.prenom,_this.matricule,_this.profession,_this.adresse,_this.contactUrgence,_this.specialite);
}

@override
String toString() {
  final _this = this as PersonProfile;
  return 'PersonProfile(id: ${_this.id}, nom: ${_this.nom}, prenom: ${_this.prenom}, matricule: ${_this.matricule}, profession: ${_this.profession}, adresse: ${_this.adresse}, contactUrgence: ${_this.contactUrgence}, specialite: ${_this.specialite})';
}


}

/// @nodoc
abstract mixin class $PersonProfileCopyWith<$Res>  {
  factory $PersonProfileCopyWith(PersonProfile value, $Res Function(PersonProfile) _then) = _$PersonProfileCopyWithImpl;
@useResult
$Res call({
 String id, String nom, String prenom, String? matricule, String? profession, String? adresse, String? contactUrgence, String? specialite
});




}
/// @nodoc
class _$PersonProfileCopyWithImpl<$Res>
    implements $PersonProfileCopyWith<$Res> {
  _$PersonProfileCopyWithImpl(this._self, this._then);

  final PersonProfile _self;
  final $Res Function(PersonProfile) _then;

/// Create a copy of PersonProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nom = null,Object? prenom = null,Object? matricule = freezed,Object? profession = freezed,Object? adresse = freezed,Object? contactUrgence = freezed,Object? specialite = freezed,}) {
  return _then(PersonProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,matricule: freezed == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,contactUrgence: freezed == contactUrgence ? _self.contactUrgence : contactUrgence // ignore: cast_nullable_to_non_nullable
as String?,specialite: freezed == specialite ? _self.specialite : specialite // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonProfile].
extension PersonProfilePatterns on PersonProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonProfile value)  $default,){
final _that = this;
switch (_that) {
case _PersonProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PersonProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nom,  String prenom,  String? matricule,  String? profession,  String? adresse,  String? contactUrgence,  String? specialite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonProfile() when $default != null:
return $default(_that.id,_that.nom,_that.prenom,_that.matricule,_that.profession,_that.adresse,_that.contactUrgence,_that.specialite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nom,  String prenom,  String? matricule,  String? profession,  String? adresse,  String? contactUrgence,  String? specialite)  $default,) {final _that = this;
switch (_that) {
case _PersonProfile():
return $default(_that.id,_that.nom,_that.prenom,_that.matricule,_that.profession,_that.adresse,_that.contactUrgence,_that.specialite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nom,  String prenom,  String? matricule,  String? profession,  String? adresse,  String? contactUrgence,  String? specialite)?  $default,) {final _that = this;
switch (_that) {
case _PersonProfile() when $default != null:
return $default(_that.id,_that.nom,_that.prenom,_that.matricule,_that.profession,_that.adresse,_that.contactUrgence,_that.specialite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonProfile implements PersonProfile {
  const _PersonProfile({required this.id, this.nom = '', this.prenom = '', this.matricule, this.profession, this.adresse, this.contactUrgence, this.specialite});
  factory _PersonProfile.fromJson(Map<String, dynamic> json) => _$PersonProfileFromJson(json);

@override final  String id;
@override@JsonKey() final  String nom;
@override@JsonKey() final  String prenom;
@override final  String? matricule;
@override final  String? profession;
@override final  String? adresse;
@override final  String? contactUrgence;
@override final  String? specialite;

/// Create a copy of PersonProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonProfileCopyWith<_PersonProfile> get copyWith => __$PersonProfileCopyWithImpl<_PersonProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.prenom, prenom) || other.prenom == prenom)&&(identical(other.matricule, matricule) || other.matricule == matricule)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.adresse, adresse) || other.adresse == adresse)&&(identical(other.contactUrgence, contactUrgence) || other.contactUrgence == contactUrgence)&&(identical(other.specialite, specialite) || other.specialite == specialite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,nom,prenom,matricule,profession,adresse,contactUrgence,specialite);
}

@override
String toString() {
    return 'PersonProfile(id: $id, nom: $nom, prenom: $prenom, matricule: $matricule, profession: $profession, adresse: $adresse, contactUrgence: $contactUrgence, specialite: $specialite)';
}


}

/// @nodoc
abstract mixin class _$PersonProfileCopyWith<$Res> implements $PersonProfileCopyWith<$Res> {
  factory _$PersonProfileCopyWith(_PersonProfile value, $Res Function(_PersonProfile) _then) = __$PersonProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String nom, String prenom, String? matricule, String? profession, String? adresse, String? contactUrgence, String? specialite
});




}
/// @nodoc
class __$PersonProfileCopyWithImpl<$Res>
    implements _$PersonProfileCopyWith<$Res> {
  __$PersonProfileCopyWithImpl(this._self, this._then);

  final _PersonProfile _self;
  final $Res Function(_PersonProfile) _then;

/// Create a copy of PersonProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nom = null,Object? prenom = null,Object? matricule = freezed,Object? profession = freezed,Object? adresse = freezed,Object? contactUrgence = freezed,Object? specialite = freezed,}) {
  return _then(_PersonProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,matricule: freezed == matricule ? _self.matricule : matricule // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,contactUrgence: freezed == contactUrgence ? _self.contactUrgence : contactUrgence // ignore: cast_nullable_to_non_nullable
as String?,specialite: freezed == specialite ? _self.specialite : specialite // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppUser {

 String get id; String? get email; String? get telephone; String get role; String get status; String get preferredLocale; bool get twoFactorEnabled; PersonProfile? get parentProfile; PersonProfile? get studentProfile; PersonProfile? get teacherProfile;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.telephone, _this.telephone) || other.telephone == _this.telephone)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.preferredLocale, _this.preferredLocale) || other.preferredLocale == _this.preferredLocale)&&(identical(other.twoFactorEnabled, _this.twoFactorEnabled) || other.twoFactorEnabled == _this.twoFactorEnabled)&&(identical(other.parentProfile, _this.parentProfile) || other.parentProfile == _this.parentProfile)&&(identical(other.studentProfile, _this.studentProfile) || other.studentProfile == _this.studentProfile)&&(identical(other.teacherProfile, _this.teacherProfile) || other.teacherProfile == _this.teacherProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppUser;
  return Object.hash(runtimeType,_this.id,_this.email,_this.telephone,_this.role,_this.status,_this.preferredLocale,_this.twoFactorEnabled,_this.parentProfile,_this.studentProfile,_this.teacherProfile);
}

@override
String toString() {
  final _this = this as AppUser;
  return 'AppUser(id: ${_this.id}, email: ${_this.email}, telephone: ${_this.telephone}, role: ${_this.role}, status: ${_this.status}, preferredLocale: ${_this.preferredLocale}, twoFactorEnabled: ${_this.twoFactorEnabled}, parentProfile: ${_this.parentProfile}, studentProfile: ${_this.studentProfile}, teacherProfile: ${_this.teacherProfile})';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String? email, String? telephone, String role, String status, String preferredLocale, bool twoFactorEnabled, PersonProfile? parentProfile, PersonProfile? studentProfile, PersonProfile? teacherProfile
});


$PersonProfileCopyWith<$Res>? get parentProfile;$PersonProfileCopyWith<$Res>? get studentProfile;$PersonProfileCopyWith<$Res>? get teacherProfile;

}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? telephone = freezed,Object? role = null,Object? status = null,Object? preferredLocale = null,Object? twoFactorEnabled = null,Object? parentProfile = freezed,Object? studentProfile = freezed,Object? teacherProfile = freezed,}) {
  return _then(AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,preferredLocale: null == preferredLocale ? _self.preferredLocale : preferredLocale // ignore: cast_nullable_to_non_nullable
as String,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,parentProfile: freezed == parentProfile ? _self.parentProfile : parentProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,studentProfile: freezed == studentProfile ? _self.studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,teacherProfile: freezed == teacherProfile ? _self.teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,
  ));
}
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get parentProfile {
    if (_self.parentProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.parentProfile!, (value) {
    return _then(_self.copyWith(parentProfile: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get studentProfile {
    if (_self.studentProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.studentProfile!, (value) {
    return _then(_self.copyWith(studentProfile: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get teacherProfile {
    if (_self.teacherProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.teacherProfile!, (value) {
    return _then(_self.copyWith(teacherProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? email,  String? telephone,  String role,  String status,  String preferredLocale,  bool twoFactorEnabled,  PersonProfile? parentProfile,  PersonProfile? studentProfile,  PersonProfile? teacherProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.telephone,_that.role,_that.status,_that.preferredLocale,_that.twoFactorEnabled,_that.parentProfile,_that.studentProfile,_that.teacherProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? email,  String? telephone,  String role,  String status,  String preferredLocale,  bool twoFactorEnabled,  PersonProfile? parentProfile,  PersonProfile? studentProfile,  PersonProfile? teacherProfile)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.email,_that.telephone,_that.role,_that.status,_that.preferredLocale,_that.twoFactorEnabled,_that.parentProfile,_that.studentProfile,_that.teacherProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? email,  String? telephone,  String role,  String status,  String preferredLocale,  bool twoFactorEnabled,  PersonProfile? parentProfile,  PersonProfile? studentProfile,  PersonProfile? teacherProfile)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.telephone,_that.role,_that.status,_that.preferredLocale,_that.twoFactorEnabled,_that.parentProfile,_that.studentProfile,_that.teacherProfile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({required this.id, this.email, this.telephone, required this.role, this.status = 'ACTIVE', this.preferredLocale = 'fr', this.twoFactorEnabled = false, this.parentProfile, this.studentProfile, this.teacherProfile}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String? email;
@override final  String? telephone;
@override final  String role;
@override@JsonKey() final  String status;
@override@JsonKey() final  String preferredLocale;
@override@JsonKey() final  bool twoFactorEnabled;
@override final  PersonProfile? parentProfile;
@override final  PersonProfile? studentProfile;
@override final  PersonProfile? teacherProfile;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.telephone, telephone) || other.telephone == telephone)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.preferredLocale, preferredLocale) || other.preferredLocale == preferredLocale)&&(identical(other.twoFactorEnabled, twoFactorEnabled) || other.twoFactorEnabled == twoFactorEnabled)&&(identical(other.parentProfile, parentProfile) || other.parentProfile == parentProfile)&&(identical(other.studentProfile, studentProfile) || other.studentProfile == studentProfile)&&(identical(other.teacherProfile, teacherProfile) || other.teacherProfile == teacherProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,telephone,role,status,preferredLocale,twoFactorEnabled,parentProfile,studentProfile,teacherProfile);
}

@override
String toString() {
    return 'AppUser(id: $id, email: $email, telephone: $telephone, role: $role, status: $status, preferredLocale: $preferredLocale, twoFactorEnabled: $twoFactorEnabled, parentProfile: $parentProfile, studentProfile: $studentProfile, teacherProfile: $teacherProfile)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String? email, String? telephone, String role, String status, String preferredLocale, bool twoFactorEnabled, PersonProfile? parentProfile, PersonProfile? studentProfile, PersonProfile? teacherProfile
});


@override $PersonProfileCopyWith<$Res>? get parentProfile;@override $PersonProfileCopyWith<$Res>? get studentProfile;@override $PersonProfileCopyWith<$Res>? get teacherProfile;

}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? telephone = freezed,Object? role = null,Object? status = null,Object? preferredLocale = null,Object? twoFactorEnabled = null,Object? parentProfile = freezed,Object? studentProfile = freezed,Object? teacherProfile = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,telephone: freezed == telephone ? _self.telephone : telephone // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,preferredLocale: null == preferredLocale ? _self.preferredLocale : preferredLocale // ignore: cast_nullable_to_non_nullable
as String,twoFactorEnabled: null == twoFactorEnabled ? _self.twoFactorEnabled : twoFactorEnabled // ignore: cast_nullable_to_non_nullable
as bool,parentProfile: freezed == parentProfile ? _self.parentProfile : parentProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,studentProfile: freezed == studentProfile ? _self.studentProfile : studentProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,teacherProfile: freezed == teacherProfile ? _self.teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as PersonProfile?,
  ));
}

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get parentProfile {
    if (_self.parentProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.parentProfile!, (value) {
    return _then(_self.copyWith(parentProfile: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get studentProfile {
    if (_self.studentProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.studentProfile!, (value) {
    return _then(_self.copyWith(studentProfile: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonProfileCopyWith<$Res>? get teacherProfile {
    if (_self.teacherProfile == null) {
    return null;
  }

  return $PersonProfileCopyWith<$Res>(_self.teacherProfile!, (value) {
    return _then(_self.copyWith(teacherProfile: value));
  });
}
}

// dart format on
