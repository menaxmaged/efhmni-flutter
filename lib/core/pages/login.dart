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
                      onPressed: () async {
                        // Handle login action

                        // Call the login function
                        var result = await login(username.text, password.text);

                        // Check if login was successful
                        if (result == true) {
                          // Navigate to the next page on success
                          Navigator.pop(context);
                        } else {
                          // Display error message
                          showCupertinoDialog(
                            context: context,
                            builder:
                                (context) => CupertinoAlertDialog(
                                  title: const Text('Login Failed'),
                                  content: Text(result),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
