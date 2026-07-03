# PurePlate AI — Architecture Document
## "From Pantry to Table"

### Overview

PurePlate AI merges SmartShoppingScanner (pantry + shopping) with Meal Planner AI
(AI recipes + meal planning) into a single unified app. The pantry inventory is
the single source of truth that drives both shopping intelligence and AI meal
generation.

---

## 1. Folder Structure

```
pure_plate/lib/
├── main.dart
├── app.dart
├── firebase_options.dart
│
├── core/
│   ├── database/
│   │   ├── app_database.dart              # Unified Drift database
│   │   ├── app_database.g.dart            # Generated
│   │   ├── tables/                        # All table definitions
│   │   │   ├── products_table.dart
│   │   │   ├── pantry_items_table.dart
│   │   │   ├── shopping_lists_table.dart
│   │   │   ├── shopping_list_items_table.dart
│   │   │   ├── recipes_table.dart
│   │   │   ├── meal_plans_table.dart
│   │   │   ├── meal_plan_days_table.dart
│   │   │   ├── recipe_feedback_table.dart
│   │   │   ├── family_profiles_table.dart
│   │   │   ├── user_preferences_table.dart
│   │   │   ├── purchase_history_table.dart
│   │   │   ├── budgets_table.dart
│   │   │   └── activity_events_table.dart
│   │   └── daos/
│   │       ├── product_dao.dart
│   │       ├── pantry_dao.dart
│   │       ├── shopping_list_dao.dart
│   │       ├── recipe_dao.dart
│   │       ├── meal_plan_dao.dart
│   │       ├── family_profile_dao.dart
│   │       ├── user_preferences_dao.dart
│   │       ├── budget_dao.dart
│   │       └── purchase_history_dao.dart
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_urls.dart
│   │   └── asset_paths.dart
│   ├── providers/
│   │   ├── database_providers.dart        # DB + DAO providers
│   │   ├── firebase_providers.dart        # Auth, Firestore, Functions
│   │   ├── connectivity_providers.dart
│   │   └── shared_providers.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   ├── route_names.dart
│   │   └── navigation_shell.dart          # Bottom nav scaffold
│   ├── theme/
│   │   ├── app_theme.dart                 # Coral + cream palette
│   │   ├── app_colors.dart
│   │   └── text_styles.dart
│   ├── services/
│   │   ├── connectivity_service.dart
│   │   ├── notification_service.dart
│   │   ├── deep_link_service.dart
│   │   └── migration_service.dart         # Migrate from old apps
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── currency_utils.dart
│   │   ├── barcode_utils.dart
│   │   └── string_extensions.dart
│   ├── errors/
│   │   └── app_exceptions.dart
│   └── widgets/
│       ├── loading_indicator.dart
│       ├── error_card.dart
│       ├── offline_banner.dart
│       ├── section_header.dart
│       └── animated_card.dart
│
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       └── splash_screen.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── welcome_screen.dart
│   │       │   ├── family_profile_screen.dart
│   │       │   ├── dietary_screen.dart
│   │       │   └── cooking_style_screen.dart
│   │       └── providers/
│   │           └── onboarding_providers.dart
│   │
│   ├── home/                              # Dashboard
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart       # Main dashboard
│   │   │   ├── widgets/
│   │   │   │   ├── pantry_summary_card.dart
│   │   │   │   ├── whats_for_dinner_button.dart
│   │   │   │   ├── expiring_items_card.dart
│   │   │   │   ├── todays_meal_card.dart
│   │   │   │   └── quick_actions_row.dart
│   │   │   └── providers/
│   │   │       └── home_providers.dart
│   │   └── domain/
│   │       └── models/
│   │           └── dashboard_state.dart
│   │
│   ├── pantry/                            # Unified Pantry (from Scanner)
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── pantry_repository.dart
│   │   │   └── datasources/
│   │   │       ├── pantry_sync_orchestrator.dart
│   │   │       └── firestore_pantry_service.dart
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── pantry_item.dart        # Freezed model
│   │   │       └── pantry_location.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── pantry_screen.dart
│   │       │   ├── pantry_item_detail_screen.dart
│   │       │   └── add_pantry_item_screen.dart
│   │       ├── widgets/
│   │       │   ├── pantry_item_tile.dart
│   │       │   ├── expiry_badge.dart
│   │       │   ├── location_filter_chips.dart
│   │       │   └── pantry_search_bar.dart
│   │       └── providers/
│   │           └── pantry_providers.dart
│   │
│   ├── scanner/                           # Barcode Scanner (from Scanner)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── openfoodfacts_datasource.dart
│   │   │   │   ├── upc_database_datasource.dart
│   │   │   │   └── plu_database.dart
│   │   │   └── repositories/
│   │   │       └── product_repository.dart
│   │   ├── domain/
│   │   │   └── models/
│   │   │       └── product.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── scanner_screen.dart
│   │       │   └── product_search_screen.dart
│   │       ├── widgets/
│   │       │   ├── scanner_overlay.dart
│   │       │   └── product_result_card.dart
│   │       └── providers/
│   │           └── scanner_providers.dart
│   │
│   ├── meal_plan/                         # AI Meal Planner (from Meal Planner)
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── ai_plan_repository.dart
│   │   │   └── datasources/
│   │   │       └── preference_summary_builder.dart
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── meal_plan.dart
│   │   │       ├── meal_plan_day.dart
│   │   │       └── family_profile.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── planner_screen.dart     # Calendar view
│   │       │   ├── plan_generation_screen.dart
│   │       │   └── chat_screen.dart        # Chat planning
│   │       ├── widgets/
│   │       │   ├── day_meal_card.dart
│   │       │   ├── plan_calendar.dart
│   │       │   └── generation_progress.dart
│   │       └── providers/
│   │           ├── plan_generation_providers.dart
│   │           ├── chat_providers.dart
│   │           └── planner_providers.dart
│   │
│   ├── recipes/                           # Recipe Browser (from Meal Planner)
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── recipe_repository.dart
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── recipe.dart
│   │   │       ├── ingredient.dart
│   │   │       ├── instruction_step.dart
│   │   │       └── nutrition_info.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── recipe_list_screen.dart
│   │       │   ├── recipe_detail_screen.dart
│   │       │   └── inventory_suggestions_screen.dart
│   │       ├── widgets/
│   │       │   ├── recipe_card.dart
│   │       │   ├── ingredient_list.dart
│   │       │   └── feedback_buttons.dart
│   │       └── providers/
│   │           ├── recipe_providers.dart
│   │           └── feedback_providers.dart
│   │
│   ├── cooking/                           # Cooking Mode (from Meal Planner)
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── cooking_mode_screen.dart
│   │       ├── widgets/
│   │       │   ├── step_display.dart
│   │       │   └── voice_control_bar.dart
│   │       └── providers/
│   │           └── cooking_providers.dart
│   │
│   ├── shopping_list/                     # Smart Shopping (merged)
│   │   ├── data/
│   │   │   ├── repositories/
│   │   │   │   └── shopping_list_repository.dart
│   │   │   └── datasources/
│   │   │       └── auto_list_generator.dart # From meal plan
│   │   ├── domain/
│   │   │   └── models/
│   │   │       ├── shopping_list.dart
│   │   │       └── shopping_list_item.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── shopping_list_screen.dart
│   │       │   └── shopping_list_detail_screen.dart
│   │       ├── widgets/
│   │       │   ├── shopping_item_tile.dart
│   │       │   ├── auto_generated_banner.dart
│   │       │   └── category_group.dart
│   │       └── providers/
│   │           └── shopping_list_providers.dart
│   │
│   ├── sharing/                           # Family Sharing (from Scanner)
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       ├── firestore_sharing_service.dart
│   │   │       └── activity_sync_service.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── collaborators_screen.dart
│   │       │   └── activity_feed_screen.dart
│   │       └── providers/
│   │           └── sharing_providers.dart
│   │
│   ├── settings/                          # Unified Settings
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── settings_screen.dart
│   │       │   ├── profile_screen.dart
│   │       │   ├── dietary_preferences_screen.dart
│   │       │   └── notification_settings_screen.dart
│   │       └── providers/
│   │           └── settings_providers.dart
│   │
│   └── premium/                           # Premium/Subscription
│       └── presentation/
│           ├── screens/
│           │   ├── paywall_screen.dart
│           │   └── subscription_screen.dart
│           └── providers/
│               └── premium_providers.dart
│
├── shared/
│   ├── models/
│   │   ├── dietary_restriction.dart       # Shared enum
│   │   └── product_category.dart          # Shared enum
│   └── widgets/
│       ├── category_icon.dart
│       └── dietary_badge.dart
│
└── assets/
    ├── data/
    │   ├── bundled_recipes.json
    │   ├── plu_database.json
    │   └── produce_templates.json
    └── images/
        ├── logo.png
        ├── onboarding/
        └── illustrations/
```

---

## 2. Unified Data Model

### Core Principle
The **PantryItem** is the single shared entity. When you scan a barcode, it
creates a Product and optionally a PantryItem. When AI generates a meal plan,
it queries PantryItems to know what's available. When auto-shopping-list runs,
it diffs recipe ingredients against PantryItems.

### Entity Relationships
```
Product (barcode lookup, nutrition, allergens)
  │
  ├──> PantryItem (quantity, expiry, location) ──> powers AI meal suggestions
  │       │
  │       └──> used by PreferenceSummaryBuilder for AI context
  │
  ├──> ShoppingListItem (quantity, price, checked)
  │
  └──> PurchaseHistory (price trends, frequency)

FamilyProfile (dietary, cuisines, cook time, budget)
  │
  └──> PreferenceSummary (JSON blob for AI prompts)

MealPlan
  ├──> MealPlanDay ──> Recipe
  │                      ├──> Ingredient ──> matched against PantryItem
  │                      ├──> InstructionStep
  │                      └──> NutritionInfo
  │
  └──> auto-generates ShoppingList (ingredients - pantry stock)

RecipeFeedback (loved/disliked/favorite per recipe)
  └──> updates cuisine affinity scores in PreferenceSummary
```

---

## 3. Navigation

### Bottom Navigation (4 tabs)
1. **Home** — Dashboard with pantry overview + "What's for dinner?"
2. **Pantry** — Full inventory with scanner access
3. **Planner** — Weekly meal calendar + AI generation
4. **Lists** — Shopping lists (manual + auto-generated)

### Top-level Routes (no bottom nav)
- Scanner (full screen camera)
- Recipe detail
- Cooking mode
- Chat planning
- Settings / Profile / Dietary preferences
- Premium paywall
- Family sharing / Collaborators
- Activity feed

---

## 4. AI Integration Strategy

### Architecture
```
Client (Flutter)
  │
  ├── PreferenceSummaryBuilder (LOCAL, deterministic)
  │     Reads: FamilyProfile, PantryItems, RecipeFeedback, RecentMeals
  │     Outputs: JSON blob (~1500 tokens)
  │
  ├── Cloud Functions (Firebase)
  │     Security: App Check, rate limit, quota, blocklist, kill switch
  │     Routing: Calls AWS Bedrock or vLLM
  │
  └── AI Backend (swappable)
        Phase 1: AWS Bedrock (Nova Micro) — cheapest, text-only
        Phase 2: Self-hosted vLLM — cost control at scale
        Phase 3: Claude Sonnet — multimodal (photo recipes)
```

### Pantry-Aware Prompts
The key differentiator: every AI prompt includes current pantry stock.
This enables "use what you have" suggestions and minimizes waste.

```json
{
  "pantry_items": [
    {"name": "chicken breast", "quantity": 2, "unit": "lbs", "expires_in_days": 3},
    {"name": "rice", "quantity": 5, "unit": "lbs", "expires_in_days": null},
    {"name": "bell peppers", "quantity": 4, "unit": "count", "expires_in_days": 5}
  ],
  "expiring_soon": ["chicken breast", "bell peppers"],
  "staples_available": ["olive oil", "salt", "pepper", "garlic", "onions"],
  "family": {"adults": 2, "kids": 1, "dietary": ["gluten-free"]},
  "cuisine_affinities": {"italian": 0.8, "mexican": 0.7, "asian": 0.6},
  "disliked_ingredients": ["cilantro", "mushrooms"],
  "recent_meals_14d": ["pasta primavera", "tacos", "stir fry"]
}
```

---

## 5. Migration Strategy

### Phase 1: Project Setup
- Create new Flutter project `pure_plate`
- Set up Firebase project (new or reuse scanner's)
- Configure shared dependencies

### Phase 2: Core Infrastructure
- Port unified Drift database with all tables
- Port Riverpod providers and core services
- Set up GoRouter with new navigation structure

### Phase 3: Feature Migration (parallel tracks)
- **Track A**: Port pantry + scanner + shopping from SmartShoppingScanner
- **Track B**: Port meal plan + recipes + AI from meal_planner_ai
- **Track C**: Build new Home dashboard + integration glue

### Phase 4: Integration Points
- Connect pantry data to PreferenceSummaryBuilder
- Build auto-shopping-list from meal plan + pantry diff
- Wire "What's for dinner?" to pantry-aware AI generation

### Phase 5: Polish
- Unified theme (coral + cream)
- Unified onboarding (combined family + pantry setup)
- Data migration from old apps (detect installed, import local DB)

---

## 6. Potential Challenges

| Challenge | Solution |
|-----------|----------|
| Two separate Drift schemas | Build new unified schema; write migration scripts that import from either old DB |
| Shopping list model differences | Scanner's model is richer (price, sale, store); use that as base, add `source` field (manual/ai_generated) |
| Pantry vs Inventory mismatch | Scanner has structured PantryItem with product FK; Meal Planner has free-text. Unify on Scanner's model, add fuzzy matching for AI ingredient→pantry lookups |
| Firebase project conflict | Use Scanner's Firebase project (more mature); migrate Meal Planner's Cloud Functions into it |
| Offline AI fallback | Bundled recipes (25+) serve as offline meal suggestions; local pantry matching without AI |
| Performance with large pantry | Index pantry by category + expiry; limit AI context to top-50 items by relevance |
| Family sync conflicts | Last-write-wins with `updatedBy` echo suppression (already in Scanner) |
| App size | Tree-shake unused features; lazy-load scanner camera; defer AI model assets |
