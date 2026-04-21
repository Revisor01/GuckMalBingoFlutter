import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utilities/background_pattern_view.dart';
import '../utilities/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';
import 'parental_gate_view.dart';
import 'onboarding_view.dart';
import 'widgets/app_button.dart';

/// SettingsView - Portiert von Swift
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = packageInfo.version;
    });
  }

  Future<void> _openURL(String urlString) async {
    // Zeige Parental Gate als Bottom Sheet Modal
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => const ParentalGateView(),
      ),
    );

    // Wenn erfolgreich, öffne URL
    if (result == true) {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Öffnet die Store-Seite (App Store / Play Store) für eine Bewertung.
  /// Erst nach erfolgreichem Parental Gate — kein aufdringliches Native-Popup.
  Future<void> _openStoreListing() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => const ParentalGateView(),
      ),
    );

    if (result == true) {
      final inAppReview = InAppReview.instance;
      await inAppReview.openStoreListing(appStoreId: '6755447380');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeNotifier>().theme;
    final brightness = Theme.of(context).brightness;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: theme.adaptiveGradient(brightness),
          ),
          child: Stack(
          children: [
            const BackgroundPatternView(),
            SafeArea(
              child: Column(
                children: [
                  // Header mit Close Button
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      AppLocalizations.of(context)!.settingsTitle,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Settings Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        // Anleitung Button (oeffnet Onboarding)
                        AppButton(
                          icon: Icons.lightbulb,
                          iconSize: 28,
                          iconColor: Colors.amber,
                          title: AppLocalizations.of(context)!.settingsHelp,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: OnboardingView(
                                  showCloseButton: true,
                                  onComplete: () => Navigator.of(context).pop(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          icon: Icons.shield,
                          iconSize: 28,
                          iconColor: Colors.blue,
                          title: AppLocalizations.of(context)!.settingsPrivacy,
                          trailing: AppButton.trailingExternalLink(),
                          onTap: () => _openURL(
                            // EN-URL ist der universelle Fallback fuer alle Nicht-DE Locales
                            Localizations.localeOf(context).languageCode == 'de'
                                ? 'https://simonluthe.de/apps/guckmal/datenschutz/'
                                : 'https://simonluthe.de/apps/guckmal/privacy/',
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          icon: Icons.info,
                          iconSize: 28,
                          iconColor: Colors.green,
                          title: AppLocalizations.of(context)!.settingsImprint,
                          trailing: AppButton.trailingExternalLink(),
                          onTap: () =>
                              _openURL('https://simonluthe.de/impressum/'),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          icon: Icons.help,
                          iconSize: 28,
                          iconColor: Colors.orange,
                          title: AppLocalizations.of(context)!.settingsSupport,
                          trailing: AppButton.trailingExternalLink(),
                          onTap: () => _openURL(
                              'https://simonluthe.de/apps/guckmal/support/'),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          icon: Icons.star,
                          iconSize: 28,
                          iconColor: Colors.pinkAccent,
                          title: AppLocalizations.of(context)!.settingsRate,
                          trailing: AppButton.trailingExternalLink(),
                          onTap: _openStoreListing,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // App Info
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.appTitle} v$_version',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha:0.6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.settingsMadeWith,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha:0.6),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.flutter_dash,
                              size: 12,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.settingsInOrt,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha:0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.settingsPeaceBlessing,
                          style: TextStyle(
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withValues(alpha:0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}


