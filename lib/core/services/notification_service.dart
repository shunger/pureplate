import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles FCM token registration and local notification channel setup.
///
/// Channels:
/// - Expiry Alerts: pantry items expiring soon
/// - Sharing Events: family member added/removed items
/// - Reorder Alerts: staples running low
class NotificationService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  static const _expiryChannelId = 'expiry_alerts';
  static const _sharingChannelId = 'sharing_events';
  static const _reorderChannelId = 'reorder_alerts';

  NotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  /// Initialize notifications: request permissions, set up channels,
  /// configure FCM foreground handling.
  Future<void> initialize() async {
    // Request permission (iOS + Android 13+).
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize local notifications plugin.
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already requested via FCM above.
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create Android notification channels.
    await _createChannels();

    // Handle foreground FCM messages as local notifications.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Log FCM token for debugging.
    final token = await _messaging.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<void> _createChannels() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _expiryChannelId,
        'Expiry Alerts',
        description: 'Notifications when pantry items are expiring soon',
        importance: Importance.high,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _sharingChannelId,
        'Sharing Events',
        description: 'Notifications when family members update shared lists',
        importance: Importance.defaultImportance,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _reorderChannelId,
        'Reorder Alerts',
        description: 'Notifications when staple items are running low',
        importance: Importance.defaultImportance,
      ),
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    // Determine channel based on FCM data payload.
    final channelId = _channelForType(message.data['type'] as String?);

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId == _expiryChannelId
              ? 'Expiry Alerts'
              : channelId == _sharingChannelId
                  ? 'Sharing Events'
                  : 'Reorder Alerts',
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  String _channelForType(String? type) {
    switch (type) {
      case 'expiry':
        return _expiryChannelId;
      case 'sharing':
        return _sharingChannelId;
      case 'reorder':
        return _reorderChannelId;
      default:
        return _expiryChannelId;
    }
  }
}
