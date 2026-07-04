/// Application-wide constants for the Pure Pantry AI app.
abstract class AppConstants {
  // ---------------------------------------------------------------------------
  // API URLs
  // ---------------------------------------------------------------------------
  static const String openFoodFactsBaseUrl =
      'https://world.openfoodfacts.org/api/v0/product';
  static const String upcDatabaseBaseUrl =
      'https://api.upcitemdb.com/prod/trial/lookup';
  static const String openFoodFactsSearchUrl =
      'https://world.openfoodfacts.org/cgi/search.pl';

  // ---------------------------------------------------------------------------
  // Timeouts & Retry
  // ---------------------------------------------------------------------------
  static const int defaultTimeoutSeconds = 30;
  static const Duration defaultTimeout =
      Duration(seconds: defaultTimeoutSeconds);
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;
  static const Duration retryDelay = Duration(milliseconds: retryDelayMs);
  static const int cacheTtlHours = 24;
  static const Duration cacheTtl = Duration(hours: cacheTtlHours);

  // ---------------------------------------------------------------------------
  // Limits
  // ---------------------------------------------------------------------------
  static const int maxRecentPlu = 20;
  static const int maxSearchResults = 20;
  static const Duration productSearchDebounce = Duration(milliseconds: 300);
}
