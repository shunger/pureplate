// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Substitution _$SubstitutionFromJson(Map<String, dynamic> json) =>
    _Substitution(
      name: json['name'] as String,
      quantity: json['quantity'] as String?,
      unit: json['unit'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$SubstitutionToJson(_Substitution instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'notes': instance.notes,
    };

_Ingredient _$IngredientFromJson(Map<String, dynamic> json) => _Ingredient(
  name: json['name'] as String,
  quantity: json['quantity'] as String?,
  unit: json['unit'] as String?,
  category: json['category'] as String?,
  optional: json['optional'] as bool? ?? false,
  substitutions:
      (json['substitutions'] as List<dynamic>?)
          ?.map((e) => Substitution.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$IngredientToJson(_Ingredient instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'category': instance.category,
      'optional': instance.optional,
      'substitutions': instance.substitutions,
    };
