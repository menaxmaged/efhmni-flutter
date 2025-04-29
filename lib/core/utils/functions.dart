import 'package:firebase_auth/firebase_auth.dart';

import 'helper.dart';

login(username, password) async {
  log("Login function called");

  if (username.isEmpty || password.isEmpty) {
    logError("Username or password is empty", name: 'LoginLogger'); // Log error
    return "Please provide both username and password."; // Return a message instead of throwing here
  }

  log("Username and password are not empty");

  try {
    AuthService authService = AuthService();
    await authService.signIn(email: username, password: password);
    return true; // Return true if login is successful
  } on FirebaseAuthException catch (e) {
    logError("Firebase Auth Error: ${e.message}", name: 'AuthService');
    return e.message; // Return Firebase error message
  }
}
