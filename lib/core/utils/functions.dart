import 'helper.dart';

login(username, password) {
  log("Login function called");

  if (!username.isEmpty && !password.isEmpty) {
    log("Username and password are not empty");
    if (username == default_username && password == default_password) {
      log("Login successful");
      // Save login state
      CacheHelper.saveData(key: isLoggedInkey, value: true);
      return true;
    } else {
      log("Invalid username or password");
      return false;
    }
  } else {
    logError(
      "Username or password is empty",
      name: 'LoginLogger',
    ); // level 1000 = severe
    return false;
  }
}
