import '/core/utils/helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController username = TextEditingController();
    TextEditingController password = TextEditingController();

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding for the screen
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "logo",
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: 200,
                      width: 250,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ), // Adds space between the logo and other elements
                  CupertinoTextField(
                    placeholder: 'Username',
                    controller: username,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // Adds space between the text field and the button
                  CupertinoTextField(
                    placeholder: 'Password',
                    controller: password,
                    padding: const EdgeInsets.all(16.0),
                    obscureText: true,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // Adds space between the text field and the button
                  SizedBox(
                    width: double.infinity,

                    child: CupertinoButton.filled(
                      onPressed: () {
                        // Handle login action
                        if (login(username.text, password.text)) {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const MainScreen(),
                            ),
                          );
                        } else {
                          // Handle login failure

                          log(
                            "Login failed for user: ${username.text}",
                            name: 'LoginLogger',
                            level: 3000,
                          ); // level 1000 = severe
                          showCupertinoDialog(
                            context: context,
                            builder:
                                (context) => CupertinoAlertDialog(
                                  title: const Text('Login Failed'),
                                  content: const Text(
                                    'Invalid username or password.',
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        // Handle sign up action
                        print("Sign Up button pressed");
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  // Adds space between the button and the text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
