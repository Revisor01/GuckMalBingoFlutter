import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Guck mal!'**
  String get appTitle;

  /// No description provided for @areaAutobahn.
  ///
  /// In de, this message translates to:
  /// **'Auf der Autobahn'**
  String get areaAutobahn;

  /// No description provided for @areaKirche.
  ///
  /// In de, this message translates to:
  /// **'In der Kirche'**
  String get areaKirche;

  /// No description provided for @areaLand.
  ///
  /// In de, this message translates to:
  /// **'Auf dem Land'**
  String get areaLand;

  /// No description provided for @areaSelectionQuestion.
  ///
  /// In de, this message translates to:
  /// **'Wo bist du unterwegs?'**
  String get areaSelectionQuestion;

  /// No description provided for @areaStadt.
  ///
  /// In de, this message translates to:
  /// **'In der Stadt'**
  String get areaStadt;

  /// No description provided for @areaZoo.
  ///
  /// In de, this message translates to:
  /// **'Im Zoo'**
  String get areaZoo;

  /// No description provided for @areaZuHause.
  ///
  /// In de, this message translates to:
  /// **'Zu Hause'**
  String get areaZuHause;

  /// No description provided for @areaZug.
  ///
  /// In de, this message translates to:
  /// **'Mit dem Zug'**
  String get areaZug;

  /// No description provided for @bingoDouble.
  ///
  /// In de, this message translates to:
  /// **'🎊 DOPPEL-BINGO! 🎊'**
  String get bingoDouble;

  /// No description provided for @bingoFinal.
  ///
  /// In de, this message translates to:
  /// **'🏆 GEWONNEN! 🏆'**
  String get bingoFinal;

  /// No description provided for @bingoMultiple.
  ///
  /// In de, this message translates to:
  /// **'⭐ %lldx BINGO! ⭐'**
  String get bingoMultiple;

  /// No description provided for @bingoSingle.
  ///
  /// In de, this message translates to:
  /// **'🎉 BINGO! 🎉'**
  String get bingoSingle;

  /// No description provided for @bingoTriple.
  ///
  /// In de, this message translates to:
  /// **'🌟 TRIPEL-BINGO! 🌟'**
  String get bingoTriple;

  /// No description provided for @buttonContinue.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get buttonContinue;

  /// No description provided for @categoryBesondereOrte.
  ///
  /// In de, this message translates to:
  /// **'Orte'**
  String get categoryBesondereOrte;

  /// No description provided for @categoryBesondereOrteDescription.
  ///
  /// In de, this message translates to:
  /// **'Entdecke besondere Orte wie Kirche, Zuhause oder Zoo'**
  String get categoryBesondereOrteDescription;

  /// No description provided for @categoryReise.
  ///
  /// In de, this message translates to:
  /// **'Reise'**
  String get categoryReise;

  /// No description provided for @categoryReiseDescription.
  ///
  /// In de, this message translates to:
  /// **'Entdecke Dinge auf deiner Reise in der Stadt, auf dem Land oder der Autobahn'**
  String get categoryReiseDescription;

  /// No description provided for @categorySelectionQuestion.
  ///
  /// In de, this message translates to:
  /// **'Welches Thema möchtest du?'**
  String get categorySelectionQuestion;

  /// No description provided for @einfachIntuitiv.
  ///
  /// In de, this message translates to:
  /// **'Einfach & Intuitiv'**
  String get einfachIntuitiv;

  /// No description provided for @emptyKey.
  ///
  /// In de, this message translates to:
  /// **'🎺'**
  String get emptyKey;

  /// No description provided for @entwickeltVonSimonMitTjelle4UndKeke2.
  ///
  /// In de, this message translates to:
  /// **'Entwickelt von Simon\nmit Tjelle (4) und Keke (2)'**
  String get entwickeltVonSimonMitTjelle4UndKeke2;

  /// No description provided for @familie.
  ///
  /// In de, this message translates to:
  /// **'Familie'**
  String get familie;

  /// No description provided for @findeUnbegrenztVieleDingeUndErkundeDeineUmgebung.
  ///
  /// In de, this message translates to:
  /// **'Finde unbegrenzt viele Dinge\nund erkunde deine Umgebung!'**
  String get findeUnbegrenztVieleDingeUndErkundeDeineUmgebung;

  /// No description provided for @gameSoundOff.
  ///
  /// In de, this message translates to:
  /// **'Ton aus'**
  String get gameSoundOff;

  /// No description provided for @gameSoundOn.
  ///
  /// In de, this message translates to:
  /// **'Ton an'**
  String get gameSoundOn;

  /// No description provided for @gameTextOff.
  ///
  /// In de, this message translates to:
  /// **'Text aus'**
  String get gameTextOff;

  /// No description provided for @gameTextOn.
  ///
  /// In de, this message translates to:
  /// **'Text an'**
  String get gameTextOn;

  /// No description provided for @gameYourBingos.
  ///
  /// In de, this message translates to:
  /// **'Deine Bingos:'**
  String get gameYourBingos;

  /// No description provided for @gamemodeJagdDescription.
  ///
  /// In de, this message translates to:
  /// **'Spielt gemeinsam oder gegeneinander. Ihr stellt ein wie viele Bingos man erreichen muss um zu gewinnen.'**
  String get gamemodeJagdDescription;

  /// No description provided for @gamemodeJagdName.
  ///
  /// In de, this message translates to:
  /// **'Bingo Jagd'**
  String get gamemodeJagdName;

  /// No description provided for @gamemodeSelectionQuestion.
  ///
  /// In de, this message translates to:
  /// **'Welches Spiel möchtest du spielen?'**
  String get gamemodeSelectionQuestion;

  /// No description provided for @gamemodeSucheDescription.
  ///
  /// In de, this message translates to:
  /// **'Sammle so viele Bingos wie du willst. Suche gemeinsam oder alleine.'**
  String get gamemodeSucheDescription;

  /// No description provided for @gamemodeSucheName.
  ///
  /// In de, this message translates to:
  /// **'Guck mal!'**
  String get gamemodeSucheName;

  /// No description provided for @guckMal.
  ///
  /// In de, this message translates to:
  /// **'Guck mal!'**
  String get guckMal;

  /// No description provided for @idealFuerBewusstenMedienkonsumUnterwegs.
  ///
  /// In de, this message translates to:
  /// **'Ideal für bewussten Medienkonsum unterwegs'**
  String get idealFuerBewusstenMedienkonsumUnterwegs;

  /// No description provided for @itemAdventskranz.
  ///
  /// In de, this message translates to:
  /// **'Adventskranz'**
  String get itemAdventskranz;

  /// No description provided for @itemAffe.
  ///
  /// In de, this message translates to:
  /// **'Affe'**
  String get itemAffe;

  /// No description provided for @itemAltar.
  ///
  /// In de, this message translates to:
  /// **'Altar'**
  String get itemAltar;

  /// No description provided for @itemAmpel.
  ///
  /// In de, this message translates to:
  /// **'Ampel'**
  String get itemAmpel;

  /// No description provided for @itemAnhaenger.
  ///
  /// In de, this message translates to:
  /// **'Anhänger'**
  String get itemAnhaenger;

  /// No description provided for @itemAra.
  ///
  /// In de, this message translates to:
  /// **'Ara'**
  String get itemAra;

  /// No description provided for @itemAusfahrt.
  ///
  /// In de, this message translates to:
  /// **'Ausfahrt'**
  String get itemAusfahrt;

  /// No description provided for @itemBagger.
  ///
  /// In de, this message translates to:
  /// **'Bagger'**
  String get itemBagger;

  /// No description provided for @itemBahnhof.
  ///
  /// In de, this message translates to:
  /// **'Bahnhof'**
  String get itemBahnhof;

  /// No description provided for @itemBall.
  ///
  /// In de, this message translates to:
  /// **'Ball'**
  String get itemBall;

  /// No description provided for @itemBaum.
  ///
  /// In de, this message translates to:
  /// **'Baum'**
  String get itemBaum;

  /// No description provided for @itemBaustelle.
  ///
  /// In de, this message translates to:
  /// **'Baustelle'**
  String get itemBaustelle;

  /// No description provided for @itemBesteck.
  ///
  /// In de, this message translates to:
  /// **'Besteck'**
  String get itemBesteck;

  /// No description provided for @itemBesucherinnen.
  ///
  /// In de, this message translates to:
  /// **'Besucherinnen'**
  String get itemBesucherinnen;

  /// No description provided for @itemBett.
  ///
  /// In de, this message translates to:
  /// **'Bett'**
  String get itemBett;

  /// No description provided for @itemBibel.
  ///
  /// In de, this message translates to:
  /// **'Bibel'**
  String get itemBibel;

  /// No description provided for @itemBild.
  ///
  /// In de, this message translates to:
  /// **'Bild'**
  String get itemBild;

  /// No description provided for @itemBison.
  ///
  /// In de, this message translates to:
  /// **'Bison'**
  String get itemBison;

  /// No description provided for @itemBlauesAuto.
  ///
  /// In de, this message translates to:
  /// **'Blaues Auto'**
  String get itemBlauesAuto;

  /// No description provided for @itemBlauesSchild.
  ///
  /// In de, this message translates to:
  /// **'Blaues Schild'**
  String get itemBlauesSchild;

  /// No description provided for @itemBlumen.
  ///
  /// In de, this message translates to:
  /// **'Blumen'**
  String get itemBlumen;

  /// No description provided for @itemBlumenZuhause.
  ///
  /// In de, this message translates to:
  /// **'Blumen'**
  String get itemBlumenZuhause;

  /// No description provided for @itemBraunbaer.
  ///
  /// In de, this message translates to:
  /// **'Braunbär'**
  String get itemBraunbaer;

  /// No description provided for @itemBriefkasten.
  ///
  /// In de, this message translates to:
  /// **'Briefkasten'**
  String get itemBriefkasten;

  /// No description provided for @itemBruecke.
  ///
  /// In de, this message translates to:
  /// **'Brücke'**
  String get itemBruecke;

  /// No description provided for @itemBuch.
  ///
  /// In de, this message translates to:
  /// **'Buch'**
  String get itemBuch;

  /// No description provided for @itemBuntglasfenster.
  ///
  /// In de, this message translates to:
  /// **'Buntglasfenster'**
  String get itemBuntglasfenster;

  /// No description provided for @itemBuntstifte.
  ///
  /// In de, this message translates to:
  /// **'Buntstifte'**
  String get itemBuntstifte;

  /// No description provided for @itemBus.
  ///
  /// In de, this message translates to:
  /// **'Bus'**
  String get itemBus;

  /// No description provided for @itemBushaltestelle.
  ///
  /// In de, this message translates to:
  /// **'Bushaltestelle'**
  String get itemBushaltestelle;

  /// No description provided for @itemCafe.
  ///
  /// In de, this message translates to:
  /// **'Café'**
  String get itemCafe;

  /// No description provided for @itemCamper.
  ///
  /// In de, this message translates to:
  /// **'Camper'**
  String get itemCamper;

  /// No description provided for @itemChriststollen.
  ///
  /// In de, this message translates to:
  /// **'Christstollen'**
  String get itemChriststollen;

  /// No description provided for @itemController.
  ///
  /// In de, this message translates to:
  /// **'Controller'**
  String get itemController;

  /// No description provided for @itemDudubox.
  ///
  /// In de, this message translates to:
  /// **'DuDu-Box'**
  String get itemDudubox;

  /// No description provided for @itemEisbaer.
  ///
  /// In de, this message translates to:
  /// **'Eisbär'**
  String get itemEisbaer;

  /// No description provided for @itemEisenbahn.
  ///
  /// In de, this message translates to:
  /// **'Eisenbahn'**
  String get itemEisenbahn;

  /// No description provided for @itemElefant.
  ///
  /// In de, this message translates to:
  /// **'Elefant'**
  String get itemElefant;

  /// No description provided for @itemEmpore.
  ///
  /// In de, this message translates to:
  /// **'Empore'**
  String get itemEmpore;

  /// No description provided for @itemEngel.
  ///
  /// In de, this message translates to:
  /// **'Engel'**
  String get itemEngel;

  /// No description provided for @itemErntekrone.
  ///
  /// In de, this message translates to:
  /// **'Erntekrone'**
  String get itemErntekrone;

  /// No description provided for @itemEscooter.
  ///
  /// In de, this message translates to:
  /// **'E-Scooter'**
  String get itemEscooter;

  /// No description provided for @itemFahrrad.
  ///
  /// In de, this message translates to:
  /// **'Fahrrad'**
  String get itemFahrrad;

  /// No description provided for @itemFeld.
  ///
  /// In de, this message translates to:
  /// **'Feld'**
  String get itemFeld;

  /// No description provided for @itemFenster.
  ///
  /// In de, this message translates to:
  /// **'Fenster'**
  String get itemFenster;

  /// No description provided for @itemFernseher.
  ///
  /// In de, this message translates to:
  /// **'Fernseher'**
  String get itemFernseher;

  /// No description provided for @itemFeuerwehrauto.
  ///
  /// In de, this message translates to:
  /// **'Feuerwehrauto'**
  String get itemFeuerwehrauto;

  /// No description provided for @itemFisch.
  ///
  /// In de, this message translates to:
  /// **'Fisch'**
  String get itemFisch;

  /// No description provided for @itemFlamingo.
  ///
  /// In de, this message translates to:
  /// **'Flamingo'**
  String get itemFlamingo;

  /// No description provided for @itemFlugzeug.
  ///
  /// In de, this message translates to:
  /// **'Flugzeug'**
  String get itemFlugzeug;

  /// No description provided for @itemFluss.
  ///
  /// In de, this message translates to:
  /// **'Fluss'**
  String get itemFluss;

  /// No description provided for @itemGelbesAuto.
  ///
  /// In de, this message translates to:
  /// **'Gelbes Auto'**
  String get itemGelbesAuto;

  /// No description provided for @itemGelbesSchild.
  ///
  /// In de, this message translates to:
  /// **'Gelbes Schild'**
  String get itemGelbesSchild;

  /// No description provided for @itemGesangbuch.
  ///
  /// In de, this message translates to:
  /// **'Gesangbuch'**
  String get itemGesangbuch;

  /// No description provided for @itemGeschenke.
  ///
  /// In de, this message translates to:
  /// **'Geschenke'**
  String get itemGeschenke;

  /// No description provided for @itemGiraffe.
  ///
  /// In de, this message translates to:
  /// **'Giraffe'**
  String get itemGiraffe;

  /// No description provided for @itemGlocke.
  ///
  /// In de, this message translates to:
  /// **'Glocke'**
  String get itemGlocke;

  /// No description provided for @itemGlocken.
  ///
  /// In de, this message translates to:
  /// **'Glocken'**
  String get itemGlocken;

  /// No description provided for @itemGluehbirne.
  ///
  /// In de, this message translates to:
  /// **'Glühbirne'**
  String get itemGluehbirne;

  /// No description provided for @itemGrosseBaustelle.
  ///
  /// In de, this message translates to:
  /// **'Große Baustelle'**
  String get itemGrosseBaustelle;

  /// No description provided for @itemGruenesAuto.
  ///
  /// In de, this message translates to:
  /// **'Grünes Auto'**
  String get itemGruenesAuto;

  /// No description provided for @itemGuerteltier.
  ///
  /// In de, this message translates to:
  /// **'Gürteltier'**
  String get itemGuerteltier;

  /// No description provided for @itemHaus.
  ///
  /// In de, this message translates to:
  /// **'Haus'**
  String get itemHaus;

  /// No description provided for @itemHerd.
  ///
  /// In de, this message translates to:
  /// **'Herd'**
  String get itemHerd;

  /// No description provided for @itemHochhaus.
  ///
  /// In de, this message translates to:
  /// **'Hochhaus'**
  String get itemHochhaus;

  /// No description provided for @itemHochspannung.
  ///
  /// In de, this message translates to:
  /// **'Hochspannung'**
  String get itemHochspannung;

  /// No description provided for @itemHund.
  ///
  /// In de, this message translates to:
  /// **'Hund'**
  String get itemHund;

  /// No description provided for @itemIce.
  ///
  /// In de, this message translates to:
  /// **'ICE'**
  String get itemIce;

  /// No description provided for @itemJaguar.
  ///
  /// In de, this message translates to:
  /// **'Jaguar'**
  String get itemJaguar;

  /// No description provided for @itemKaenguru.
  ///
  /// In de, this message translates to:
  /// **'Känguru'**
  String get itemKaenguru;

  /// No description provided for @itemKamel.
  ///
  /// In de, this message translates to:
  /// **'Kamel'**
  String get itemKamel;

  /// No description provided for @itemKanzel.
  ///
  /// In de, this message translates to:
  /// **'Kanzel'**
  String get itemKanzel;

  /// No description provided for @itemKatze.
  ///
  /// In de, this message translates to:
  /// **'Katze'**
  String get itemKatze;

  /// No description provided for @itemKekse.
  ///
  /// In de, this message translates to:
  /// **'Kekse'**
  String get itemKekse;

  /// No description provided for @itemKelch.
  ///
  /// In de, this message translates to:
  /// **'Kelch'**
  String get itemKelch;

  /// No description provided for @itemKerze.
  ///
  /// In de, this message translates to:
  /// **'Kerze'**
  String get itemKerze;

  /// No description provided for @itemKinderwagen.
  ///
  /// In de, this message translates to:
  /// **'Kinderwagen'**
  String get itemKinderwagen;

  /// No description provided for @itemKircheGebaeude.
  ///
  /// In de, this message translates to:
  /// **'Kirche'**
  String get itemKircheGebaeude;

  /// No description provided for @itemKirchenbank.
  ///
  /// In de, this message translates to:
  /// **'Kirchenbank'**
  String get itemKirchenbank;

  /// No description provided for @itemKirchenturm.
  ///
  /// In de, this message translates to:
  /// **'Kirchenturm'**
  String get itemKirchenturm;

  /// No description provided for @itemKlemmbaustein.
  ///
  /// In de, this message translates to:
  /// **'Klemmbaustein'**
  String get itemKlemmbaustein;

  /// No description provided for @itemKlingelbeutel.
  ///
  /// In de, this message translates to:
  /// **'Klingelbeutel'**
  String get itemKlingelbeutel;

  /// No description provided for @itemKochtopf.
  ///
  /// In de, this message translates to:
  /// **'Kochtopf'**
  String get itemKochtopf;

  /// No description provided for @itemKoffer.
  ///
  /// In de, this message translates to:
  /// **'Koffer'**
  String get itemKoffer;

  /// No description provided for @itemKopfhoerer.
  ///
  /// In de, this message translates to:
  /// **'Kopfhörer'**
  String get itemKopfhoerer;

  /// No description provided for @itemKrankenwagen.
  ///
  /// In de, this message translates to:
  /// **'Krankenwagen'**
  String get itemKrankenwagen;

  /// No description provided for @itemKreuz.
  ///
  /// In de, this message translates to:
  /// **'Kreuz'**
  String get itemKreuz;

  /// No description provided for @itemKrokodil.
  ///
  /// In de, this message translates to:
  /// **'Krokodil'**
  String get itemKrokodil;

  /// No description provided for @itemKronleuchter.
  ///
  /// In de, this message translates to:
  /// **'Kronleuchter'**
  String get itemKronleuchter;

  /// No description provided for @itemKuehlschrank.
  ///
  /// In de, this message translates to:
  /// **'Kühlschrank'**
  String get itemKuehlschrank;

  /// No description provided for @itemKuh.
  ///
  /// In de, this message translates to:
  /// **'Kuh'**
  String get itemKuh;

  /// No description provided for @itemKuscheltiere.
  ///
  /// In de, this message translates to:
  /// **'Kuscheltiere'**
  String get itemKuscheltiere;

  /// No description provided for @itemLamm.
  ///
  /// In de, this message translates to:
  /// **'Lamm'**
  String get itemLamm;

  /// No description provided for @itemLammMitFahne.
  ///
  /// In de, this message translates to:
  /// **'Lamm mit Fahne'**
  String get itemLammMitFahne;

  /// No description provided for @itemLampe.
  ///
  /// In de, this message translates to:
  /// **'Lampe'**
  String get itemLampe;

  /// No description provided for @itemLaptop.
  ///
  /// In de, this message translates to:
  /// **'Laptop'**
  String get itemLaptop;

  /// No description provided for @itemLesepult.
  ///
  /// In de, this message translates to:
  /// **'Lesepult'**
  String get itemLesepult;

  /// No description provided for @itemLieferwagen.
  ///
  /// In de, this message translates to:
  /// **'Lieferwagen'**
  String get itemLieferwagen;

  /// No description provided for @itemLkw.
  ///
  /// In de, this message translates to:
  /// **'LKW'**
  String get itemLkw;

  /// No description provided for @itemLoewe.
  ///
  /// In de, this message translates to:
  /// **'Löwe'**
  String get itemLoewe;

  /// No description provided for @itemMalbuch.
  ///
  /// In de, this message translates to:
  /// **'Malbuch'**
  String get itemMalbuch;

  /// No description provided for @itemMandrill.
  ///
  /// In de, this message translates to:
  /// **'Mandrill'**
  String get itemMandrill;

  /// No description provided for @itemMikrofon.
  ///
  /// In de, this message translates to:
  /// **'Mikrofon'**
  String get itemMikrofon;

  /// No description provided for @itemMotorrad.
  ///
  /// In de, this message translates to:
  /// **'Motorrad'**
  String get itemMotorrad;

  /// No description provided for @itemMuellauto.
  ///
  /// In de, this message translates to:
  /// **'Müllauto'**
  String get itemMuellauto;

  /// No description provided for @itemMuelltonne.
  ///
  /// In de, this message translates to:
  /// **'Mülltonne'**
  String get itemMuelltonne;

  /// No description provided for @itemOfen.
  ///
  /// In de, this message translates to:
  /// **'Ofen'**
  String get itemOfen;

  /// No description provided for @itemOpferstock.
  ///
  /// In de, this message translates to:
  /// **'Opferstock'**
  String get itemOpferstock;

  /// No description provided for @itemOrangUtan.
  ///
  /// In de, this message translates to:
  /// **'Orang-Utan'**
  String get itemOrangUtan;

  /// No description provided for @itemOrgel.
  ///
  /// In de, this message translates to:
  /// **'Orgel'**
  String get itemOrgel;

  /// No description provided for @itemOsterkerze.
  ///
  /// In de, this message translates to:
  /// **'Osterkerze'**
  String get itemOsterkerze;

  /// No description provided for @itemOtter.
  ///
  /// In de, this message translates to:
  /// **'Otter'**
  String get itemOtter;

  /// No description provided for @itemParkplatz.
  ///
  /// In de, this message translates to:
  /// **'Parkplatz'**
  String get itemParkplatz;

  /// No description provided for @itemPastor.
  ///
  /// In de, this message translates to:
  /// **'Pastor'**
  String get itemPastor;

  /// No description provided for @itemPastorin.
  ///
  /// In de, this message translates to:
  /// **'Pastorin'**
  String get itemPastorin;

  /// No description provided for @itemPavian.
  ///
  /// In de, this message translates to:
  /// **'Pavian'**
  String get itemPavian;

  /// No description provided for @itemPelikanKirche.
  ///
  /// In de, this message translates to:
  /// **'Pelikan'**
  String get itemPelikanKirche;

  /// No description provided for @itemPelikanZoo.
  ///
  /// In de, this message translates to:
  /// **'Pelikan'**
  String get itemPelikanZoo;

  /// No description provided for @itemPferd.
  ///
  /// In de, this message translates to:
  /// **'Pferd'**
  String get itemPferd;

  /// No description provided for @itemPflanze.
  ///
  /// In de, this message translates to:
  /// **'Pflanze'**
  String get itemPflanze;

  /// No description provided for @itemPinguin.
  ///
  /// In de, this message translates to:
  /// **'Pinguin'**
  String get itemPinguin;

  /// No description provided for @itemPinsel.
  ///
  /// In de, this message translates to:
  /// **'Pinsel'**
  String get itemPinsel;

  /// No description provided for @itemPinselohrschwein.
  ///
  /// In de, this message translates to:
  /// **'Pinselohrschwein'**
  String get itemPinselohrschwein;

  /// No description provided for @itemPolizeiauto.
  ///
  /// In de, this message translates to:
  /// **'Polizeiauto'**
  String get itemPolizeiauto;

  /// No description provided for @itemPraeriehund.
  ///
  /// In de, this message translates to:
  /// **'Präriehund'**
  String get itemPraeriehund;

  /// No description provided for @itemPuppe.
  ///
  /// In de, this message translates to:
  /// **'Puppe'**
  String get itemPuppe;

  /// No description provided for @itemPuzzle.
  ///
  /// In de, this message translates to:
  /// **'Puzzle'**
  String get itemPuzzle;

  /// No description provided for @itemRastplatz.
  ///
  /// In de, this message translates to:
  /// **'Rastplatz'**
  String get itemRastplatz;

  /// No description provided for @itemRegal.
  ///
  /// In de, this message translates to:
  /// **'Regal'**
  String get itemRegal;

  /// No description provided for @itemReh.
  ///
  /// In de, this message translates to:
  /// **'Reh'**
  String get itemReh;

  /// No description provided for @itemReisebus.
  ///
  /// In de, this message translates to:
  /// **'Reisebus'**
  String get itemReisebus;

  /// No description provided for @itemRoller.
  ///
  /// In de, this message translates to:
  /// **'Roller'**
  String get itemRoller;

  /// No description provided for @itemRotesAuto.
  ///
  /// In de, this message translates to:
  /// **'Rotes Auto'**
  String get itemRotesAuto;

  /// No description provided for @itemRucksack.
  ///
  /// In de, this message translates to:
  /// **'Rucksack'**
  String get itemRucksack;

  /// No description provided for @itemSatellitenschuessel.
  ///
  /// In de, this message translates to:
  /// **'Satellitenschüssel'**
  String get itemSatellitenschuessel;

  /// No description provided for @itemSbahn.
  ///
  /// In de, this message translates to:
  /// **'S-Bahn'**
  String get itemSbahn;

  /// No description provided for @itemSchaf.
  ///
  /// In de, this message translates to:
  /// **'Schaf'**
  String get itemSchaf;

  /// No description provided for @itemSchafe.
  ///
  /// In de, this message translates to:
  /// **'Schafe'**
  String get itemSchafe;

  /// No description provided for @itemSchaffner.
  ///
  /// In de, this message translates to:
  /// **'Schaffner'**
  String get itemSchaffner;

  /// No description provided for @itemSchallplatte.
  ///
  /// In de, this message translates to:
  /// **'Schallplatte'**
  String get itemSchallplatte;

  /// No description provided for @itemSchaukel.
  ///
  /// In de, this message translates to:
  /// **'Schaukel'**
  String get itemSchaukel;

  /// No description provided for @itemSchere.
  ///
  /// In de, this message translates to:
  /// **'Schere'**
  String get itemSchere;

  /// No description provided for @itemScheune.
  ///
  /// In de, this message translates to:
  /// **'Scheune'**
  String get itemScheune;

  /// No description provided for @itemSchiff.
  ///
  /// In de, this message translates to:
  /// **'Schiff'**
  String get itemSchiff;

  /// No description provided for @itemSchildkroete.
  ///
  /// In de, this message translates to:
  /// **'Schildkröte'**
  String get itemSchildkroete;

  /// No description provided for @itemSchlange.
  ///
  /// In de, this message translates to:
  /// **'Schlange'**
  String get itemSchlange;

  /// No description provided for @itemSchneeEule.
  ///
  /// In de, this message translates to:
  /// **'Schnee-Eule'**
  String get itemSchneeEule;

  /// No description provided for @itemSchneeeule.
  ///
  /// In de, this message translates to:
  /// **'Schnee-Eule'**
  String get itemSchneeeule;

  /// No description provided for @itemSchneeflocke.
  ///
  /// In de, this message translates to:
  /// **'Schneeflocke'**
  String get itemSchneeflocke;

  /// No description provided for @itemSchneemann.
  ///
  /// In de, this message translates to:
  /// **'Schneemann'**
  String get itemSchneemann;

  /// No description provided for @itemSchnitzereien.
  ///
  /// In de, this message translates to:
  /// **'Schnitzereien'**
  String get itemSchnitzereien;

  /// No description provided for @itemSchornstein.
  ///
  /// In de, this message translates to:
  /// **'Schornstein'**
  String get itemSchornstein;

  /// No description provided for @itemSchule.
  ///
  /// In de, this message translates to:
  /// **'Schule'**
  String get itemSchule;

  /// No description provided for @itemSchwermeinchen.
  ///
  /// In de, this message translates to:
  /// **'Schwermeinchen'**
  String get itemSchwermeinchen;

  /// No description provided for @itemSchwippbogen.
  ///
  /// In de, this message translates to:
  /// **'Schwippbogen'**
  String get itemSchwippbogen;

  /// No description provided for @itemSee.
  ///
  /// In de, this message translates to:
  /// **'See'**
  String get itemSee;

  /// No description provided for @itemSeehund.
  ///
  /// In de, this message translates to:
  /// **'Seehund'**
  String get itemSeehund;

  /// No description provided for @itemSessel.
  ///
  /// In de, this message translates to:
  /// **'Sessel'**
  String get itemSessel;

  /// No description provided for @itemSikahHirsch.
  ///
  /// In de, this message translates to:
  /// **'Sikah-Hirsch'**
  String get itemSikahHirsch;

  /// No description provided for @itemSikahirsch.
  ///
  /// In de, this message translates to:
  /// **'Sikahirsch'**
  String get itemSikahirsch;

  /// No description provided for @itemSofa.
  ///
  /// In de, this message translates to:
  /// **'Sofa'**
  String get itemSofa;

  /// No description provided for @itemSolarzellen.
  ///
  /// In de, this message translates to:
  /// **'Solarzellen'**
  String get itemSolarzellen;

  /// No description provided for @itemSpielplatz.
  ///
  /// In de, this message translates to:
  /// **'Spielplatz'**
  String get itemSpielplatz;

  /// No description provided for @itemStachelschwein.
  ///
  /// In de, this message translates to:
  /// **'Stachelschwein'**
  String get itemStachelschwein;

  /// No description provided for @itemStopschild.
  ///
  /// In de, this message translates to:
  /// **'Stopschild'**
  String get itemStopschild;

  /// No description provided for @itemStrassenlaterne.
  ///
  /// In de, this message translates to:
  /// **'Straßenlaterne'**
  String get itemStrassenlaterne;

  /// No description provided for @itemStrauss.
  ///
  /// In de, this message translates to:
  /// **'Strauß'**
  String get itemStrauss;

  /// No description provided for @itemStuhl.
  ///
  /// In de, this message translates to:
  /// **'Stuhl'**
  String get itemStuhl;

  /// No description provided for @itemSupermarkt.
  ///
  /// In de, this message translates to:
  /// **'Supermarkt'**
  String get itemSupermarkt;

  /// No description provided for @itemTankstelle.
  ///
  /// In de, this message translates to:
  /// **'Tankstelle'**
  String get itemTankstelle;

  /// No description provided for @itemTapir.
  ///
  /// In de, this message translates to:
  /// **'Tapir'**
  String get itemTapir;

  /// No description provided for @itemTasse.
  ///
  /// In de, this message translates to:
  /// **'Tasse'**
  String get itemTasse;

  /// No description provided for @itemTaube.
  ///
  /// In de, this message translates to:
  /// **'Taube'**
  String get itemTaube;

  /// No description provided for @itemTaufbecken.
  ///
  /// In de, this message translates to:
  /// **'Taufbecken'**
  String get itemTaufbecken;

  /// No description provided for @itemTaxi.
  ///
  /// In de, this message translates to:
  /// **'Taxi'**
  String get itemTaxi;

  /// No description provided for @itemTeller.
  ///
  /// In de, this message translates to:
  /// **'Teller'**
  String get itemTeller;

  /// No description provided for @itemTempolimit.
  ///
  /// In de, this message translates to:
  /// **'Tempolimit'**
  String get itemTempolimit;

  /// No description provided for @itemTiger.
  ///
  /// In de, this message translates to:
  /// **'Tiger'**
  String get itemTiger;

  /// No description provided for @itemTisch.
  ///
  /// In de, this message translates to:
  /// **'Tisch'**
  String get itemTisch;

  /// No description provided for @itemToilette.
  ///
  /// In de, this message translates to:
  /// **'Toilette'**
  String get itemToilette;

  /// No description provided for @itemTrampolin.
  ///
  /// In de, this message translates to:
  /// **'Trampolin'**
  String get itemTrampolin;

  /// No description provided for @itemTransporter.
  ///
  /// In de, this message translates to:
  /// **'Transporter'**
  String get itemTransporter;

  /// No description provided for @itemTrecker.
  ///
  /// In de, this message translates to:
  /// **'Trecker'**
  String get itemTrecker;

  /// No description provided for @itemTreppe.
  ///
  /// In de, this message translates to:
  /// **'Treppe'**
  String get itemTreppe;

  /// No description provided for @itemTuer.
  ///
  /// In de, this message translates to:
  /// **'Tür'**
  String get itemTuer;

  /// No description provided for @itemTunnel.
  ///
  /// In de, this message translates to:
  /// **'Tunnel'**
  String get itemTunnel;

  /// No description provided for @itemUhrKirche.
  ///
  /// In de, this message translates to:
  /// **'Kirchturmuhr'**
  String get itemUhrKirche;

  /// No description provided for @itemUhrZug.
  ///
  /// In de, this message translates to:
  /// **'Bahnhofsuhr'**
  String get itemUhrZug;

  /// No description provided for @itemVoegel.
  ///
  /// In de, this message translates to:
  /// **'Vögel'**
  String get itemVoegel;

  /// No description provided for @itemWald.
  ///
  /// In de, this message translates to:
  /// **'Wald'**
  String get itemWald;

  /// No description provided for @itemWalross.
  ///
  /// In de, this message translates to:
  /// **'Walross'**
  String get itemWalross;

  /// No description provided for @itemWanduhr.
  ///
  /// In de, this message translates to:
  /// **'Wanduhr'**
  String get itemWanduhr;

  /// No description provided for @itemWaschbecken.
  ///
  /// In de, this message translates to:
  /// **'Waschbecken'**
  String get itemWaschbecken;

  /// No description provided for @itemWaschmaschine.
  ///
  /// In de, this message translates to:
  /// **'Waschmaschine'**
  String get itemWaschmaschine;

  /// No description provided for @itemWasserschwein.
  ///
  /// In de, this message translates to:
  /// **'Wasserschwein'**
  String get itemWasserschwein;

  /// No description provided for @itemWeihnachtsbaum.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsbaum'**
  String get itemWeihnachtsbaum;

  /// No description provided for @itemWeihnachtsbaumverkauf.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsbaumverkauf'**
  String get itemWeihnachtsbaumverkauf;

  /// No description provided for @itemWeihnachtsdeko.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsdeko'**
  String get itemWeihnachtsdeko;

  /// No description provided for @itemWeihnachtslichterkette.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtslichterkette'**
  String get itemWeihnachtslichterkette;

  /// No description provided for @itemWeihnachtsmann.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsmann'**
  String get itemWeihnachtsmann;

  /// No description provided for @itemWeihnachtsmarkt.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsmarkt'**
  String get itemWeihnachtsmarkt;

  /// No description provided for @itemWeihnachtsstern.
  ///
  /// In de, this message translates to:
  /// **'Weihnachtsstern'**
  String get itemWeihnachtsstern;

  /// No description provided for @itemWiese.
  ///
  /// In de, this message translates to:
  /// **'Wiese'**
  String get itemWiese;

  /// No description provided for @itemWindrad.
  ///
  /// In de, this message translates to:
  /// **'Windrad'**
  String get itemWindrad;

  /// No description provided for @itemZebra.
  ///
  /// In de, this message translates to:
  /// **'Zebra'**
  String get itemZebra;

  /// No description provided for @itemZebrastreifen.
  ///
  /// In de, this message translates to:
  /// **'Zebrastreifen'**
  String get itemZebrastreifen;

  /// No description provided for @itemZiege.
  ///
  /// In de, this message translates to:
  /// **'Ziege'**
  String get itemZiege;

  /// No description provided for @itemZug.
  ///
  /// In de, this message translates to:
  /// **'Zug'**
  String get itemZug;

  /// No description provided for @itemZuganzeiger.
  ///
  /// In de, this message translates to:
  /// **'Zuganzeiger'**
  String get itemZuganzeiger;

  /// No description provided for @jagdModus.
  ///
  /// In de, this message translates to:
  /// **'Jagd-Modus'**
  String get jagdModus;

  /// No description provided for @jedeReiseWirdZumAbenteuer.
  ///
  /// In de, this message translates to:
  /// **'Jede Reise wird zum Abenteuer!'**
  String get jedeReiseWirdZumAbenteuer;

  /// No description provided for @key200individuellgezeichneteitems.
  ///
  /// In de, this message translates to:
  /// **'> 200 individuell gezeichnete Items!'**
  String get key200individuellgezeichneteitems;

  /// No description provided for @key6vollstaendigeuebersetzungen.
  ///
  /// In de, this message translates to:
  /// **'6 vollständige Übersetzungen'**
  String get key6vollstaendigeuebersetzungen;

  /// No description provided for @key7bereiche.
  ///
  /// In de, this message translates to:
  /// **'7 Bereiche'**
  String get key7bereiche;

  /// No description provided for @legFestWieVieleBingosDuBrauchstUmZuGewinnen.
  ///
  /// In de, this message translates to:
  /// **'Leg fest wie viele Bingos\ndu brauchst um zu gewinnen!'**
  String get legFestWieVieleBingosDuBrauchstUmZuGewinnen;

  /// No description provided for @lld.
  ///
  /// In de, this message translates to:
  /// **'%1\$lld %2\$@'**
  String get lld;

  /// No description provided for @lldLld.
  ///
  /// In de, this message translates to:
  /// **'%1\$lld + %2\$lld = ?'**
  String get lldLld;

  /// No description provided for @paedagogischWertvoll.
  ///
  /// In de, this message translates to:
  /// **'Pädagogisch\nwertvoll'**
  String get paedagogischWertvoll;

  /// No description provided for @parentalGateCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get parentalGateCancel;

  /// No description provided for @parentalGateError.
  ///
  /// In de, this message translates to:
  /// **'Falsche Antwort. Versuche es erneut.'**
  String get parentalGateError;

  /// No description provided for @parentalGateExplanation.
  ///
  /// In de, this message translates to:
  /// **'Dieser Link führt zu einer externen Webseite. Bitte löse die folgende Aufgabe, um fortzufahren.'**
  String get parentalGateExplanation;

  /// No description provided for @parentalGateQuestion.
  ///
  /// In de, this message translates to:
  /// **'Löse die Rechenaufgabe:'**
  String get parentalGateQuestion;

  /// No description provided for @parentalGateSubmit.
  ///
  /// In de, this message translates to:
  /// **'Prüfen'**
  String get parentalGateSubmit;

  /// No description provided for @parentalGateTitle.
  ///
  /// In de, this message translates to:
  /// **'Erwachsenenbereich'**
  String get parentalGateTitle;

  /// No description provided for @perfektFuer.
  ///
  /// In de, this message translates to:
  /// **'Perfekt für:'**
  String get perfektFuer;

  /// No description provided for @seasonFruehlingSommer.
  ///
  /// In de, this message translates to:
  /// **'Frühling und Sommer'**
  String get seasonFruehlingSommer;

  /// No description provided for @seasonHerbstWinter.
  ///
  /// In de, this message translates to:
  /// **'Herbst und Winter'**
  String get seasonHerbstWinter;

  /// No description provided for @seasonSelectionQuestion.
  ///
  /// In de, this message translates to:
  /// **'Welche Jahreszeit ist gerade?'**
  String get seasonSelectionQuestion;

  /// No description provided for @seasonSommer.
  ///
  /// In de, this message translates to:
  /// **'Frühling und Sommer'**
  String get seasonSommer;

  /// No description provided for @seasonWinter.
  ///
  /// In de, this message translates to:
  /// **'Herbst und Winter'**
  String get seasonWinter;

  /// No description provided for @settingsImprint.
  ///
  /// In de, this message translates to:
  /// **'Impressum'**
  String get settingsImprint;

  /// No description provided for @settingsInOrt.
  ///
  /// In de, this message translates to:
  /// **'in Hennstedt'**
  String get settingsInOrt;

  /// No description provided for @settingsMadeWith.
  ///
  /// In de, this message translates to:
  /// **'Gemacht mit'**
  String get settingsMadeWith;

  /// No description provided for @settingsPrivacy.
  ///
  /// In de, this message translates to:
  /// **'Datenschutz'**
  String get settingsPrivacy;

  /// No description provided for @settingsSupport.
  ///
  /// In de, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsSnowfall.
  ///
  /// In de, this message translates to:
  /// **'Schneefall'**
  String get settingsSnowfall;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Informationen'**
  String get settingsTitle;

  /// No description provided for @settingsVersion.
  ///
  /// In de, this message translates to:
  /// **'Version 1.0'**
  String get settingsVersion;

  /// No description provided for @sizeLong.
  ///
  /// In de, this message translates to:
  /// **'Lang'**
  String get sizeLong;

  /// No description provided for @sizeMedium.
  ///
  /// In de, this message translates to:
  /// **'Mittel'**
  String get sizeMedium;

  /// No description provided for @sizeQuick.
  ///
  /// In de, this message translates to:
  /// **'Schnell'**
  String get sizeQuick;

  /// No description provided for @sizeSelectionQuestion.
  ///
  /// In de, this message translates to:
  /// **'Wie lange dauert die Reise?'**
  String get sizeSelectionQuestion;

  /// No description provided for @spielSoWieDuWillst.
  ///
  /// In de, this message translates to:
  /// **'Spiel so wie du willst!'**
  String get spielSoWieDuWillst;

  /// No description provided for @targetbingosQuestion.
  ///
  /// In de, this message translates to:
  /// **'Wie viele Bingos?'**
  String get targetbingosQuestion;

  /// No description provided for @themeBluepurple.
  ///
  /// In de, this message translates to:
  /// **'Galaxie'**
  String get themeBluepurple;

  /// No description provided for @themeDeepblue.
  ///
  /// In de, this message translates to:
  /// **'Tiefsee'**
  String get themeDeepblue;

  /// No description provided for @themeGreenmint.
  ///
  /// In de, this message translates to:
  /// **'Oase'**
  String get themeGreenmint;

  /// No description provided for @themeLightblue.
  ///
  /// In de, this message translates to:
  /// **'Kristall'**
  String get themeLightblue;

  /// No description provided for @themePinkred.
  ///
  /// In de, this message translates to:
  /// **'Flamingo'**
  String get themePinkred;

  /// No description provided for @themePinkyellow.
  ///
  /// In de, this message translates to:
  /// **'Sommer'**
  String get themePinkyellow;

  /// No description provided for @themeChristmas.
  ///
  /// In de, this message translates to:
  /// **'Weihnachten'**
  String get themeChristmas;

  /// No description provided for @themeSelectionTitle.
  ///
  /// In de, this message translates to:
  /// **'Wähle deine Farbe'**
  String get themeSelectionTitle;

  /// No description provided for @tippeWasDuSiehst.
  ///
  /// In de, this message translates to:
  /// **'Tippe, was du siehst!'**
  String get tippeWasDuSiehst;

  /// No description provided for @victoryBackToStart.
  ///
  /// In de, this message translates to:
  /// **'Zurück zum Anfang'**
  String get victoryBackToStart;

  /// No description provided for @victoryBingoPlural.
  ///
  /// In de, this message translates to:
  /// **'Bingos geschafft!'**
  String get victoryBingoPlural;

  /// No description provided for @victoryBingoSingular.
  ///
  /// In de, this message translates to:
  /// **'Bingo geschafft!'**
  String get victoryBingoSingular;

  /// No description provided for @victoryPlayAgain.
  ///
  /// In de, this message translates to:
  /// **'Nochmal spielen'**
  String get victoryPlayAgain;

  /// No description provided for @victoryWon.
  ///
  /// In de, this message translates to:
  /// **'Gewonnen!'**
  String get victoryWon;

  /// No description provided for @weltweitSpielbar.
  ///
  /// In de, this message translates to:
  /// **'Weltweit spielbar'**
  String get weltweitSpielbar;

  /// No description provided for @zweiSpielmodi.
  ///
  /// In de, this message translates to:
  /// **'Zwei Spielmodi'**
  String get zweiSpielmodi;

  /// No description provided for @seasonFruehling_sommerName.
  ///
  /// In de, this message translates to:
  /// **'Frühling/Sommer'**
  String get seasonFruehling_sommerName;

  /// No description provided for @seasonFruehling_sommerDescription.
  ///
  /// In de, this message translates to:
  /// **'Erlebe die warme Jahreszeit mit Items wie Kühen, Schafen und blühender Natur.'**
  String get seasonFruehling_sommerDescription;

  /// No description provided for @seasonHerbst_winterName.
  ///
  /// In de, this message translates to:
  /// **'Herbst/Winter'**
  String get seasonHerbst_winterName;

  /// No description provided for @seasonHerbst_winterDescription.
  ///
  /// In de, this message translates to:
  /// **'Entdecke die kalte Jahreszeit mit winterlichen Items und herbstlichen Motiven.'**
  String get seasonHerbst_winterDescription;

  /// No description provided for @seasonSpecialTimesName.
  ///
  /// In de, this message translates to:
  /// **'Besondere Zeiten'**
  String get seasonSpecialTimesName;

  /// No description provided for @seasonSpecialTimesDescription.
  ///
  /// In de, this message translates to:
  /// **'Ab dem 1. Dezember sind Weihnachtsitems verfügbar.'**
  String get seasonSpecialTimesDescription;

  /// No description provided for @accessibilityFound.
  ///
  /// In de, this message translates to:
  /// **'gefunden'**
  String get accessibilityFound;

  /// No description provided for @accessibilityNotFound.
  ///
  /// In de, this message translates to:
  /// **'noch nicht gefunden'**
  String get accessibilityNotFound;

  /// No description provided for @accessibilityTapToMark.
  ///
  /// In de, this message translates to:
  /// **'Doppeltippen zum Markieren'**
  String get accessibilityTapToMark;

  /// No description provided for @accessibilityBackButton.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get accessibilityBackButton;

  /// No description provided for @accessibilityResetButton.
  ///
  /// In de, this message translates to:
  /// **'Spiel zurücksetzen'**
  String get accessibilityResetButton;

  /// No description provided for @accessibilitySettingsButton.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen öffnen'**
  String get accessibilitySettingsButton;

  /// No description provided for @accessibilityThemeButton.
  ///
  /// In de, this message translates to:
  /// **'Farbthema wählen'**
  String get accessibilityThemeButton;

  /// No description provided for @accessibilityTextToggle.
  ///
  /// In de, this message translates to:
  /// **'Text ein- oder ausblenden'**
  String get accessibilityTextToggle;

  /// No description provided for @accessibilitySoundToggle.
  ///
  /// In de, this message translates to:
  /// **'Ton ein- oder ausschalten'**
  String get accessibilitySoundToggle;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In de, this message translates to:
  /// **'Willkommen!'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In de, this message translates to:
  /// **'Guck mal! ist ein Reise-Bingo für die ganze Familie. Entdeckt gemeinsam eure Umgebung und sammelt Bingos!'**
  String get onboardingWelcomeDesc;

  /// No description provided for @onboardingModesTitle.
  ///
  /// In de, this message translates to:
  /// **'Zwei Spielmodi'**
  String get onboardingModesTitle;

  /// No description provided for @onboardingModesDesc.
  ///
  /// In de, this message translates to:
  /// **'Bingo Suche: Spielt entspannt und sammelt so viele Bingos wie ihr wollt.\n\nBingo Jagd: Legt ein Ziel fest und spielt um den Sieg!'**
  String get onboardingModesDesc;

  /// No description provided for @onboardingPlayTitle.
  ///
  /// In de, this message translates to:
  /// **'So geht\'s'**
  String get onboardingPlayTitle;

  /// No description provided for @onboardingPlayDesc.
  ///
  /// In de, this message translates to:
  /// **'Seht ihr etwas auf eurem Spielfeld? Tippt darauf! Schafft eine Reihe horizontal, vertikal oder diagonal – und ihr habt ein Bingo!'**
  String get onboardingPlayDesc;

  /// No description provided for @onboardingReadyTitle.
  ///
  /// In de, this message translates to:
  /// **'Los geht\'s!'**
  String get onboardingReadyTitle;

  /// No description provided for @onboardingReadyDesc.
  ///
  /// In de, this message translates to:
  /// **'Wählt euren Spielmodus, das Thema und die Spielfeldgröße. Dann kann die Reise beginnen!'**
  String get onboardingReadyDesc;

  /// No description provided for @onboardingNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In de, this message translates to:
  /// **'Jetzt spielen'**
  String get onboardingStart;

  /// No description provided for @settingsHelp.
  ///
  /// In de, this message translates to:
  /// **'Anleitung'**
  String get settingsHelp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'nl'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
