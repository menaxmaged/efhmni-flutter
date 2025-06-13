import 'helper.dart';

const String appName = "Efhmni";
final String appVersion = "1.0.0";
final String appDescription =
    "Efhmni is a language learning app that helps you learn Arabic through fun and interactive methods.";

final String lettersLocalPath = "assets/images/letters/";
final String numbersLocalPath = "assets/images/numbers/";
const String appAuthor = "Mena Maged";
const primary_color = Color(0xFF7E4AEF);

const default_username = "mena";
const default_password = "allow2me";

const String baseUrl = "https://tender-sculpin-badly.ngrok-free.app";

CupertinoThemeData mytheme(BuildContext context) {
  Brightness? brightness;
  if (isDarkMode == null) {
    brightness = MediaQuery.of(context).platformBrightness;
  } else {
    brightness =
        isDarkMode == true
            ? Brightness.dark
            : Brightness.light; // Get the current brightness of the device
  }
  log(
    "Brightness: $brightness",
    name: 'ThemeLogger',
  ); // Log the current brightness for debugging
  // Get the current brightness of the device

  return CupertinoThemeData(
    primaryColor: primary_color, // Set the primary color for the theme
    brightness:
        brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light, // Set the brightness based on the system theme
  );
}

Map<String, String> userData = {'name': 'Mena Maged', 'email': ''};

final teamMembers = [
  {'name': 'Mena Maged', 'imageUrl': 'assets/images/team/mena.png'},
  {'name': 'Marwa Salem', 'imageUrl': 'assets/images/team/marwa.jpeg'},
  {'name': 'Abdelrahman Ahmed', 'imageUrl': 'assets/images/team/abdo.jpeg'},
  {'name': 'Abdelrahman Ali', 'imageUrl': 'assets/images/team/boda.jpeg'},
  {'name': 'Menna Khaled', 'imageUrl': 'assets/images/team/menna.jpeg'},
  {'name': 'Sabry Salah', 'imageUrl': 'assets/images/team/sabry.jpeg'},
  {'name': 'Yousra Abdelzaher', 'imageUrl': 'assets/images/team/yousra.jpeg'},

  // Add more team members here as needed
];

final List<String> numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

final List<Map<String, String>> letterData = [
  {"letter": "أ", "image": "%D8%A3.png"},
  {"letter": "ب", "image": "%D8%A8.png"},
  {"letter": "ت", "image": "%D8%AA.png"},
  {"letter": "ث", "image": "%D8%AB.png"},
  {"letter": "ج", "image": "%D8%AC.png"},
  {"letter": "ح", "image": "%D8%AD.png"},
  {"letter": "خ", "image": "%D8%AE.png"},
  {"letter": "د", "image": "%D8%AF.png"},
  {"letter": "ذ", "image": "%D8%B0.png"},
  {"letter": "ر", "image": "%D8%B1.png"},
  {"letter": "ز", "image": "%D8%B2.png"},
  {"letter": "س", "image": "%D8%B3.png"},
  {"letter": "ش", "image": "%D8%B4.png"},
  {"letter": "ص", "image": "%D8%B5.png"},
  {"letter": "ض", "image": "%D8%B6.png"},
  {"letter": "ط", "image": "%D8%B7.png"},
  {"letter": "ظ", "image": "%D8%B8.png"},
  {"letter": "ع", "image": "%D8%B9.png"},
  {"letter": "غ", "image": "%D8%BA.png"},
  {"letter": "ف", "image": "%D9%81.png"},
  {"letter": "ق", "image": "%D9%82.png"},
  {"letter": "ك", "image": "%D9%83.png"},
  {"letter": "ل", "image": "%D9%84.png"},
  {"letter": "م", "image": "%D9%85.png"},
  {"letter": "ن", "image": "%D9%86.png"},
  {"letter": "ه", "image": "%D9%87.png"},
  {"letter": "و", "image": "%D9%88.png"},
  {"letter": "ى", "image": "%D9%89.png"},
];

final List<String> words = [
  "أحبك",

  "أضحكتنى",
  "حقا احبك",
  "لست متأكد",
  "مرحبا",
  "أنا اراقبك",
  "هذا رهيب",
  "اقتباس",
  "سؤال",
  // "هذا ممتاز",
  // "لا",
  // "انت",
  // "موافق",
  // "عمل جيد",
  // "لست متأكد",
];

List<String> sentences = [
  "اسرة",
  "اسمك ايه",
  "الحمد لله",
  "السلام عليكم",
  "بكام فلوس",
  "مستشفي",
];

logError(String message, {String? name}) {
  const red = '\x1B[38;5;196m';
  const reset = '\x1B[0m';
  log(
    '$red⛔ $message$reset',
    name: name ?? 'ErrorLogger',
    time: DateTime.now(),
  );
}

final List<Map<String, String>> imagesWithText = [
  {'image': 'assets/images/words/mom.png', 'text': 'ام'},
  {'image': 'assets/images/words/me.png', 'text': 'أنا'},
  {'image': 'assets/images/words/dad.png', 'text': 'اب'},
  {'image': 'assets/images/words/bro.png', 'text': 'أخ'},
  {'image': 'assets/images/words/sis.png', 'text': 'أخت'},
  {'image': 'assets/images/words/name.png', 'text': 'آسمك اية'},
  {'image': 'assets/images/words/hello.png', 'text': 'السلام عليكم'},
  {'image': 'assets/images/words/thank.png', 'text': 'الحمدلله'},
];
