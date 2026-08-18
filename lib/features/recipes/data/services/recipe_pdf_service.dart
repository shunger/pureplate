import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/models/recipe.dart';

/// Generates a styled PDF document for a [Recipe].
class RecipePdfService {
  // Brand colors.
  static final _coral = PdfColor.fromHex('#E8735A');
  static final _coralLight = PdfColor.fromHex('#F4A293');
  static final _sage = PdfColor.fromHex('#8BAF7C');
  static final _textPrimary = PdfColor.fromHex('#2D2016');
  static final _textSecondary = PdfColor.fromHex('#6B5E54');

  /// Builds a multi-page PDF for the given [recipe] and returns the raw bytes.
  Future<Uint8List> generatePdf(Recipe recipe) async {
    final pdf = pw.Document(
      title: recipe.name,
      author: 'Pure Pantry',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(40),
        footer: _buildFooter,
        build: (context) => [
          _buildHeader(recipe),
          _buildMetaRow(recipe),
          _buildDietaryBadges(recipe),
          _buildIngredients(recipe),
          _buildInstructions(recipe),
          if (recipe.nutrition != null) _buildNutrition(recipe),
        ],
      ),
    );

    return pdf.save();
  }

  // ── Header ──────────────────────────────────────────────

  pw.Widget _buildHeader(Recipe recipe) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          recipe.name,
          style: pw.TextStyle(
            fontSize: 26,
            fontWeight: pw.FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        if (recipe.description != null) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            recipe.description!,
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
              color: _textSecondary,
            ),
          ),
        ],
        if (recipe.cuisine != null) ...[
          pw.SizedBox(height: 4),
          pw.Text(
            recipe.cuisine!,
            style: pw.TextStyle(fontSize: 11, color: _textSecondary),
          ),
        ],
        pw.SizedBox(height: 12),
        pw.Divider(color: _coralLight, thickness: 1.5),
        pw.SizedBox(height: 12),
      ],
    );
  }

  // ── Meta row ────────────────────────────────────────────

  pw.Widget _buildMetaRow(Recipe recipe) {
    final items = <_MetaEntry>[];

    if (recipe.prepTimeMinutes > 0) {
      items.add(_MetaEntry('Prep', '${recipe.prepTimeMinutes}m'));
    }
    if (recipe.cookTimeMinutes > 0) {
      items.add(_MetaEntry('Cook', '${recipe.cookTimeMinutes}m'));
    }
    if (recipe.totalTimeMinutes > 0) {
      items.add(_MetaEntry('Total', recipe.totalTimeDisplay));
    }
    items.add(_MetaEntry('Servings', '${recipe.servings}'));
    if (recipe.difficulty != null) {
      items.add(_MetaEntry('Difficulty', recipe.difficulty!));
    }

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: items
            .map((e) => pw.Padding(
                  padding: const pw.EdgeInsets.only(right: 24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        e.label,
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: _coral,
                        ),
                      ),
                      pw.Text(
                        e.value,
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: _textPrimary,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ── Dietary badges ──────────────────────────────────────

  pw.Widget _buildDietaryBadges(Recipe recipe) {
    final badges = <String>[];
    if (recipe.isVegetarian) badges.add('Vegetarian');
    if (recipe.isVegan) badges.add('Vegan');
    if (recipe.isGlutenFree) badges.add('Gluten-Free');
    if (recipe.isDairyFree) badges.add('Dairy-Free');
    if (recipe.isNutFree) badges.add('Nut-Free');

    if (badges.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Wrap(
        spacing: 8,
        runSpacing: 6,
        children: badges
            .map((label) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: pw.BoxDecoration(
                    color: _sage,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    label,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // ── Ingredients ─────────────────────────────────────────

  pw.Widget _buildIngredients(Recipe recipe) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Ingredients'),
        pw.SizedBox(height: 6),
        ...recipe.ingredients.map((ing) {
          final parts = <String>[];
          if (ing.quantity != null && ing.quantity!.isNotEmpty) {
            parts.add(ing.quantity!);
          }
          if (ing.unit != null && ing.unit!.isNotEmpty) {
            parts.add(ing.unit!);
          }
          parts.add(ing.name);
          if (ing.optional) parts.add('(optional)');

          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 5,
                  height: 5,
                  margin: const pw.EdgeInsets.only(top: 4, right: 8),
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: _coral,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    parts.join(' '),
                    style: pw.TextStyle(fontSize: 11, color: _textPrimary),
                  ),
                ),
              ],
            ),
          );
        }),
        pw.SizedBox(height: 16),
      ],
    );
  }

  // ── Instructions ────────────────────────────────────────

  pw.Widget _buildInstructions(Recipe recipe) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Instructions'),
        pw.SizedBox(height: 6),
        ...recipe.instructions.map((step) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 22,
                  height: 22,
                  alignment: pw.Alignment.center,
                  decoration: pw.BoxDecoration(
                    color: _coral,
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Text(
                    '${step.stepNumber}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        step.instruction,
                        style: pw.TextStyle(
                          fontSize: 11,
                          color: _textPrimary,
                          lineSpacing: 3,
                        ),
                      ),
                      if (step.tip != null) ...[
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Tip: ${step.tip}',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontStyle: pw.FontStyle.italic,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        pw.SizedBox(height: 16),
      ],
    );
  }

  // ── Nutrition ───────────────────────────────────────────

  pw.Widget _buildNutrition(Recipe recipe) {
    final n = recipe.nutrition!;
    final entries = <_MetaEntry>[
      _MetaEntry('Calories', '${n.calories}'),
      _MetaEntry('Protein', '${n.proteinG.round()}g'),
      _MetaEntry('Carbs', '${n.carbsG.round()}g'),
      _MetaEntry('Fat', '${n.fatG.round()}g'),
      if (n.fiberG > 0) _MetaEntry('Fiber', '${n.fiberG.round()}g'),
      if (n.sodiumMg > 0) _MetaEntry('Sodium', '${n.sodiumMg.round()}mg'),
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _sectionTitle('Nutrition (per serving)'),
        pw.SizedBox(height: 8),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _coralLight, width: 1),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: entries
                .map((e) => pw.Column(
                      children: [
                        pw.Text(
                          e.value,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: _textPrimary,
                          ),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          e.label,
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: _textSecondary,
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ── Footer ──────────────────────────────────────────────

  pw.Widget _buildFooter(pw.Context context) {
    final date = DateFormat.yMMMd().format(DateTime.now());
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 12),
      child: pw.Text(
        'Generated by Pure Pantry  |  $date  |  Page ${context.pageNumber} of ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 8, color: _textSecondary),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────

  pw.Widget _sectionTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: _textPrimary,
      ),
    );
  }
}

class _MetaEntry {
  final String label;
  final String value;
  const _MetaEntry(this.label, this.value);
}
