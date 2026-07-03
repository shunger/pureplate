// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Recipe {

 String get id; String get name; String? get description; String? get cuisine; String? get imageUrl;/// Timing.
 int get prepTimeMinutes; int get cookTimeMinutes; int get servings; String? get difficulty;/// Structured data.
 List<Ingredient> get ingredients; List<InstructionStep> get instructions; NutritionInfo? get nutrition;/// Dietary flags (derived from ingredients or set by AI).
 bool get isVegetarian; bool get isVegan; bool get isGlutenFree; bool get isDairyFree; bool get isNutFree;/// Source tracking.
 RecipeSource get source; Map<String, dynamic>? get aiMetadata;/// Timestamps.
 DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecipeCopyWith<Recipe> get copyWith => _$RecipeCopyWithImpl<Recipe>(this as Recipe, _$identity);

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.prepTimeMinutes, prepTimeMinutes) || other.prepTimeMinutes == prepTimeMinutes)&&(identical(other.cookTimeMinutes, cookTimeMinutes) || other.cookTimeMinutes == cookTimeMinutes)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.ingredients, ingredients)&&const DeepCollectionEquality().equals(other.instructions, instructions)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&(identical(other.isDairyFree, isDairyFree) || other.isDairyFree == isDairyFree)&&(identical(other.isNutFree, isNutFree) || other.isNutFree == isNutFree)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.aiMetadata, aiMetadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,cuisine,imageUrl,prepTimeMinutes,cookTimeMinutes,servings,difficulty,const DeepCollectionEquality().hash(ingredients),const DeepCollectionEquality().hash(instructions),nutrition,isVegetarian,isVegan,isGlutenFree,isDairyFree,isNutFree,source,const DeepCollectionEquality().hash(aiMetadata),createdAt,updatedAt]);

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, cuisine: $cuisine, imageUrl: $imageUrl, prepTimeMinutes: $prepTimeMinutes, cookTimeMinutes: $cookTimeMinutes, servings: $servings, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, nutrition: $nutrition, isVegetarian: $isVegetarian, isVegan: $isVegan, isGlutenFree: $isGlutenFree, isDairyFree: $isDairyFree, isNutFree: $isNutFree, source: $source, aiMetadata: $aiMetadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RecipeCopyWith<$Res>  {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) _then) = _$RecipeCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? cuisine, String? imageUrl, int prepTimeMinutes, int cookTimeMinutes, int servings, String? difficulty, List<Ingredient> ingredients, List<InstructionStep> instructions, NutritionInfo? nutrition, bool isVegetarian, bool isVegan, bool isGlutenFree, bool isDairyFree, bool isNutFree, RecipeSource source, Map<String, dynamic>? aiMetadata, DateTime createdAt, DateTime? updatedAt
});


$NutritionInfoCopyWith<$Res>? get nutrition;

}
/// @nodoc
class _$RecipeCopyWithImpl<$Res>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._self, this._then);

  final Recipe _self;
  final $Res Function(Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? cuisine = freezed,Object? imageUrl = freezed,Object? prepTimeMinutes = null,Object? cookTimeMinutes = null,Object? servings = null,Object? difficulty = freezed,Object? ingredients = null,Object? instructions = null,Object? nutrition = freezed,Object? isVegetarian = null,Object? isVegan = null,Object? isGlutenFree = null,Object? isDairyFree = null,Object? isNutFree = null,Object? source = null,Object? aiMetadata = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cuisine: freezed == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,prepTimeMinutes: null == prepTimeMinutes ? _self.prepTimeMinutes : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,cookTimeMinutes: null == cookTimeMinutes ? _self.cookTimeMinutes : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<InstructionStep>,nutrition: freezed == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionInfo?,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,isDairyFree: null == isDairyFree ? _self.isDairyFree : isDairyFree // ignore: cast_nullable_to_non_nullable
as bool,isNutFree: null == isNutFree ? _self.isNutFree : isNutFree // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as RecipeSource,aiMetadata: freezed == aiMetadata ? _self.aiMetadata : aiMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionInfoCopyWith<$Res>? get nutrition {
    if (_self.nutrition == null) {
    return null;
  }

  return $NutritionInfoCopyWith<$Res>(_self.nutrition!, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [Recipe].
extension RecipePatterns on Recipe {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recipe value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recipe value)  $default,){
final _that = this;
switch (_that) {
case _Recipe():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recipe value)?  $default,){
final _that = this;
switch (_that) {
case _Recipe() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? cuisine,  String? imageUrl,  int prepTimeMinutes,  int cookTimeMinutes,  int servings,  String? difficulty,  List<Ingredient> ingredients,  List<InstructionStep> instructions,  NutritionInfo? nutrition,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  bool isDairyFree,  bool isNutFree,  RecipeSource source,  Map<String, dynamic>? aiMetadata,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.cuisine,_that.imageUrl,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.servings,_that.difficulty,_that.ingredients,_that.instructions,_that.nutrition,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.isDairyFree,_that.isNutFree,_that.source,_that.aiMetadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? cuisine,  String? imageUrl,  int prepTimeMinutes,  int cookTimeMinutes,  int servings,  String? difficulty,  List<Ingredient> ingredients,  List<InstructionStep> instructions,  NutritionInfo? nutrition,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  bool isDairyFree,  bool isNutFree,  RecipeSource source,  Map<String, dynamic>? aiMetadata,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Recipe():
return $default(_that.id,_that.name,_that.description,_that.cuisine,_that.imageUrl,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.servings,_that.difficulty,_that.ingredients,_that.instructions,_that.nutrition,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.isDairyFree,_that.isNutFree,_that.source,_that.aiMetadata,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? cuisine,  String? imageUrl,  int prepTimeMinutes,  int cookTimeMinutes,  int servings,  String? difficulty,  List<Ingredient> ingredients,  List<InstructionStep> instructions,  NutritionInfo? nutrition,  bool isVegetarian,  bool isVegan,  bool isGlutenFree,  bool isDairyFree,  bool isNutFree,  RecipeSource source,  Map<String, dynamic>? aiMetadata,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Recipe() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.cuisine,_that.imageUrl,_that.prepTimeMinutes,_that.cookTimeMinutes,_that.servings,_that.difficulty,_that.ingredients,_that.instructions,_that.nutrition,_that.isVegetarian,_that.isVegan,_that.isGlutenFree,_that.isDairyFree,_that.isNutFree,_that.source,_that.aiMetadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Recipe extends Recipe {
  const _Recipe({required this.id, required this.name, this.description, this.cuisine, this.imageUrl, this.prepTimeMinutes = 0, this.cookTimeMinutes = 0, this.servings = 4, this.difficulty, final  List<Ingredient> ingredients = const [], final  List<InstructionStep> instructions = const [], this.nutrition, this.isVegetarian = false, this.isVegan = false, this.isGlutenFree = false, this.isDairyFree = false, this.isNutFree = false, this.source = RecipeSource.bundled, final  Map<String, dynamic>? aiMetadata, required this.createdAt, this.updatedAt}): _ingredients = ingredients,_instructions = instructions,_aiMetadata = aiMetadata,super._();
  factory _Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? cuisine;
@override final  String? imageUrl;
/// Timing.
@override@JsonKey() final  int prepTimeMinutes;
@override@JsonKey() final  int cookTimeMinutes;
@override@JsonKey() final  int servings;
@override final  String? difficulty;
/// Structured data.
 final  List<Ingredient> _ingredients;
/// Structured data.
@override@JsonKey() List<Ingredient> get ingredients {
  if (_ingredients is EqualUnmodifiableListView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ingredients);
}

 final  List<InstructionStep> _instructions;
@override@JsonKey() List<InstructionStep> get instructions {
  if (_instructions is EqualUnmodifiableListView) return _instructions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_instructions);
}

@override final  NutritionInfo? nutrition;
/// Dietary flags (derived from ingredients or set by AI).
@override@JsonKey() final  bool isVegetarian;
@override@JsonKey() final  bool isVegan;
@override@JsonKey() final  bool isGlutenFree;
@override@JsonKey() final  bool isDairyFree;
@override@JsonKey() final  bool isNutFree;
/// Source tracking.
@override@JsonKey() final  RecipeSource source;
 final  Map<String, dynamic>? _aiMetadata;
@override Map<String, dynamic>? get aiMetadata {
  final value = _aiMetadata;
  if (value == null) return null;
  if (_aiMetadata is EqualUnmodifiableMapView) return _aiMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Timestamps.
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecipeCopyWith<_Recipe> get copyWith => __$RecipeCopyWithImpl<_Recipe>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecipeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recipe&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.cuisine, cuisine) || other.cuisine == cuisine)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.prepTimeMinutes, prepTimeMinutes) || other.prepTimeMinutes == prepTimeMinutes)&&(identical(other.cookTimeMinutes, cookTimeMinutes) || other.cookTimeMinutes == cookTimeMinutes)&&(identical(other.servings, servings) || other.servings == servings)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients)&&const DeepCollectionEquality().equals(other._instructions, _instructions)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.isVegetarian, isVegetarian) || other.isVegetarian == isVegetarian)&&(identical(other.isVegan, isVegan) || other.isVegan == isVegan)&&(identical(other.isGlutenFree, isGlutenFree) || other.isGlutenFree == isGlutenFree)&&(identical(other.isDairyFree, isDairyFree) || other.isDairyFree == isDairyFree)&&(identical(other.isNutFree, isNutFree) || other.isNutFree == isNutFree)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._aiMetadata, _aiMetadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,cuisine,imageUrl,prepTimeMinutes,cookTimeMinutes,servings,difficulty,const DeepCollectionEquality().hash(_ingredients),const DeepCollectionEquality().hash(_instructions),nutrition,isVegetarian,isVegan,isGlutenFree,isDairyFree,isNutFree,source,const DeepCollectionEquality().hash(_aiMetadata),createdAt,updatedAt]);

@override
String toString() {
  return 'Recipe(id: $id, name: $name, description: $description, cuisine: $cuisine, imageUrl: $imageUrl, prepTimeMinutes: $prepTimeMinutes, cookTimeMinutes: $cookTimeMinutes, servings: $servings, difficulty: $difficulty, ingredients: $ingredients, instructions: $instructions, nutrition: $nutrition, isVegetarian: $isVegetarian, isVegan: $isVegan, isGlutenFree: $isGlutenFree, isDairyFree: $isDairyFree, isNutFree: $isNutFree, source: $source, aiMetadata: $aiMetadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RecipeCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$RecipeCopyWith(_Recipe value, $Res Function(_Recipe) _then) = __$RecipeCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? cuisine, String? imageUrl, int prepTimeMinutes, int cookTimeMinutes, int servings, String? difficulty, List<Ingredient> ingredients, List<InstructionStep> instructions, NutritionInfo? nutrition, bool isVegetarian, bool isVegan, bool isGlutenFree, bool isDairyFree, bool isNutFree, RecipeSource source, Map<String, dynamic>? aiMetadata, DateTime createdAt, DateTime? updatedAt
});


@override $NutritionInfoCopyWith<$Res>? get nutrition;

}
/// @nodoc
class __$RecipeCopyWithImpl<$Res>
    implements _$RecipeCopyWith<$Res> {
  __$RecipeCopyWithImpl(this._self, this._then);

  final _Recipe _self;
  final $Res Function(_Recipe) _then;

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? cuisine = freezed,Object? imageUrl = freezed,Object? prepTimeMinutes = null,Object? cookTimeMinutes = null,Object? servings = null,Object? difficulty = freezed,Object? ingredients = null,Object? instructions = null,Object? nutrition = freezed,Object? isVegetarian = null,Object? isVegan = null,Object? isGlutenFree = null,Object? isDairyFree = null,Object? isNutFree = null,Object? source = null,Object? aiMetadata = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Recipe(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cuisine: freezed == cuisine ? _self.cuisine : cuisine // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,prepTimeMinutes: null == prepTimeMinutes ? _self.prepTimeMinutes : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,cookTimeMinutes: null == cookTimeMinutes ? _self.cookTimeMinutes : cookTimeMinutes // ignore: cast_nullable_to_non_nullable
as int,servings: null == servings ? _self.servings : servings // ignore: cast_nullable_to_non_nullable
as int,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as List<Ingredient>,instructions: null == instructions ? _self._instructions : instructions // ignore: cast_nullable_to_non_nullable
as List<InstructionStep>,nutrition: freezed == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as NutritionInfo?,isVegetarian: null == isVegetarian ? _self.isVegetarian : isVegetarian // ignore: cast_nullable_to_non_nullable
as bool,isVegan: null == isVegan ? _self.isVegan : isVegan // ignore: cast_nullable_to_non_nullable
as bool,isGlutenFree: null == isGlutenFree ? _self.isGlutenFree : isGlutenFree // ignore: cast_nullable_to_non_nullable
as bool,isDairyFree: null == isDairyFree ? _self.isDairyFree : isDairyFree // ignore: cast_nullable_to_non_nullable
as bool,isNutFree: null == isNutFree ? _self.isNutFree : isNutFree // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as RecipeSource,aiMetadata: freezed == aiMetadata ? _self._aiMetadata : aiMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Recipe
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionInfoCopyWith<$Res>? get nutrition {
    if (_self.nutrition == null) {
    return null;
  }

  return $NutritionInfoCopyWith<$Res>(_self.nutrition!, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

// dart format on
