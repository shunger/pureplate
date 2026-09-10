/// External URLs used by the app.
///
/// The legal pages must be publicly reachable before store submission: both
/// App Review and Play review check that a paywall's Terms and Privacy links
/// resolve. Source text lives in TERMS_OF_USE.md and PRIVACY_POLICY.md.
abstract class AppLinks {
  static const terms =
      'https://purehungerlabs.com/purepantry/TERMS_OF_USE.html';
  static const privacy =
      'https://purehungerlabs.com/purepantry/PRIVACY_POLICY.html';
  static const support = 'mailto:support@purehungerlabs.com';

  /// Platform subscription management. Apple and Google both require a route
  /// to these from inside the app.
  static const appleSubscriptions =
      'https://apps.apple.com/account/subscriptions';
  static const googleSubscriptions =
      'https://play.google.com/store/account/subscriptions';
}
