import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/services/thaw_reminder_service.dart';
import '../providers/settings_providers.dart';

/// Settings screen — Account, Preferences, Notifications, Data, About.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(userPreferencesProvider);
    final profileAsync = ref.watch(familyProfileProvider);
    final version = ref.watch(appVersionProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ── Account Section ──────────────────────────────────
          _SectionHeader(title: 'Account'),
          profileAsync.when(
            loading: () => const ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Loading profile...'),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (profile) => ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.coral.withValues(alpha: 0.15),
                child:
                    const Icon(Icons.family_restroom, color: AppColors.coral),
              ),
              title: Text(profile != null
                  ? '${profile.adults} adult${profile.adults != 1 ? 's' : ''}'
                      '${profile.kids > 0 ? ', ${profile.kids} kid${profile.kids != 1 ? 's' : ''}' : ''}'
                  : 'Set up your profile'),
              subtitle: const Text('Family profile & preferences'),
              trailing:
                  Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
              onTap: () => context.push(Routes.profileEdit),
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ── Preferences Section ─────────────────────────────
          _SectionHeader(title: 'Preferences'),
          prefsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (prefs) => Column(
              children: [
                ListTile(
                  leading: Icon(Icons.attach_money,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Currency'),
                  trailing: Text(prefs.preferredCurrency,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  onTap: () => _showCurrencyPicker(context, ref, prefs.preferredCurrency),
                ),
                ListTile(
                  leading: Icon(Icons.brightness_6,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Theme'),
                  trailing: Text(
                    prefs.theme == 'system'
                        ? 'System'
                        : prefs.theme == 'dark'
                            ? 'Dark'
                            : 'Light',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  onTap: () => _showThemePicker(context, ref, prefs.theme),
                ),
                SwitchListTile(
                  secondary: Icon(Icons.volume_up,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Scan sound'),
                  value: prefs.scanSound,
                  onChanged: (v) =>
                      ref.read(preferencesDaoProvider).setScanSound(v),
                  activeColor: AppColors.coral,
                ),
                SwitchListTile(
                  secondary: Icon(Icons.vibration,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Haptic feedback'),
                  value: prefs.hapticFeedback,
                  onChanged: (v) =>
                      ref.read(preferencesDaoProvider).setHapticFeedback(v),
                  activeColor: AppColors.coral,
                ),
              ],
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ── Notifications Section ───────────────────────────
          _SectionHeader(title: 'Notifications'),
          prefsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (prefs) => Column(
              children: [
                SwitchListTile(
                  secondary: Icon(Icons.timer_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Expiry alerts'),
                  subtitle:
                      const Text('Notify when pantry items are expiring'),
                  value: prefs.notifyExpiryAlerts,
                  onChanged: (v) => ref
                      .read(preferencesDaoProvider)
                      .setNotifyExpiryAlerts(v),
                  activeColor: AppColors.coral,
                ),
                SwitchListTile(
                  secondary: Icon(Icons.group_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Sharing events'),
                  subtitle: const Text(
                      'Notify when collaborators update shared pantry'),
                  value: prefs.notifySharingEvents,
                  onChanged: (v) => ref
                      .read(preferencesDaoProvider)
                      .setNotifySharingEvents(v),
                  activeColor: AppColors.coral,
                ),
                SwitchListTile(
                  secondary: Icon(Icons.shopping_bag_outlined,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: const Text('Reorder alerts'),
                  subtitle: const Text(
                      'Notify when staple items are running low'),
                  value: prefs.notifyReorderAlerts,
                  onChanged: (v) => ref
                      .read(preferencesDaoProvider)
                      .setNotifyReorderAlerts(v),
                  activeColor: AppColors.coral,
                ),
              ],
            ),
          ),
          _ThawReminderSettings(),

          const Divider(indent: 16, endIndent: 16),

          // ── Premium Section ─────────────────────────────────
          _SectionHeader(title: 'Premium'),
          ListTile(
            leading: const Icon(Icons.workspace_premium,
                color: AppColors.coral),
            title: const Text('Pure Pantry Premium'),
            subtitle: const Text('Unlimited meal plans & more'),
            trailing:
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onTap: () => context.push(Routes.premium),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ── About Section ───────────────────────────────────
          _SectionHeader(title: 'About'),
          ListTile(
            leading:
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: const Text('Version'),
            trailing: Text(version,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          ListTile(
            leading: Icon(Icons.description_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: const Text('Licenses'),
            onTap: () => showLicensePage(context: context),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showCurrencyPicker(
      BuildContext context, WidgetRef ref, String current) {
    const currencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY'];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: currencies
            .map((c) => ListTile(
                  title: Text(c),
                  trailing:
                      c == current ? const Icon(Icons.check, color: AppColors.coral) : null,
                  onTap: () {
                    ref.read(preferencesDaoProvider).setCurrency(c);
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, String current) {
    const themes = [
      ('system', 'System'),
      ('light', 'Light'),
      ('dark', 'Dark'),
    ];
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        children: themes
            .map((t) => ListTile(
                  title: Text(t.$2),
                  trailing: t.$1 == current
                      ? const Icon(Icons.check, color: AppColors.coral)
                      : null,
                  onTap: () {
                    ref.read(preferencesDaoProvider).setTheme(t.$1);
                    Navigator.pop(ctx);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class _ThawReminderSettings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thawPrefsAsync = ref.watch(thawReminderPrefsProvider);

    return thawPrefsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (thawPrefs) => Column(
        children: [
          SwitchListTile(
            secondary: Icon(Icons.ac_unit,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: const Text('Thaw reminder (night before)'),
            subtitle: Text(
              'Remind at ${thawPrefs.nightBeforeTime.format(context)}',
            ),
            value: thawPrefs.nightBeforeEnabled,
            onChanged: (v) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                  ThawReminderService.keyNightBeforeEnabled, v);
              ref.invalidate(thawReminderPrefsProvider);
              ref.read(thawReminderServiceProvider).scheduleThawReminders();
            },
            activeColor: AppColors.coral,
          ),
          if (thawPrefs.nightBeforeEnabled)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 72, right: 16),
              title: const Text('Reminder time'),
              trailing: Text(
                thawPrefs.nightBeforeTime.format(context),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              onTap: () => _pickTime(
                context,
                ref,
                thawPrefs.nightBeforeTime,
                ThawReminderService.keyNightBeforeHour,
                ThawReminderService.keyNightBeforeMinute,
              ),
            ),
          SwitchListTile(
            secondary: Icon(Icons.wb_sunny_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            title: const Text('Thaw reminder (morning of)'),
            subtitle: Text(
              'Remind at ${thawPrefs.morningOfTime.format(context)}',
            ),
            value: thawPrefs.morningOfEnabled,
            onChanged: (v) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool(
                  ThawReminderService.keyMorningOfEnabled, v);
              ref.invalidate(thawReminderPrefsProvider);
              ref.read(thawReminderServiceProvider).scheduleThawReminders();
            },
            activeColor: AppColors.coral,
          ),
          if (thawPrefs.morningOfEnabled)
            ListTile(
              contentPadding: const EdgeInsets.only(left: 72, right: 16),
              title: const Text('Reminder time'),
              trailing: Text(
                thawPrefs.morningOfTime.format(context),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              onTap: () => _pickTime(
                context,
                ref,
                thawPrefs.morningOfTime,
                ThawReminderService.keyMorningOfHour,
                ThawReminderService.keyMorningOfMinute,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    WidgetRef ref,
    TimeOfDay current,
    String hourKey,
    String minuteKey,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
    );
    if (picked == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(hourKey, picked.hour);
    await prefs.setInt(minuteKey, picked.minute);
    ref.invalidate(thawReminderPrefsProvider);
    ref.read(thawReminderServiceProvider).scheduleThawReminders();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
