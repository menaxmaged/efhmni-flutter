import '/core/utils/helper.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Start the animation
    _controller.forward().then((_) async {
      // Check if the user is logged in by checking FirebaseAuth.instance.currentUser
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // If the user is logged in, navigate to the main screen
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // If the user is not logged in, navigate to the login screen
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for the screen
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie animation for the splash screen
                Lottie.network(
                  'https://lottie.host/2ecc6951-68d0-4d8f-8539-5b17098c102e/ArFqfNNkRV.json',
                  width: 250,
                  height: 200,
                  repeat: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
