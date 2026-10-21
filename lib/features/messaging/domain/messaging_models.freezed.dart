// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messaging_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentRef {

 String get id; String get prenom; String get nom;
/// Create a copy of StudentRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentRefCopyWith<StudentRef> get copyWith => _$StudentRefCopyWithImpl<StudentRef>(this as StudentRef, _$identity);

  /// Serializes this StudentRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StudentRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.prenom, _this.prenom) || other.prenom == _this.prenom)&&(identical(other.nom, _this.nom) || other.nom == _this.nom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StudentRef;
  return Object.hash(runtimeType,_this.id,_this.prenom,_this.nom);
}

@override
String toString() {
  final _this = this as StudentRef;
  return 'StudentRef(id: ${_this.id}, prenom: ${_this.prenom}, nom: ${_this.nom})';
}


}

/// @nodoc
abstract mixin class $StudentRefCopyWith<$Res>  {
  factory $StudentRefCopyWith(StudentRef value, $Res Function(StudentRef) _then) = _$StudentRefCopyWithImpl;
@useResult
$Res call({
 String id, String prenom, String nom
});




}
/// @nodoc
class _$StudentRefCopyWithImpl<$Res>
    implements $StudentRefCopyWith<$Res> {
  _$StudentRefCopyWithImpl(this._self, this._then);

  final StudentRef _self;
  final $Res Function(StudentRef) _then;

/// Create a copy of StudentRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? prenom = null,Object? nom = null,}) {
  return _then(StudentRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentRef].
extension StudentRefPatterns on StudentRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentRef value)  $default,){
final _that = this;
switch (_that) {
case _StudentRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentRef value)?  $default,){
final _that = this;
switch (_that) {
case _StudentRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String prenom,  String nom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentRef() when $default != null:
return $default(_that.id,_that.prenom,_that.nom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String prenom,  String nom)  $default,) {final _that = this;
switch (_that) {
case _StudentRef():
return $default(_that.id,_that.prenom,_that.nom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String prenom,  String nom)?  $default,) {final _that = this;
switch (_that) {
case _StudentRef() when $default != null:
return $default(_that.id,_that.prenom,_that.nom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentRef implements StudentRef {
  const _StudentRef({required this.id, required this.prenom, required this.nom});
  factory _StudentRef.fromJson(Map<String, dynamic> json) => _$StudentRefFromJson(json);

@override final  String id;
@override final  String prenom;
@override final  String nom;

/// Create a copy of StudentRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentRefCopyWith<_StudentRef> get copyWith => __$StudentRefCopyWithImpl<_StudentRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentRef&&(identical(other.id, id) || other.id == id)&&(identical(other.prenom, prenom) || other.prenom == prenom)&&(identical(other.nom, nom) || other.nom == nom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,prenom,nom);
}

@override
String toString() {
    return 'StudentRef(id: $id, prenom: $prenom, nom: $nom)';
}


}

/// @nodoc
abstract mixin class _$StudentRefCopyWith<$Res> implements $StudentRefCopyWith<$Res> {
  factory _$StudentRefCopyWith(_StudentRef value, $Res Function(_StudentRef) _then) = __$StudentRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String prenom, String nom
});




}
/// @nodoc
class __$StudentRefCopyWithImpl<$Res>
    implements _$StudentRefCopyWith<$Res> {
  __$StudentRefCopyWithImpl(this._self, this._then);

  final _StudentRef _self;
  final $Res Function(_StudentRef) _then;

/// Create a copy of StudentRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? prenom = null,Object? nom = null,}) {
  return _then(_StudentRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LastMessage {

 String get contenu; DateTime get createdAt; String get auteurId;
/// Create a copy of LastMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastMessageCopyWith<LastMessage> get copyWith => _$LastMessageCopyWithImpl<LastMessage>(this as LastMessage, _$identity);

  /// Serializes this LastMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LastMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastMessage&&(identical(other.contenu, _this.contenu) || other.contenu == _this.contenu)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.auteurId, _this.auteurId) || other.auteurId == _this.auteurId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LastMessage;
  return Object.hash(runtimeType,_this.contenu,_this.createdAt,_this.auteurId);
}

@override
String toString() {
  final _this = this as LastMessage;
  return 'LastMessage(contenu: ${_this.contenu}, createdAt: ${_this.createdAt}, auteurId: ${_this.auteurId})';
}


}

/// @nodoc
abstract mixin class $LastMessageCopyWith<$Res>  {
  factory $LastMessageCopyWith(LastMessage value, $Res Function(LastMessage) _then) = _$LastMessageCopyWithImpl;
@useResult
$Res call({
 String contenu, DateTime createdAt, String auteurId
});




}
/// @nodoc
class _$LastMessageCopyWithImpl<$Res>
    implements $LastMessageCopyWith<$Res> {
  _$LastMessageCopyWithImpl(this._self, this._then);

  final LastMessage _self;
  final $Res Function(LastMessage) _then;

/// Create a copy of LastMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contenu = null,Object? createdAt = null,Object? auteurId = null,}) {
  return _then(LastMessage(
contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,auteurId: null == auteurId ? _self.auteurId : auteurId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LastMessage].
extension LastMessagePatterns on LastMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastMessage value)  $default,){
final _that = this;
switch (_that) {
case _LastMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastMessage value)?  $default,){
final _that = this;
switch (_that) {
case _LastMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contenu,  DateTime createdAt,  String auteurId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastMessage() when $default != null:
return $default(_that.contenu,_that.createdAt,_that.auteurId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contenu,  DateTime createdAt,  String auteurId)  $default,) {final _that = this;
switch (_that) {
case _LastMessage():
return $default(_that.contenu,_that.createdAt,_that.auteurId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contenu,  DateTime createdAt,  String auteurId)?  $default,) {final _that = this;
switch (_that) {
case _LastMessage() when $default != null:
return $default(_that.contenu,_that.createdAt,_that.auteurId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastMessage implements LastMessage {
  const _LastMessage({required this.contenu, required this.createdAt, required this.auteurId});
  factory _LastMessage.fromJson(Map<String, dynamic> json) => _$LastMessageFromJson(json);

@override final  String contenu;
@override final  DateTime createdAt;
@override final  String auteurId;

/// Create a copy of LastMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastMessageCopyWith<_LastMessage> get copyWith => __$LastMessageCopyWithImpl<_LastMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastMessage&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.auteurId, auteurId) || other.auteurId == auteurId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,contenu,createdAt,auteurId);
}

@override
String toString() {
    return 'LastMessage(contenu: $contenu, createdAt: $createdAt, auteurId: $auteurId)';
}


}

/// @nodoc
abstract mixin class _$LastMessageCopyWith<$Res> implements $LastMessageCopyWith<$Res> {
  factory _$LastMessageCopyWith(_LastMessage value, $Res Function(_LastMessage) _then) = __$LastMessageCopyWithImpl;
@override @useResult
$Res call({
 String contenu, DateTime createdAt, String auteurId
});




}
/// @nodoc
class __$LastMessageCopyWithImpl<$Res>
    implements _$LastMessageCopyWith<$Res> {
  __$LastMessageCopyWithImpl(this._self, this._then);

  final _LastMessage _self;
  final $Res Function(_LastMessage) _then;

/// Create a copy of LastMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contenu = null,Object? createdAt = null,Object? auteurId = null,}) {
  return _then(_LastMessage(
contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,auteurId: null == auteurId ? _self.auteurId : auteurId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConversationSummary {

 String get id; String get numeroTicket; String get sujet; String get service; String get priorite; String get statut; int? get satisfaction; DateTime? get slaDueAt; DateTime get updatedAt; StudentRef? get student; LastMessage? get dernierMessage; int get nonLus; bool get slaDepasse;
/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSummaryCopyWith<ConversationSummary> get copyWith => _$ConversationSummaryCopyWithImpl<ConversationSummary>(this as ConversationSummary, _$identity);

  /// Serializes this ConversationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numeroTicket, _this.numeroTicket) || other.numeroTicket == _this.numeroTicket)&&(identical(other.sujet, _this.sujet) || other.sujet == _this.sujet)&&(identical(other.service, _this.service) || other.service == _this.service)&&(identical(other.priorite, _this.priorite) || other.priorite == _this.priorite)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.satisfaction, _this.satisfaction) || other.satisfaction == _this.satisfaction)&&(identical(other.slaDueAt, _this.slaDueAt) || other.slaDueAt == _this.slaDueAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.student, _this.student) || other.student == _this.student)&&(identical(other.dernierMessage, _this.dernierMessage) || other.dernierMessage == _this.dernierMessage)&&(identical(other.nonLus, _this.nonLus) || other.nonLus == _this.nonLus)&&(identical(other.slaDepasse, _this.slaDepasse) || other.slaDepasse == _this.slaDepasse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationSummary;
  return Object.hash(runtimeType,_this.id,_this.numeroTicket,_this.sujet,_this.service,_this.priorite,_this.statut,_this.satisfaction,_this.slaDueAt,_this.updatedAt,_this.student,_this.dernierMessage,_this.nonLus,_this.slaDepasse);
}

@override
String toString() {
  final _this = this as ConversationSummary;
  return 'ConversationSummary(id: ${_this.id}, numeroTicket: ${_this.numeroTicket}, sujet: ${_this.sujet}, service: ${_this.service}, priorite: ${_this.priorite}, statut: ${_this.statut}, satisfaction: ${_this.satisfaction}, slaDueAt: ${_this.slaDueAt}, updatedAt: ${_this.updatedAt}, student: ${_this.student}, dernierMessage: ${_this.dernierMessage}, nonLus: ${_this.nonLus}, slaDepasse: ${_this.slaDepasse})';
}


}

/// @nodoc
abstract mixin class $ConversationSummaryCopyWith<$Res>  {
  factory $ConversationSummaryCopyWith(ConversationSummary value, $Res Function(ConversationSummary) _then) = _$ConversationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String numeroTicket, String sujet, String service, String priorite, String statut, int? satisfaction, DateTime? slaDueAt, DateTime updatedAt, StudentRef? student, LastMessage? dernierMessage, int nonLus, bool slaDepasse
});


$StudentRefCopyWith<$Res>? get student;$LastMessageCopyWith<$Res>? get dernierMessage;

}
/// @nodoc
class _$ConversationSummaryCopyWithImpl<$Res>
    implements $ConversationSummaryCopyWith<$Res> {
  _$ConversationSummaryCopyWithImpl(this._self, this._then);

  final ConversationSummary _self;
  final $Res Function(ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numeroTicket = null,Object? sujet = null,Object? service = null,Object? priorite = null,Object? statut = null,Object? satisfaction = freezed,Object? slaDueAt = freezed,Object? updatedAt = null,Object? student = freezed,Object? dernierMessage = freezed,Object? nonLus = null,Object? slaDepasse = null,}) {
  return _then(ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroTicket: null == numeroTicket ? _self.numeroTicket : numeroTicket // ignore: cast_nullable_to_non_nullable
as String,sujet: null == sujet ? _self.sujet : sujet // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,satisfaction: freezed == satisfaction ? _self.satisfaction : satisfaction // ignore: cast_nullable_to_non_nullable
as int?,slaDueAt: freezed == slaDueAt ? _self.slaDueAt : slaDueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentRef?,dernierMessage: freezed == dernierMessage ? _self.dernierMessage : dernierMessage // ignore: cast_nullable_to_non_nullable
as LastMessage?,nonLus: null == nonLus ? _self.nonLus : nonLus // ignore: cast_nullable_to_non_nullable
as int,slaDepasse: null == slaDepasse ? _self.slaDepasse : slaDepasse // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentRefCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $StudentRefCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessageCopyWith<$Res>? get dernierMessage {
    if (_self.dernierMessage == null) {
    return null;
  }

  return $LastMessageCopyWith<$Res>(_self.dernierMessage!, (value) {
    return _then(_self.copyWith(dernierMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationSummary].
extension ConversationSummaryPatterns on ConversationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String numeroTicket,  String sujet,  String service,  String priorite,  String statut,  int? satisfaction,  DateTime? slaDueAt,  DateTime updatedAt,  StudentRef? student,  LastMessage? dernierMessage,  int nonLus,  bool slaDepasse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.priorite,_that.statut,_that.satisfaction,_that.slaDueAt,_that.updatedAt,_that.student,_that.dernierMessage,_that.nonLus,_that.slaDepasse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String numeroTicket,  String sujet,  String service,  String priorite,  String statut,  int? satisfaction,  DateTime? slaDueAt,  DateTime updatedAt,  StudentRef? student,  LastMessage? dernierMessage,  int nonLus,  bool slaDepasse)  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary():
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.priorite,_that.statut,_that.satisfaction,_that.slaDueAt,_that.updatedAt,_that.student,_that.dernierMessage,_that.nonLus,_that.slaDepasse);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String numeroTicket,  String sujet,  String service,  String priorite,  String statut,  int? satisfaction,  DateTime? slaDueAt,  DateTime updatedAt,  StudentRef? student,  LastMessage? dernierMessage,  int nonLus,  bool slaDepasse)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.priorite,_that.statut,_that.satisfaction,_that.slaDueAt,_that.updatedAt,_that.student,_that.dernierMessage,_that.nonLus,_that.slaDepasse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationSummary implements ConversationSummary {
  const _ConversationSummary({required this.id, required this.numeroTicket, required this.sujet, required this.service, this.priorite = 'NORMALE', required this.statut, this.satisfaction, this.slaDueAt, required this.updatedAt, this.student, this.dernierMessage, this.nonLus = 0, this.slaDepasse = false});
  factory _ConversationSummary.fromJson(Map<String, dynamic> json) => _$ConversationSummaryFromJson(json);

@override final  String id;
@override final  String numeroTicket;
@override final  String sujet;
@override final  String service;
@override@JsonKey() final  String priorite;
@override final  String statut;
@override final  int? satisfaction;
@override final  DateTime? slaDueAt;
@override final  DateTime updatedAt;
@override final  StudentRef? student;
@override final  LastMessage? dernierMessage;
@override@JsonKey() final  int nonLus;
@override@JsonKey() final  bool slaDepasse;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSummaryCopyWith<_ConversationSummary> get copyWith => __$ConversationSummaryCopyWithImpl<_ConversationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.numeroTicket, numeroTicket) || other.numeroTicket == numeroTicket)&&(identical(other.sujet, sujet) || other.sujet == sujet)&&(identical(other.service, service) || other.service == service)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.satisfaction, satisfaction) || other.satisfaction == satisfaction)&&(identical(other.slaDueAt, slaDueAt) || other.slaDueAt == slaDueAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.student, student) || other.student == student)&&(identical(other.dernierMessage, dernierMessage) || other.dernierMessage == dernierMessage)&&(identical(other.nonLus, nonLus) || other.nonLus == nonLus)&&(identical(other.slaDepasse, slaDepasse) || other.slaDepasse == slaDepasse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numeroTicket,sujet,service,priorite,statut,satisfaction,slaDueAt,updatedAt,student,dernierMessage,nonLus,slaDepasse);
}

@override
String toString() {
    return 'ConversationSummary(id: $id, numeroTicket: $numeroTicket, sujet: $sujet, service: $service, priorite: $priorite, statut: $statut, satisfaction: $satisfaction, slaDueAt: $slaDueAt, updatedAt: $updatedAt, student: $student, dernierMessage: $dernierMessage, nonLus: $nonLus, slaDepasse: $slaDepasse)';
}


}

/// @nodoc
abstract mixin class _$ConversationSummaryCopyWith<$Res> implements $ConversationSummaryCopyWith<$Res> {
  factory _$ConversationSummaryCopyWith(_ConversationSummary value, $Res Function(_ConversationSummary) _then) = __$ConversationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String numeroTicket, String sujet, String service, String priorite, String statut, int? satisfaction, DateTime? slaDueAt, DateTime updatedAt, StudentRef? student, LastMessage? dernierMessage, int nonLus, bool slaDepasse
});


@override $StudentRefCopyWith<$Res>? get student;@override $LastMessageCopyWith<$Res>? get dernierMessage;

}
/// @nodoc
class __$ConversationSummaryCopyWithImpl<$Res>
    implements _$ConversationSummaryCopyWith<$Res> {
  __$ConversationSummaryCopyWithImpl(this._self, this._then);

  final _ConversationSummary _self;
  final $Res Function(_ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numeroTicket = null,Object? sujet = null,Object? service = null,Object? priorite = null,Object? statut = null,Object? satisfaction = freezed,Object? slaDueAt = freezed,Object? updatedAt = null,Object? student = freezed,Object? dernierMessage = freezed,Object? nonLus = null,Object? slaDepasse = null,}) {
  return _then(_ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroTicket: null == numeroTicket ? _self.numeroTicket : numeroTicket // ignore: cast_nullable_to_non_nullable
as String,sujet: null == sujet ? _self.sujet : sujet // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,satisfaction: freezed == satisfaction ? _self.satisfaction : satisfaction // ignore: cast_nullable_to_non_nullable
as int?,slaDueAt: freezed == slaDueAt ? _self.slaDueAt : slaDueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentRef?,dernierMessage: freezed == dernierMessage ? _self.dernierMessage : dernierMessage // ignore: cast_nullable_to_non_nullable
as LastMessage?,nonLus: null == nonLus ? _self.nonLus : nonLus // ignore: cast_nullable_to_non_nullable
as int,slaDepasse: null == slaDepasse ? _self.slaDepasse : slaDepasse // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentRefCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $StudentRefCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessageCopyWith<$Res>? get dernierMessage {
    if (_self.dernierMessage == null) {
    return null;
  }

  return $LastMessageCopyWith<$Res>(_self.dernierMessage!, (value) {
    return _then(_self.copyWith(dernierMessage: value));
  });
}
}


/// @nodoc
mixin _$ChatMessage {

 String get id; String get contenu; DateTime get createdAt; bool get estLu; DateTime? get luLe; int get piecesJointes; bool get moi; String get auteur; String get auteurRole;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatMessage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.contenu, _this.contenu) || other.contenu == _this.contenu)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.estLu, _this.estLu) || other.estLu == _this.estLu)&&(identical(other.luLe, _this.luLe) || other.luLe == _this.luLe)&&(identical(other.piecesJointes, _this.piecesJointes) || other.piecesJointes == _this.piecesJointes)&&(identical(other.moi, _this.moi) || other.moi == _this.moi)&&(identical(other.auteur, _this.auteur) || other.auteur == _this.auteur)&&(identical(other.auteurRole, _this.auteurRole) || other.auteurRole == _this.auteurRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatMessage;
  return Object.hash(runtimeType,_this.id,_this.contenu,_this.createdAt,_this.estLu,_this.luLe,_this.piecesJointes,_this.moi,_this.auteur,_this.auteurRole);
}

@override
String toString() {
  final _this = this as ChatMessage;
  return 'ChatMessage(id: ${_this.id}, contenu: ${_this.contenu}, createdAt: ${_this.createdAt}, estLu: ${_this.estLu}, luLe: ${_this.luLe}, piecesJointes: ${_this.piecesJointes}, moi: ${_this.moi}, auteur: ${_this.auteur}, auteurRole: ${_this.auteurRole})';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, String contenu, DateTime createdAt, bool estLu, DateTime? luLe, int piecesJointes, bool moi, String auteur, String auteurRole
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? contenu = null,Object? createdAt = null,Object? estLu = null,Object? luLe = freezed,Object? piecesJointes = null,Object? moi = null,Object? auteur = null,Object? auteurRole = null,}) {
  return _then(ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,estLu: null == estLu ? _self.estLu : estLu // ignore: cast_nullable_to_non_nullable
as bool,luLe: freezed == luLe ? _self.luLe : luLe // ignore: cast_nullable_to_non_nullable
as DateTime?,piecesJointes: null == piecesJointes ? _self.piecesJointes : piecesJointes // ignore: cast_nullable_to_non_nullable
as int,moi: null == moi ? _self.moi : moi // ignore: cast_nullable_to_non_nullable
as bool,auteur: null == auteur ? _self.auteur : auteur // ignore: cast_nullable_to_non_nullable
as String,auteurRole: null == auteurRole ? _self.auteurRole : auteurRole // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String contenu,  DateTime createdAt,  bool estLu,  DateTime? luLe,  int piecesJointes,  bool moi,  String auteur,  String auteurRole)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.contenu,_that.createdAt,_that.estLu,_that.luLe,_that.piecesJointes,_that.moi,_that.auteur,_that.auteurRole);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String contenu,  DateTime createdAt,  bool estLu,  DateTime? luLe,  int piecesJointes,  bool moi,  String auteur,  String auteurRole)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.contenu,_that.createdAt,_that.estLu,_that.luLe,_that.piecesJointes,_that.moi,_that.auteur,_that.auteurRole);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String contenu,  DateTime createdAt,  bool estLu,  DateTime? luLe,  int piecesJointes,  bool moi,  String auteur,  String auteurRole)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.contenu,_that.createdAt,_that.estLu,_that.luLe,_that.piecesJointes,_that.moi,_that.auteur,_that.auteurRole);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.contenu, required this.createdAt, this.estLu = false, this.luLe, this.piecesJointes = 0, this.moi = false, required this.auteur, required this.auteurRole});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  String contenu;
@override final  DateTime createdAt;
@override@JsonKey() final  bool estLu;
@override final  DateTime? luLe;
@override@JsonKey() final  int piecesJointes;
@override@JsonKey() final  bool moi;
@override final  String auteur;
@override final  String auteurRole;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.estLu, estLu) || other.estLu == estLu)&&(identical(other.luLe, luLe) || other.luLe == luLe)&&(identical(other.piecesJointes, piecesJointes) || other.piecesJointes == piecesJointes)&&(identical(other.moi, moi) || other.moi == moi)&&(identical(other.auteur, auteur) || other.auteur == auteur)&&(identical(other.auteurRole, auteurRole) || other.auteurRole == auteurRole));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,contenu,createdAt,estLu,luLe,piecesJointes,moi,auteur,auteurRole);
}

@override
String toString() {
    return 'ChatMessage(id: $id, contenu: $contenu, createdAt: $createdAt, estLu: $estLu, luLe: $luLe, piecesJointes: $piecesJointes, moi: $moi, auteur: $auteur, auteurRole: $auteurRole)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, String contenu, DateTime createdAt, bool estLu, DateTime? luLe, int piecesJointes, bool moi, String auteur, String auteurRole
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? contenu = null,Object? createdAt = null,Object? estLu = null,Object? luLe = freezed,Object? piecesJointes = null,Object? moi = null,Object? auteur = null,Object? auteurRole = null,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,estLu: null == estLu ? _self.estLu : estLu // ignore: cast_nullable_to_non_nullable
as bool,luLe: freezed == luLe ? _self.luLe : luLe // ignore: cast_nullable_to_non_nullable
as DateTime?,piecesJointes: null == piecesJointes ? _self.piecesJointes : piecesJointes // ignore: cast_nullable_to_non_nullable
as int,moi: null == moi ? _self.moi : moi // ignore: cast_nullable_to_non_nullable
as bool,auteur: null == auteur ? _self.auteur : auteur // ignore: cast_nullable_to_non_nullable
as String,auteurRole: null == auteurRole ? _self.auteurRole : auteurRole // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConversationDetail {

 String get id; String get numeroTicket; String get sujet; String get service; String get statut; String get priorite; int? get satisfaction; StudentRef? get student; List<ChatMessage> get messages;
/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationDetailCopyWith<ConversationDetail> get copyWith => _$ConversationDetailCopyWithImpl<ConversationDetail>(this as ConversationDetail, _$identity);

  /// Serializes this ConversationDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationDetail&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.numeroTicket, _this.numeroTicket) || other.numeroTicket == _this.numeroTicket)&&(identical(other.sujet, _this.sujet) || other.sujet == _this.sujet)&&(identical(other.service, _this.service) || other.service == _this.service)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.priorite, _this.priorite) || other.priorite == _this.priorite)&&(identical(other.satisfaction, _this.satisfaction) || other.satisfaction == _this.satisfaction)&&(identical(other.student, _this.student) || other.student == _this.student)&&const DeepCollectionEquality().equals(other.messages, _this.messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationDetail;
  return Object.hash(runtimeType,_this.id,_this.numeroTicket,_this.sujet,_this.service,_this.statut,_this.priorite,_this.satisfaction,_this.student,const DeepCollectionEquality().hash(_this.messages));
}

@override
String toString() {
  final _this = this as ConversationDetail;
  return 'ConversationDetail(id: ${_this.id}, numeroTicket: ${_this.numeroTicket}, sujet: ${_this.sujet}, service: ${_this.service}, statut: ${_this.statut}, priorite: ${_this.priorite}, satisfaction: ${_this.satisfaction}, student: ${_this.student}, messages: ${_this.messages})';
}


}

/// @nodoc
abstract mixin class $ConversationDetailCopyWith<$Res>  {
  factory $ConversationDetailCopyWith(ConversationDetail value, $Res Function(ConversationDetail) _then) = _$ConversationDetailCopyWithImpl;
@useResult
$Res call({
 String id, String numeroTicket, String sujet, String service, String statut, String priorite, int? satisfaction, StudentRef? student, List<ChatMessage> messages
});


$StudentRefCopyWith<$Res>? get student;

}
/// @nodoc
class _$ConversationDetailCopyWithImpl<$Res>
    implements $ConversationDetailCopyWith<$Res> {
  _$ConversationDetailCopyWithImpl(this._self, this._then);

  final ConversationDetail _self;
  final $Res Function(ConversationDetail) _then;

/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? numeroTicket = null,Object? sujet = null,Object? service = null,Object? statut = null,Object? priorite = null,Object? satisfaction = freezed,Object? student = freezed,Object? messages = null,}) {
  return _then(ConversationDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroTicket: null == numeroTicket ? _self.numeroTicket : numeroTicket // ignore: cast_nullable_to_non_nullable
as String,sujet: null == sujet ? _self.sujet : sujet // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,satisfaction: freezed == satisfaction ? _self.satisfaction : satisfaction // ignore: cast_nullable_to_non_nullable
as int?,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentRef?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}
/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentRefCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $StudentRefCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationDetail].
extension ConversationDetailPatterns on ConversationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationDetail value)  $default,){
final _that = this;
switch (_that) {
case _ConversationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String numeroTicket,  String sujet,  String service,  String statut,  String priorite,  int? satisfaction,  StudentRef? student,  List<ChatMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.statut,_that.priorite,_that.satisfaction,_that.student,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String numeroTicket,  String sujet,  String service,  String statut,  String priorite,  int? satisfaction,  StudentRef? student,  List<ChatMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _ConversationDetail():
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.statut,_that.priorite,_that.satisfaction,_that.student,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String numeroTicket,  String sujet,  String service,  String statut,  String priorite,  int? satisfaction,  StudentRef? student,  List<ChatMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
return $default(_that.id,_that.numeroTicket,_that.sujet,_that.service,_that.statut,_that.priorite,_that.satisfaction,_that.student,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationDetail implements ConversationDetail {
  const _ConversationDetail({required this.id, required this.numeroTicket, required this.sujet, required this.service, required this.statut, this.priorite = 'NORMALE', this.satisfaction, this.student,  List<ChatMessage> messages = const []}): _messages = messages;
  factory _ConversationDetail.fromJson(Map<String, dynamic> json) => _$ConversationDetailFromJson(json);

@override final  String id;
@override final  String numeroTicket;
@override final  String sujet;
@override final  String service;
@override final  String statut;
@override@JsonKey() final  String priorite;
@override final  int? satisfaction;
@override final  StudentRef? student;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationDetailCopyWith<_ConversationDetail> get copyWith => __$ConversationDetailCopyWithImpl<_ConversationDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationDetailToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.numeroTicket, numeroTicket) || other.numeroTicket == numeroTicket)&&(identical(other.sujet, sujet) || other.sujet == sujet)&&(identical(other.service, service) || other.service == service)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.priorite, priorite) || other.priorite == priorite)&&(identical(other.satisfaction, satisfaction) || other.satisfaction == satisfaction)&&(identical(other.student, student) || other.student == student)&&const DeepCollectionEquality().equals(other.messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,numeroTicket,sujet,service,statut,priorite,satisfaction,student,const DeepCollectionEquality().hash(_messages));
}

@override
String toString() {
    return 'ConversationDetail(id: $id, numeroTicket: $numeroTicket, sujet: $sujet, service: $service, statut: $statut, priorite: $priorite, satisfaction: $satisfaction, student: $student, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$ConversationDetailCopyWith<$Res> implements $ConversationDetailCopyWith<$Res> {
  factory _$ConversationDetailCopyWith(_ConversationDetail value, $Res Function(_ConversationDetail) _then) = __$ConversationDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String numeroTicket, String sujet, String service, String statut, String priorite, int? satisfaction, StudentRef? student, List<ChatMessage> messages
});


@override $StudentRefCopyWith<$Res>? get student;

}
/// @nodoc
class __$ConversationDetailCopyWithImpl<$Res>
    implements _$ConversationDetailCopyWith<$Res> {
  __$ConversationDetailCopyWithImpl(this._self, this._then);

  final _ConversationDetail _self;
  final $Res Function(_ConversationDetail) _then;

/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? numeroTicket = null,Object? sujet = null,Object? service = null,Object? statut = null,Object? priorite = null,Object? satisfaction = freezed,Object? student = freezed,Object? messages = null,}) {
  return _then(_ConversationDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,numeroTicket: null == numeroTicket ? _self.numeroTicket : numeroTicket // ignore: cast_nullable_to_non_nullable
as String,sujet: null == sujet ? _self.sujet : sujet // ignore: cast_nullable_to_non_nullable
as String,service: null == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as String,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,priorite: null == priorite ? _self.priorite : priorite // ignore: cast_nullable_to_non_nullable
as String,satisfaction: freezed == satisfaction ? _self.satisfaction : satisfaction // ignore: cast_nullable_to_non_nullable
as int?,student: freezed == student ? _self.student : student // ignore: cast_nullable_to_non_nullable
as StudentRef?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}

/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StudentRefCopyWith<$Res>? get student {
    if (_self.student == null) {
    return null;
  }

  return $StudentRefCopyWith<$Res>(_self.student!, (value) {
    return _then(_self.copyWith(student: value));
  });
}
}


/// @nodoc
mixin _$Announcement {

 String get id; String get titre; String get contenu; String get targetType; DateTime get datePublication;
/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnouncementCopyWith<Announcement> get copyWith => _$AnnouncementCopyWithImpl<Announcement>(this as Announcement, _$identity);

  /// Serializes this Announcement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Announcement;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Announcement&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.titre, _this.titre) || other.titre == _this.titre)&&(identical(other.contenu, _this.contenu) || other.contenu == _this.contenu)&&(identical(other.targetType, _this.targetType) || other.targetType == _this.targetType)&&(identical(other.datePublication, _this.datePublication) || other.datePublication == _this.datePublication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Announcement;
  return Object.hash(runtimeType,_this.id,_this.titre,_this.contenu,_this.targetType,_this.datePublication);
}

@override
String toString() {
  final _this = this as Announcement;
  return 'Announcement(id: ${_this.id}, titre: ${_this.titre}, contenu: ${_this.contenu}, targetType: ${_this.targetType}, datePublication: ${_this.datePublication})';
}


}

/// @nodoc
abstract mixin class $AnnouncementCopyWith<$Res>  {
  factory $AnnouncementCopyWith(Announcement value, $Res Function(Announcement) _then) = _$AnnouncementCopyWithImpl;
@useResult
$Res call({
 String id, String titre, String contenu, String targetType, DateTime datePublication
});




}
/// @nodoc
class _$AnnouncementCopyWithImpl<$Res>
    implements $AnnouncementCopyWith<$Res> {
  _$AnnouncementCopyWithImpl(this._self, this._then);

  final Announcement _self;
  final $Res Function(Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titre = null,Object? contenu = null,Object? targetType = null,Object? datePublication = null,}) {
  return _then(Announcement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,datePublication: null == datePublication ? _self.datePublication : datePublication // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Announcement].
extension AnnouncementPatterns on Announcement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Announcement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Announcement value)  $default,){
final _that = this;
switch (_that) {
case _Announcement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Announcement value)?  $default,){
final _that = this;
switch (_that) {
case _Announcement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titre,  String contenu,  String targetType,  DateTime datePublication)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.titre,_that.contenu,_that.targetType,_that.datePublication);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titre,  String contenu,  String targetType,  DateTime datePublication)  $default,) {final _that = this;
switch (_that) {
case _Announcement():
return $default(_that.id,_that.titre,_that.contenu,_that.targetType,_that.datePublication);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titre,  String contenu,  String targetType,  DateTime datePublication)?  $default,) {final _that = this;
switch (_that) {
case _Announcement() when $default != null:
return $default(_that.id,_that.titre,_that.contenu,_that.targetType,_that.datePublication);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Announcement implements Announcement {
  const _Announcement({required this.id, required this.titre, required this.contenu, this.targetType = 'ALL', required this.datePublication});
  factory _Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);

@override final  String id;
@override final  String titre;
@override final  String contenu;
@override@JsonKey() final  String targetType;
@override final  DateTime datePublication;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnouncementCopyWith<_Announcement> get copyWith => __$AnnouncementCopyWithImpl<_Announcement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnouncementToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Announcement&&(identical(other.id, id) || other.id == id)&&(identical(other.titre, titre) || other.titre == titre)&&(identical(other.contenu, contenu) || other.contenu == contenu)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.datePublication, datePublication) || other.datePublication == datePublication));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,titre,contenu,targetType,datePublication);
}

@override
String toString() {
    return 'Announcement(id: $id, titre: $titre, contenu: $contenu, targetType: $targetType, datePublication: $datePublication)';
}


}

/// @nodoc
abstract mixin class _$AnnouncementCopyWith<$Res> implements $AnnouncementCopyWith<$Res> {
  factory _$AnnouncementCopyWith(_Announcement value, $Res Function(_Announcement) _then) = __$AnnouncementCopyWithImpl;
@override @useResult
$Res call({
 String id, String titre, String contenu, String targetType, DateTime datePublication
});




}
/// @nodoc
class __$AnnouncementCopyWithImpl<$Res>
    implements _$AnnouncementCopyWith<$Res> {
  __$AnnouncementCopyWithImpl(this._self, this._then);

  final _Announcement _self;
  final $Res Function(_Announcement) _then;

/// Create a copy of Announcement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titre = null,Object? contenu = null,Object? targetType = null,Object? datePublication = null,}) {
  return _then(_Announcement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titre: null == titre ? _self.titre : titre // ignore: cast_nullable_to_non_nullable
as String,contenu: null == contenu ? _self.contenu : contenu // ignore: cast_nullable_to_non_nullable
as String,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,datePublication: null == datePublication ? _self.datePublication : datePublication // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HostProfile {

 String get nom; String get prenom; String? get specialite;
/// Create a copy of HostProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostProfileCopyWith<HostProfile> get copyWith => _$HostProfileCopyWithImpl<HostProfile>(this as HostProfile, _$identity);

  /// Serializes this HostProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HostProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HostProfile&&(identical(other.nom, _this.nom) || other.nom == _this.nom)&&(identical(other.prenom, _this.prenom) || other.prenom == _this.prenom)&&(identical(other.specialite, _this.specialite) || other.specialite == _this.specialite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HostProfile;
  return Object.hash(runtimeType,_this.nom,_this.prenom,_this.specialite);
}

@override
String toString() {
  final _this = this as HostProfile;
  return 'HostProfile(nom: ${_this.nom}, prenom: ${_this.prenom}, specialite: ${_this.specialite})';
}


}

/// @nodoc
abstract mixin class $HostProfileCopyWith<$Res>  {
  factory $HostProfileCopyWith(HostProfile value, $Res Function(HostProfile) _then) = _$HostProfileCopyWithImpl;
@useResult
$Res call({
 String nom, String prenom, String? specialite
});




}
/// @nodoc
class _$HostProfileCopyWithImpl<$Res>
    implements $HostProfileCopyWith<$Res> {
  _$HostProfileCopyWithImpl(this._self, this._then);

  final HostProfile _self;
  final $Res Function(HostProfile) _then;

/// Create a copy of HostProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nom = null,Object? prenom = null,Object? specialite = freezed,}) {
  return _then(HostProfile(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,specialite: freezed == specialite ? _self.specialite : specialite // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HostProfile].
extension HostProfilePatterns on HostProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HostProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HostProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HostProfile value)  $default,){
final _that = this;
switch (_that) {
case _HostProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HostProfile value)?  $default,){
final _that = this;
switch (_that) {
case _HostProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nom,  String prenom,  String? specialite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HostProfile() when $default != null:
return $default(_that.nom,_that.prenom,_that.specialite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nom,  String prenom,  String? specialite)  $default,) {final _that = this;
switch (_that) {
case _HostProfile():
return $default(_that.nom,_that.prenom,_that.specialite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nom,  String prenom,  String? specialite)?  $default,) {final _that = this;
switch (_that) {
case _HostProfile() when $default != null:
return $default(_that.nom,_that.prenom,_that.specialite);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HostProfile implements HostProfile {
  const _HostProfile({this.nom = '', this.prenom = '', this.specialite});
  factory _HostProfile.fromJson(Map<String, dynamic> json) => _$HostProfileFromJson(json);

@override@JsonKey() final  String nom;
@override@JsonKey() final  String prenom;
@override final  String? specialite;

/// Create a copy of HostProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostProfileCopyWith<_HostProfile> get copyWith => __$HostProfileCopyWithImpl<_HostProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HostProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HostProfile&&(identical(other.nom, nom) || other.nom == nom)&&(identical(other.prenom, prenom) || other.prenom == prenom)&&(identical(other.specialite, specialite) || other.specialite == specialite));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,nom,prenom,specialite);
}

@override
String toString() {
    return 'HostProfile(nom: $nom, prenom: $prenom, specialite: $specialite)';
}


}

/// @nodoc
abstract mixin class _$HostProfileCopyWith<$Res> implements $HostProfileCopyWith<$Res> {
  factory _$HostProfileCopyWith(_HostProfile value, $Res Function(_HostProfile) _then) = __$HostProfileCopyWithImpl;
@override @useResult
$Res call({
 String nom, String prenom, String? specialite
});




}
/// @nodoc
class __$HostProfileCopyWithImpl<$Res>
    implements _$HostProfileCopyWith<$Res> {
  __$HostProfileCopyWithImpl(this._self, this._then);

  final _HostProfile _self;
  final $Res Function(_HostProfile) _then;

/// Create a copy of HostProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nom = null,Object? prenom = null,Object? specialite = freezed,}) {
  return _then(_HostProfile(
nom: null == nom ? _self.nom : nom // ignore: cast_nullable_to_non_nullable
as String,prenom: null == prenom ? _self.prenom : prenom // ignore: cast_nullable_to_non_nullable
as String,specialite: freezed == specialite ? _self.specialite : specialite // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AppointmentHost {

 String get id; String get role; String? get email; HostProfile? get teacherProfile;
/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentHostCopyWith<AppointmentHost> get copyWith => _$AppointmentHostCopyWithImpl<AppointmentHost>(this as AppointmentHost, _$identity);

  /// Serializes this AppointmentHost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AppointmentHost;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentHost&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.teacherProfile, _this.teacherProfile) || other.teacherProfile == _this.teacherProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AppointmentHost;
  return Object.hash(runtimeType,_this.id,_this.role,_this.email,_this.teacherProfile);
}

@override
String toString() {
  final _this = this as AppointmentHost;
  return 'AppointmentHost(id: ${_this.id}, role: ${_this.role}, email: ${_this.email}, teacherProfile: ${_this.teacherProfile})';
}


}

/// @nodoc
abstract mixin class $AppointmentHostCopyWith<$Res>  {
  factory $AppointmentHostCopyWith(AppointmentHost value, $Res Function(AppointmentHost) _then) = _$AppointmentHostCopyWithImpl;
@useResult
$Res call({
 String id, String role, String? email, HostProfile? teacherProfile
});


$HostProfileCopyWith<$Res>? get teacherProfile;

}
/// @nodoc
class _$AppointmentHostCopyWithImpl<$Res>
    implements $AppointmentHostCopyWith<$Res> {
  _$AppointmentHostCopyWithImpl(this._self, this._then);

  final AppointmentHost _self;
  final $Res Function(AppointmentHost) _then;

/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? email = freezed,Object? teacherProfile = freezed,}) {
  return _then(AppointmentHost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,teacherProfile: freezed == teacherProfile ? _self.teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as HostProfile?,
  ));
}
/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HostProfileCopyWith<$Res>? get teacherProfile {
    if (_self.teacherProfile == null) {
    return null;
  }

  return $HostProfileCopyWith<$Res>(_self.teacherProfile!, (value) {
    return _then(_self.copyWith(teacherProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppointmentHost].
extension AppointmentHostPatterns on AppointmentHost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentHost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentHost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentHost value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentHost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentHost value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentHost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String role,  String? email,  HostProfile? teacherProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentHost() when $default != null:
return $default(_that.id,_that.role,_that.email,_that.teacherProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String role,  String? email,  HostProfile? teacherProfile)  $default,) {final _that = this;
switch (_that) {
case _AppointmentHost():
return $default(_that.id,_that.role,_that.email,_that.teacherProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String role,  String? email,  HostProfile? teacherProfile)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentHost() when $default != null:
return $default(_that.id,_that.role,_that.email,_that.teacherProfile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentHost extends AppointmentHost {
  const _AppointmentHost({required this.id, required this.role, this.email, this.teacherProfile}): super._();
  factory _AppointmentHost.fromJson(Map<String, dynamic> json) => _$AppointmentHostFromJson(json);

@override final  String id;
@override final  String role;
@override final  String? email;
@override final  HostProfile? teacherProfile;

/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentHostCopyWith<_AppointmentHost> get copyWith => __$AppointmentHostCopyWithImpl<_AppointmentHost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentHostToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentHost&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email)&&(identical(other.teacherProfile, teacherProfile) || other.teacherProfile == teacherProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,role,email,teacherProfile);
}

@override
String toString() {
    return 'AppointmentHost(id: $id, role: $role, email: $email, teacherProfile: $teacherProfile)';
}


}

/// @nodoc
abstract mixin class _$AppointmentHostCopyWith<$Res> implements $AppointmentHostCopyWith<$Res> {
  factory _$AppointmentHostCopyWith(_AppointmentHost value, $Res Function(_AppointmentHost) _then) = __$AppointmentHostCopyWithImpl;
@override @useResult
$Res call({
 String id, String role, String? email, HostProfile? teacherProfile
});


@override $HostProfileCopyWith<$Res>? get teacherProfile;

}
/// @nodoc
class __$AppointmentHostCopyWithImpl<$Res>
    implements _$AppointmentHostCopyWith<$Res> {
  __$AppointmentHostCopyWithImpl(this._self, this._then);

  final _AppointmentHost _self;
  final $Res Function(_AppointmentHost) _then;

/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? email = freezed,Object? teacherProfile = freezed,}) {
  return _then(_AppointmentHost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,teacherProfile: freezed == teacherProfile ? _self.teacherProfile : teacherProfile // ignore: cast_nullable_to_non_nullable
as HostProfile?,
  ));
}

/// Create a copy of AppointmentHost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HostProfileCopyWith<$Res>? get teacherProfile {
    if (_self.teacherProfile == null) {
    return null;
  }

  return $HostProfileCopyWith<$Res>(_self.teacherProfile!, (value) {
    return _then(_self.copyWith(teacherProfile: value));
  });
}
}


/// @nodoc
mixin _$Appointment {

 String get id; String get objet; DateTime get debut; DateTime get fin; String get statut; String? get lieu; AppointmentHost get hote;
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentCopyWith<Appointment> get copyWith => _$AppointmentCopyWithImpl<Appointment>(this as Appointment, _$identity);

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Appointment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.objet, _this.objet) || other.objet == _this.objet)&&(identical(other.debut, _this.debut) || other.debut == _this.debut)&&(identical(other.fin, _this.fin) || other.fin == _this.fin)&&(identical(other.statut, _this.statut) || other.statut == _this.statut)&&(identical(other.lieu, _this.lieu) || other.lieu == _this.lieu)&&(identical(other.hote, _this.hote) || other.hote == _this.hote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Appointment;
  return Object.hash(runtimeType,_this.id,_this.objet,_this.debut,_this.fin,_this.statut,_this.lieu,_this.hote);
}

@override
String toString() {
  final _this = this as Appointment;
  return 'Appointment(id: ${_this.id}, objet: ${_this.objet}, debut: ${_this.debut}, fin: ${_this.fin}, statut: ${_this.statut}, lieu: ${_this.lieu}, hote: ${_this.hote})';
}


}

/// @nodoc
abstract mixin class $AppointmentCopyWith<$Res>  {
  factory $AppointmentCopyWith(Appointment value, $Res Function(Appointment) _then) = _$AppointmentCopyWithImpl;
@useResult
$Res call({
 String id, String objet, DateTime debut, DateTime fin, String statut, String? lieu, AppointmentHost hote
});


$AppointmentHostCopyWith<$Res> get hote;

}
/// @nodoc
class _$AppointmentCopyWithImpl<$Res>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._self, this._then);

  final Appointment _self;
  final $Res Function(Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? objet = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? lieu = freezed,Object? hote = null,}) {
  return _then(Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objet: null == objet ? _self.objet : objet // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,lieu: freezed == lieu ? _self.lieu : lieu // ignore: cast_nullable_to_non_nullable
as String?,hote: null == hote ? _self.hote : hote // ignore: cast_nullable_to_non_nullable
as AppointmentHost,
  ));
}
/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentHostCopyWith<$Res> get hote {
  
  return $AppointmentHostCopyWith<$Res>(_self.hote, (value) {
    return _then(_self.copyWith(hote: value));
  });
}
}


/// Adds pattern-matching-related methods to [Appointment].
extension AppointmentPatterns on Appointment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointment value)  $default,){
final _that = this;
switch (_that) {
case _Appointment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointment value)?  $default,){
final _that = this;
switch (_that) {
case _Appointment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String objet,  DateTime debut,  DateTime fin,  String statut,  String? lieu,  AppointmentHost hote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.objet,_that.debut,_that.fin,_that.statut,_that.lieu,_that.hote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String objet,  DateTime debut,  DateTime fin,  String statut,  String? lieu,  AppointmentHost hote)  $default,) {final _that = this;
switch (_that) {
case _Appointment():
return $default(_that.id,_that.objet,_that.debut,_that.fin,_that.statut,_that.lieu,_that.hote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String objet,  DateTime debut,  DateTime fin,  String statut,  String? lieu,  AppointmentHost hote)?  $default,) {final _that = this;
switch (_that) {
case _Appointment() when $default != null:
return $default(_that.id,_that.objet,_that.debut,_that.fin,_that.statut,_that.lieu,_that.hote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointment implements Appointment {
  const _Appointment({required this.id, required this.objet, required this.debut, required this.fin, required this.statut, this.lieu, required this.hote});
  factory _Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);

@override final  String id;
@override final  String objet;
@override final  DateTime debut;
@override final  DateTime fin;
@override final  String statut;
@override final  String? lieu;
@override final  AppointmentHost hote;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentCopyWith<_Appointment> get copyWith => __$AppointmentCopyWithImpl<_Appointment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointment&&(identical(other.id, id) || other.id == id)&&(identical(other.objet, objet) || other.objet == objet)&&(identical(other.debut, debut) || other.debut == debut)&&(identical(other.fin, fin) || other.fin == fin)&&(identical(other.statut, statut) || other.statut == statut)&&(identical(other.lieu, lieu) || other.lieu == lieu)&&(identical(other.hote, hote) || other.hote == hote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,objet,debut,fin,statut,lieu,hote);
}

@override
String toString() {
    return 'Appointment(id: $id, objet: $objet, debut: $debut, fin: $fin, statut: $statut, lieu: $lieu, hote: $hote)';
}


}

/// @nodoc
abstract mixin class _$AppointmentCopyWith<$Res> implements $AppointmentCopyWith<$Res> {
  factory _$AppointmentCopyWith(_Appointment value, $Res Function(_Appointment) _then) = __$AppointmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String objet, DateTime debut, DateTime fin, String statut, String? lieu, AppointmentHost hote
});


@override $AppointmentHostCopyWith<$Res> get hote;

}
/// @nodoc
class __$AppointmentCopyWithImpl<$Res>
    implements _$AppointmentCopyWith<$Res> {
  __$AppointmentCopyWithImpl(this._self, this._then);

  final _Appointment _self;
  final $Res Function(_Appointment) _then;

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? objet = null,Object? debut = null,Object? fin = null,Object? statut = null,Object? lieu = freezed,Object? hote = null,}) {
  return _then(_Appointment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,objet: null == objet ? _self.objet : objet // ignore: cast_nullable_to_non_nullable
as String,debut: null == debut ? _self.debut : debut // ignore: cast_nullable_to_non_nullable
as DateTime,fin: null == fin ? _self.fin : fin // ignore: cast_nullable_to_non_nullable
as DateTime,statut: null == statut ? _self.statut : statut // ignore: cast_nullable_to_non_nullable
as String,lieu: freezed == lieu ? _self.lieu : lieu // ignore: cast_nullable_to_non_nullable
as String?,hote: null == hote ? _self.hote : hote // ignore: cast_nullable_to_non_nullable
as AppointmentHost,
  ));
}

/// Create a copy of Appointment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentHostCopyWith<$Res> get hote {
  
  return $AppointmentHostCopyWith<$Res>(_self.hote, (value) {
    return _then(_self.copyWith(hote: value));
  });
}
}

// dart format on
