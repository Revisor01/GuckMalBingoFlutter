import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/background_theme.dart';
import '../utilities/background_pattern_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../l10n/app_localizations.dart';
import 'parental_gate_view.dart';
import 'onboarding_view.dart';

/// SettingsView - Portiert von Swift
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late BackgroundTheme _selectedTheme;
  bool _themeLoaded = false;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadVersion();
  }

  Future<void> _loadTheme() async {
    final theme = await BackgroundTheme.loadSavedTheme();
    if (!mounted) return;
    setState(() {
      _selectedTheme = theme;
      _themeLoaded = true;
    });
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = '${packageInfo.version} (${packageInfo.buildNumber})';
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

  @override
  Widget build(BuildContext context) {
    if (!_themeLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final brightness = Theme.of(context).brightness;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(30),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: _selectedTheme.adaptiveGradient(brightness),
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
                        // Anleitung Button (öffnet Onboarding)
                        SettingsButton(
                          icon: Icons.lightbulb,
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
                        SettingsLinkButton(
                          icon: Icons.shield,
                          iconColor: Colors.blue,
                          title: AppLocalizations.of(context)!.settingsPrivacy,
                          onTap: () =>
                              _openURL('https://simonluthe.de/guckmal/datenschutz/'),
                        ),
                        const SizedBox(height: 16),
                        SettingsLinkButton(
                          icon: Icons.info,
                          iconColor: Colors.green,
                          title: AppLocalizations.of(context)!.settingsImprint,
                          onTap: () =>
                              _openURL('https://simonluthe.de/impressum/'),
                        ),
                        const SizedBox(height: 16),
                        SettingsLinkButton(
                          icon: Icons.help,
                          iconColor: Colors.orange,
                          title: AppLocalizations.of(context)!.settingsSupport,
                          onTap: () =>
                              _openURL('https://simonluthe.de/guckmal/support/'),
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
                          AppLocalizations.of(context)!.appTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Version $_version',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha:0.7),
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
                              Icons.favorite,
                              size: 10,
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


/// Settings Button (ohne externen Link-Pfeil)
class SettingsButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const SettingsButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Settings Link Button
class SettingsLinkButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const SettingsLinkButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: brightness == Brightness.dark
                ? Colors.white.withValues(alpha:0.15)
                : Colors.white.withValues(alpha:0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const SizedBox(width: 24),
              Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 20,
                color: Colors.white.withValues(alpha:0.5),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}
