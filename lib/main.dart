import 'core/utils/helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//test
//const force_cupertino = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async before runApp

  await CacheHelper.init();
  log("isLoggedIn = $isLoggedIn");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Esm3niCupertino());
  /*
  if (kIsWeb) {
    runApp(Esm3niMaterial(appName: appName));
  } else if (Platform.isIOS || Platform.isMacOS) {
    if (force_cupertino) {
      runApp(Esm3niCupertino());
    } else {
      runApp(Esm3niMaterial(appName: appName));
    }
  } else {
    if (force_cupertino) {
      runApp(Esm3niCupertino( ));
    } else {
      runApp(Esm3niMaterial(appName: appName));
    }
  }
*/
}

class Esm3niCupertino extends StatelessWidget {
  const Esm3niCupertino({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: appName,
      theme: mytheme(context),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      //   initialRoute: '/', // You can define the initial route here
      //   routes: {
      //     '/splash': (context) => const SplashScreen(),
      //     '/home': (context) => const HomePage(),
      //     '/settings': (context) => const SettingsPage(),

      //     // Add other routes here
      //   },
      //
    );
  }
}
