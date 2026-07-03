// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  cuisine: json['cuisine'] as String?,
  imageUrl: json['imageUrl'] as String?,
  prepTimeMinutes: (json['prepTimeMinutes'] as num?)?.toInt() ?? 0,
  cookTimeMinutes: (json['cookTimeMinutes'] as num?)?.toInt() ?? 0,
  servings: (json['servings'] as num?)?.toInt() ?? 4,
  difficulty: json['difficulty'] as String?,
  ingredients:
      (json['ingredients'] as List<dynamic>?)
          ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  instructions:
      (json['instructions'] as List<dynamic>?)
          ?.map((e) => InstructionStep.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  nutrition: json['nutrition'] == null
      ? null
      : NutritionInfo.fromJson(json['nutrition'] as Map<String, dynamic>),
  isVegetarian: json['isVegetarian'] as bool? ?? false,
  isVegan: json['isVegan'] as bool? ?? false,
  isGlutenFree: json['isGlutenFree'] as bool? ?? false,
  isDairyFree: json['isDairyFree'] as bool? ?? false,
  isNutFree: json['isNutFree'] as bool? ?? false,
  source:
      $enumDecodeNullable(_$RecipeSourceEnumMap, json['source']) ??
      RecipeSource.bundled,
  aiMetadata: json['aiMetadata'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cuisine': instance.cuisine,
  'imageUrl': instance.imageUrl,
  'prepTimeMinutes': instance.prepTimeMinutes,
  'cookTimeMinutes': instance.cookTimeMinutes,
  'servings': instance.servings,
  'difficulty': instance.difficulty,
  'ingredients': instance.ingredients,
  'instructions': instance.instructions,
  'nutrition': instance.nutrition,
  'isVegetarian': instance.isVegetarian,
  'isVegan': instance.isVegan,
  'isGlutenFree': instance.isGlutenFree,
  'isDairyFree': instance.isDairyFree,
  'isNutFree': instance.isNutFree,
  'source': _$RecipeSourceEnumMap[instance.source]!,
  'aiMetadata': instance.aiMetadata,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$RecipeSourceEnumMap = {
  RecipeSource.bundled: 'bundled',
  RecipeSource.aiGenerated: 'aiGenerated',
  RecipeSource.userCreated: 'userCreated',
};
