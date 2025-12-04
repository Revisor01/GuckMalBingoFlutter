import '../models/bingo_item.dart';
import '../models/area.dart';
import '../models/season.dart';
import '../models/category_theme.dart';

/// BingoItemsData - Portiert von Swift
/// Alle 206 Items mit Areas, Seasons und Datum-Verfügbarkeit
class BingoItemsData {
  /// Helper für Area-Arrays
  static List<Area> _areas(List<Area> areas) => areas;
  static List<Season>? _seasons(List<Season>? seasons) => seasons;

  /// Alle Items - jedes nur 1x definiert
  /// areas: Wo kommt das Item vor?
  /// seasons: null = alle Seasons, [] = keine Seasons (besondere Orte)
  static final List<BingoItem> allItems = [
    // VERKEHR & FAHRZEUGE
    BingoItem(
      emoji: '🌀',
      name: 'itemWindrad',
      imageName: 'windrad',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null, // alle Seasons
    ),

    BingoItem(
      emoji: '🚗',
      name: 'itemRotesAuto',
      imageName: 'rotesauto',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚙',
      name: 'itemBlauesAuto',
      imageName: 'blauesauto',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚐',
      name: 'itemGruenesAuto',
      imageName: 'gruenesauto',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '📦',
      name: 'itemLieferwagen',
      imageName: 'lieferwagen',
      areas: _areas([Area.autobahn, Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚚',
      name: 'itemLkw',
      imageName: 'lkwe2',
      areas: _areas([Area.autobahn, Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚜',
      name: 'itemTrecker',
      imageName: 'trecker',
      areas: _areas([Area.zug, Area.land, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏍️',
      name: 'itemMotorrad',
      imageName: 'motorrad',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: _seasons([Season.fruehling_sommer]),
    ),

    BingoItem(
      emoji: '🚐',
      name: 'itemTransporter',
      imageName: 'transporter',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: _seasons([Season.herbst_winter]),
    ),

    BingoItem(
      emoji: '🚓',
      name: 'itemPolizeiauto',
      imageName: 'polizeiauto',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚌',
      name: 'itemReisebus',
      imageName: 'reisebus',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚌',
      name: 'itemBus',
      imageName: 'bus',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚲',
      name: 'itemFahrrad',
      imageName: 'fahrrad',
      areas: _areas([Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚛',
      name: 'itemAnhaenger',
      imageName: 'anhaenger',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: _seasons([Season.herbst_winter]),
    ),

    BingoItem(
      emoji: '🛵',
      name: 'itemRoller',
      imageName: 'roller',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🛴',
      name: 'itemEscooter',
      imageName: 'escooter',
      areas: _areas([Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚕',
      name: 'itemGelbesAuto',
      imageName: 'gelbesauto',
      areas: _areas([Area.land, Area.stadt, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚕',
      name: 'itemTaxi',
      imageName: 'taxi',
      areas: _areas([Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚒',
      name: 'itemFeuerwehrauto',
      imageName: 'feuerwehrtruck',
      areas: _areas([Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚛',
      name: 'itemMuellauto',
      imageName: 'muellauto',
      areas: _areas([Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚙',
      name: 'itemCamper',
      imageName: 'camper',
      areas: _areas([Area.autobahn, Area.stadt, Area.land]),
      seasons: null,
    ),

    // INFRASTRUKTUR
    BingoItem(
      emoji: '⛽',
      name: 'itemTankstelle',
      imageName: 'tankstelle',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🔢',
      name: 'itemTempolimit',
      imageName: 'tempolimit',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '↪️',
      name: 'itemAusfahrt',
      imageName: 'ausfahrt',
      areas: _areas([Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏭',
      name: 'itemSchornstein',
      imageName: 'schornstein',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚑',
      name: 'itemKrankenwagen',
      imageName: 'krankenwagen',
      areas: _areas([Area.autobahn, Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '⚡',
      name: 'itemHochspannung',
      imageName: 'hochspannung',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚧',
      name: 'itemBaustelle',
      imageName: 'baustelle',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏗️',
      name: 'itemGrosseBaustelle',
      imageName: 'grossebaustelle',
      areas: _areas([Area.autobahn, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏗️',
      name: 'itemBagger',
      imageName: 'bagger',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🌉',
      name: 'itemBruecke',
      imageName: 'bruecke',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '⛰️',
      name: 'itemTunnel',
      imageName: 'tunnel',
      areas: _areas([Area.autobahn, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🅿️',
      name: 'itemRastplatz',
      imageName: 'rastplatz',
      areas: _areas([Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🅿️',
      name: 'itemParkplatz',
      imageName: 'parkplatz',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '💡',
      name: 'itemSolarzellen',
      imageName: 'solarzellen',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🛑',
      name: 'itemStopschild',
      imageName: 'stop',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '💡',
      name: 'itemStrassenlaterne',
      imageName: 'laterne',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🦓',
      name: 'itemZebrastreifen',
      imageName: 'zebrastreifen',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🗑️',
      name: 'itemMuelltonne',
      imageName: 'muelltonne',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '📮',
      name: 'itemBriefkasten',
      imageName: 'briefkasten',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚏',
      name: 'itemBushaltestelle',
      imageName: 'bushaltestelle',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚦',
      name: 'itemAmpel',
      imageName: 'ampel',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    // TIERE
    BingoItem(
      emoji: '🐄',
      name: 'itemKuh',
      imageName: 'kuh',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: _seasons([Season.fruehling_sommer]),
    ),

    BingoItem(
      emoji: '🐴',
      name: 'itemPferd',
      imageName: 'pferd',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: _seasons([Season.fruehling_sommer]),
    ),

    BingoItem(
      emoji: '🐑',
      name: 'itemSchafe',
      imageName: 'schaf',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: _seasons([Season.fruehling_sommer]),
    ),

    BingoItem(
      emoji: '🐦',
      name: 'itemVoegel',
      imageName: 'voegel',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🦌',
      name: 'itemReh',
      imageName: 'reh-hirsch',
      areas: _areas([Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🐈',
      name: 'itemKatze',
      imageName: 'katze',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    // NATUR
    BingoItem(
      emoji: '🌳',
      name: 'itemBaum',
      imageName: 'baum',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🌲',
      name: 'itemWald',
      imageName: 'wald',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🌾',
      name: 'itemFeld',
      imageName: 'feld',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🌿',
      name: 'itemWiese',
      imageName: 'wiese',
      areas: _areas([Area.land, Area.zug, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🌊',
      name: 'itemFluss',
      imageName: 'fluss',
      areas: _areas([Area.autobahn, Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏞️',
      name: 'itemSee',
      imageName: 'wasser-see-teich',
      areas: _areas([Area.land, Area.zug]),
      seasons: null,
    ),

    // GEBÄUDE
    BingoItem(
      emoji: '⛪',
      name: 'itemKircheGebaeude',
      imageName: 'kirche',
      areas: _areas([Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏠',
      name: 'itemHaus',
      imageName: 'haus',
      areas: _areas([Area.land, Area.stadt, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏚️',
      name: 'itemScheune',
      imageName: 'scheune',
      areas: _areas([Area.land, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏢',
      name: 'itemHochhaus',
      imageName: 'hochhaus',
      areas: _areas([Area.stadt, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏫',
      name: 'itemSchule',
      imageName: 'schule',
      areas: _areas([Area.stadt, Area.land, Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🎪',
      name: 'itemSpielplatz',
      imageName: 'spielplatz',
      areas: _areas([Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏪',
      name: 'itemSupermarkt',
      imageName: 'supermarkt',
      areas: _areas([Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '☕',
      name: 'itemCafe',
      imageName: 'cafe',
      areas: _areas([Area.stadt]),
      seasons: null,
    ),

    // ZUG-SPEZIFISCH
    BingoItem(
      emoji: '🚂',
      name: 'itemZug',
      imageName: 'zug',
      areas: _areas([Area.land, Area.stadt, Area.zug, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚄',
      name: 'itemIce',
      imageName: 'ice',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚇',
      name: 'itemSbahn',
      imageName: 'zug-sbahn',
      areas: _areas([Area.zug, Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🚉',
      name: 'itemBahnhof',
      imageName: 'bahnhof',
      areas: _areas([Area.zug, Area.stadt, Area.land]),
      seasons: null,
    ),

    BingoItem(
      emoji: '👨‍✈️',
      name: 'itemSchaffner',
      imageName: 'schaffner',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🧳',
      name: 'itemKoffer',
      imageName: 'koffer',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🎒',
      name: 'itemRucksack',
      imageName: 'rucksack',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '💻',
      name: 'itemLaptop',
      imageName: 'laptop',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏗️',
      name: 'itemUhrZug',
      imageName: 'bahnhofsuhr',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🏗️',
      name: 'itemZuganzeiger',
      imageName: 'zuganzeiger',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '📖',
      name: 'itemBuch',
      imageName: 'buch',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🎧',
      name: 'itemKopfhoerer',
      imageName: 'kopfhoerer',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🔵',
      name: 'itemBlauesSchild',
      imageName: 'blauesschild',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🟡',
      name: 'itemGelbesSchild',
      imageName: 'gelbesschild',
      areas: _areas([Area.zug]),
      seasons: null,
    ),

    // SONSTIGE
    BingoItem(
      emoji: '✈️',
      name: 'itemFlugzeug',
      imageName: 'flugzeug',
      areas: _areas([Area.land, Area.stadt, Area.zug, Area.autobahn]),
      seasons: null,
    ),

    BingoItem(
      emoji: '👶',
      name: 'itemKinderwagen',
      imageName: 'kinderwagen',
      areas: _areas([Area.stadt]),
      seasons: null,
    ),

    BingoItem(
      emoji: '✨',
      name: 'itemWeihnachtsdeko',
      imageName: 'dekoxmas',
      areas: _areas([Area.stadt, Area.land, Area.zug]),
      seasons: null,
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '📡',
      name: 'itemSatellitenschuessel',
      imageName: 'satelitenschuessel',
      areas: _areas([Area.land, Area.stadt]),
      seasons: null,
    ),

    // WINTER-ITEMS (November bis Februar)
    BingoItem(
      emoji: '❄️',
      name: 'itemSchneeflocke',
      imageName: 'schneeflocke',
      areas: _areas([Area.zuHause, Area.autobahn, Area.land, Area.stadt, Area.zug]),
      seasons: [],
      availableFromMonth: 11,
      availableFromDay: 15,
      availableToMonth: 2,
      availableToDay: 28,
    ),

    BingoItem(
      emoji: '☃️',
      name: 'itemSchneemann',
      imageName: 'schneemann',
      areas: _areas([Area.zuHause, Area.land, Area.stadt]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 2,
      availableToDay: 28,
    ),

    BingoItem(
      emoji: '🎄',
      name: 'itemWeihnachtsmarkt',
      imageName: 'weihnachtsmarkt',
      areas: _areas([Area.zug, Area.land, Area.stadt]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 2,
      availableToDay: 28,
    ),

    // WEIHNACHTS-ITEMS (Advent bis 6. Januar)
    BingoItem(
      emoji: '🎄',
      name: 'itemWeihnachtsbaum',
      imageName: 'weihnachtsbaum',
      areas: _areas([Area.zuHause, Area.kirche, Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '🎅',
      name: 'itemWeihnachtsmann',
      imageName: 'weihnachtsmann',
      areas: _areas([Area.zuHause, Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 12,
      availableToDay: 24,
    ),

    BingoItem(
      emoji: '🎁',
      name: 'itemGeschenke',
      imageName: 'geschenke',
      areas: _areas([Area.zuHause, Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 12,
      availableToDay: 24,
    ),

    BingoItem(
      emoji: '⭐',
      name: 'itemWeihnachtsstern',
      imageName: 'weihnachtsstern-pflanze',
      areas: _areas([Area.zuHause, Area.stadt, Area.land]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '🔔',
      name: 'itemGlocken',
      imageName: 'glocken',
      areas: _areas([Area.zuHause, Area.stadt, Area.land]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '💡',
      name: 'itemWeihnachtslichterkette',
      imageName: 'weihnachtslichterkette',
      areas: _areas([Area.zuHause, Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '🍪',
      name: 'itemKekse',
      imageName: 'kekse',
      areas: _areas([Area.zuHause, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '🍰',
      name: 'itemChriststollen',
      imageName: 'christstollen',
      areas: _areas([Area.zuHause]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 12,
      availableToDay: 26,
    ),

    BingoItem(
      emoji: '⛪',
      name: 'itemSchwippbogen',
      imageName: 'schwippbogen',
      areas: _areas([Area.zuHause, Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 12,
      availableFromDay: 1,
      availableToMonth: 1,
      availableToDay: 6,
    ),

    BingoItem(
      emoji: '🎄',
      name: 'itemWeihnachtsbaumverkauf',
      imageName: 'weihnachtsbaumverkauf',
      areas: _areas([Area.stadt, Area.land, Area.zug]),
      seasons: [],
      availableFromMonth: 11,
      availableFromDay: 25,
      availableToMonth: 12,
      availableToDay: 23,
    ),

    // KIRCHE (besondere Orte, keine Seasons)
    BingoItem(
      emoji: '',
      name: 'itemAdventskranz',
      imageName: 'adventskranz',
      areas: _areas([Area.kirche]),
      seasons: [],
      availableFromMonth: 11,
      availableFromDay: 27,
      availableToMonth: 12,
      availableToDay: 24,
    ),

    BingoItem(
      emoji: '',
      name: 'itemAltar',
      imageName: 'altar',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBesucherinnen',
      imageName: 'besucherinnen',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBibel',
      imageName: 'bibel',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBlumen',
      imageName: 'blumen',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBuntglasfenster',
      imageName: 'buntglasfenster',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemEmpore',
      imageName: 'empore',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemEngel',
      imageName: 'engel',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemErntekrone',
      imageName: 'erntekrone',
      areas: _areas([Area.kirche]),
      seasons: [],
      availableFromMonth: 9,
      availableFromDay: 1,
      availableToMonth: 10,
      availableToDay: 31,
    ),

    BingoItem(
      emoji: '',
      name: 'itemFisch',
      imageName: 'fisch',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemGesangbuch',
      imageName: 'gesangbuch',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemGlocke',
      imageName: 'glocke',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKanzel',
      imageName: 'kanzel',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKelch',
      imageName: 'kelch',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKerze',
      imageName: 'kerze',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKirchenbank',
      imageName: 'kirchenbank',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKirchenturm',
      imageName: 'kirchenturm',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKlingelbeutel',
      imageName: 'klingelbeutel',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKreuz',
      imageName: 'kreuz',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKronleuchter',
      imageName: 'kronleuchter',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemLammMitFahne',
      imageName: 'lamm_mit_fahne',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemLamm',
      imageName: 'lamm',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemLesepult',
      imageName: 'lesepult',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemMikrofon',
      imageName: 'mikrofon',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemOpferstock',
      imageName: 'opferstock',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemOrgel',
      imageName: 'orgel',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemOsterkerze',
      imageName: 'osterkerze',
      areas: _areas([Area.kirche]),
      seasons: [],
      availableFromMonth: 3,
      availableFromDay: 1,
      availableToMonth: 5,
      availableToDay: 31,
    ),

    BingoItem(
      emoji: '',
      name: 'itemPastor',
      imageName: 'pastor',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPastorin',
      imageName: 'pastorin',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPelikanKirche',
      imageName: 'pelikan',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchiff',
      imageName: 'schiff',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchnitzereien',
      imageName: 'schnitzereien',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemTaube',
      imageName: 'taube',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemTaufbecken',
      imageName: 'taufbecken',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemUhrKirche',
      imageName: 'kirchenuhr',
      areas: _areas([Area.kirche]),
      seasons: [],
    ),

    // ZU HAUSE (besondere Orte, keine Seasons)
    BingoItem(
      emoji: '🛋️',
      name: 'itemSofa',
      imageName: 'sofa',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🛏️',
      name: 'itemBett',
      imageName: 'bett',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪑',
      name: 'itemTisch',
      imageName: 'tisch',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🍽️',
      name: 'itemBesteck',
      imageName: 'besteck',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🍽️',
      name: 'itemTeller',
      imageName: 'teller',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🧊',
      name: 'itemKuehlschrank',
      imageName: 'kuehlschrank',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🍳',
      name: 'itemHerd',
      imageName: 'herd',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🍲',
      name: 'itemKochtopf',
      imageName: 'kochtopf',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🔥',
      name: 'itemOfen',
      imageName: 'ofen',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '📺',
      name: 'itemFernseher',
      imageName: 'fernseher',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '💡',
      name: 'itemLampe',
      imageName: 'lampe',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '💡',
      name: 'itemGluehbirne',
      imageName: 'gluehbirne',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '📖',
      name: 'itemBuch',
      imageName: 'buch',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🎨',
      name: 'itemMalbuch',
      imageName: 'malbuch',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🖼️',
      name: 'itemBild',
      imageName: 'bild',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🕐',
      name: 'itemWanduhr',
      imageName: 'wanduhr',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🧸',
      name: 'itemKuscheltiere',
      imageName: 'kuscheltiere',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🧩',
      name: 'itemPuzzle',
      imageName: 'puzzle',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🧱',
      name: 'itemKlemmbaustein',
      imageName: 'klemmbaustein',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '👶',
      name: 'itemPuppe',
      imageName: 'puppe',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '⚽',
      name: 'itemBall',
      imageName: 'ball',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🚂',
      name: 'itemEisenbahn',
      imageName: 'eisenbahn',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪀',
      name: 'itemDudubox',
      imageName: 'dudubox',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '☕',
      name: 'itemTasse',
      imageName: 'tasse',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🧺',
      name: 'itemWaschmaschine',
      imageName: 'waschmaschiene',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🚽',
      name: 'itemToilette',
      imageName: 'toilette',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🚰',
      name: 'itemWaschbecken',
      imageName: 'waschbecken',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🚪',
      name: 'itemTuer',
      imageName: 'tuer',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪟',
      name: 'itemFenster',
      imageName: 'fenster',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪜',
      name: 'itemTreppe',
      imageName: 'treppe',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '✂️',
      name: 'itemSchere',
      imageName: 'schere',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🖌️',
      name: 'itemPinsel',
      imageName: 'pinsel',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪴',
      name: 'itemPflanze',
      imageName: 'pflanze',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🌸',
      name: 'itemBlumenZuhause',
      imageName: 'blumen',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '📚',
      name: 'itemRegal',
      imageName: 'regal',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '💿',
      name: 'itemSchallplatte',
      imageName: 'schallplatte',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🪁',
      name: 'itemSchaukel',
      imageName: 'schaukel',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🤸',
      name: 'itemTrampolin',
      imageName: 'trampolin',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),

    // ZOO (besondere Orte, keine Seasons)
    BingoItem(
      emoji: '',
      name: 'itemAffe',
      imageName: 'affe',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemAra',
      imageName: 'ara',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBison',
      imageName: 'bison',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemBraunbaer',
      imageName: 'braunbaer',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemEisbaer',
      imageName: 'eisbaer',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemElefant',
      imageName: 'elefant',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemFlamingo',
      imageName: 'flamingo',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemGiraffe',
      imageName: 'giraffe',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemGuerteltier',
      imageName: 'guerteltier',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemJaguar',
      imageName: 'jaguar',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKamel',
      imageName: 'kamel',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKaenguru',
      imageName: 'kaenguru',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemKrokodil',
      imageName: 'krokodil2',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemLoewe',
      imageName: 'loewe',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemMandrill',
      imageName: 'mandril',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemOrangUtan',
      imageName: 'orang_utan',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemOtter',
      imageName: 'otter',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPavian',
      imageName: 'pavian',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPelikanZoo',
      imageName: 'pelikan',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPinguin',
      imageName: 'pinguin',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPinselohrschwein',
      imageName: 'pinselohrschwein',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemPraeriehund',
      imageName: 'praeriehund',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchaf',
      imageName: 'schaf',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchildkroete',
      imageName: 'schildkroete',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchlange',
      imageName: 'schlange',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSchneeeule',
      imageName: 'schneeeule',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSeehund',
      imageName: 'seehund',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemSikahHirsch',
      imageName: 'sikah_hirsch',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemStachelschwein',
      imageName: 'stachelschwein',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemStrauss',
      imageName: 'strauß',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemTapir',
      imageName: 'tapir',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemTiger',
      imageName: 'tiger',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemWalross',
      imageName: 'walross',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemWasserschwein',
      imageName: 'wasserschwein',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemZebra',
      imageName: 'zebra',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '',
      name: 'itemZiege',
      imageName: 'ziege',
      areas: _areas([Area.zoo]),
      seasons: [],
    ),

    BingoItem(
      emoji: '🐹',
      name: 'itemSchwermeinchen',
      imageName: 'schwermeinchen',
      areas: _areas([Area.zoo, Area.zuHause]),
      seasons: [],
    ),

    // Haustiere auch zuHause
    BingoItem(
      emoji: '🐱',
      name: 'itemKatze',
      imageName: 'katze',
      areas: _areas([Area.land, Area.stadt, Area.zuHause]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🐕',
      name: 'itemHund',
      imageName: 'hund',
      areas: _areas([Area.land, Area.stadt, Area.zug, Area.zuHause]),
      seasons: null,
    ),

    BingoItem(
      emoji: '🐠',
      name: 'itemFisch',
      imageName: 'fisch',
      areas: _areas([Area.zuHause]),
      seasons: [],
    ),
  ];

  /// Filter items für eine bestimmte Area und Season
  static List<BingoItem> itemsFor({
    required Area area,
    required Season season,
  }) {
    return allItems.where((item) {
      // Muss in der Area vorkommen
      if (!item.areas.contains(area)) return false;

      // Wenn Area eine besondere Orte (keine Seasons), dann seasons muss [] sein
      if (area.category == CategoryTheme.besondereOrte) {
        if (item.seasons != null && item.seasons!.isNotEmpty) return false;
      }
      // Wenn Area Reise (mit Seasons), dann prüfe Season
      else if (item.seasons != null && item.seasons!.isNotEmpty) {
        if (!item.seasons!.contains(season)) return false;
      }
      // item.seasons == null bedeutet alle Seasons okay

      // Prüfe Datum-Verfügbarkeit
      if (!item.isAvailableNow()) return false;

      return true;
    }).toList();
  }
}
