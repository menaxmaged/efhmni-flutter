import '/core/utils/helper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showLanguageSelector() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: const Text("Select Language"),
            actions: [
              CupertinoActionSheetAction(
                child: const Text("English"),
                onPressed: () {
                  Navigator.pop(context);
                  print("Language changed to English");
                },
              ),
              CupertinoActionSheetAction(
                child: const Text("Arabic"),
                onPressed: () {
                  Navigator.pop(context);
                  print("Language changed to Arabic");
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ),
    );
  }

  void _showThemeSelector() {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            title: const Text("Select Theme"),
            actions: [
              CupertinoActionSheetAction(
                child: const Text("Light"),
                onPressed: () {
                  log("Switched to Light Theme");
                  CacheHelper.saveData(key: isDarkModekey, value: false);
                  // Update the app theme
                },
              ),
              CupertinoActionSheetAction(
                child: const Text("Dark"),
                onPressed: () {
                  Navigator.pop(context);
                  log("Switched to Dark Theme");
                  CacheHelper.saveData(key: isDarkModekey, value: true);
                  // Update the app theme
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text("Settings"),
      ),
      child: SafeArea(
        child: Container(
          child: ListView(
            padding: const EdgeInsets.only(top: 30),
            children: [
              const SizedBox(height: 20),

              /// Section: Preferences
              CupertinoListSection.insetGrouped(
                header: const Text(
                  "Preferences",
                  //     style: TextStyle(color: CupertinoColors.white),
                ),
                backgroundColor: CupertinoColors.transparent,

                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.globe),
                    title: const Text("Change Language"),
                    onTap: _showLanguageSelector,
                  ),
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.paintbrush),
                    title: const Text("Change Theme"),
                    onTap: _showThemeSelector,
                  ),
                ],
              ),

              /// Section: Account
              CupertinoListSection.insetGrouped(
                header: const Text("Account"),
                backgroundColor: CupertinoColors.transparent,
                children: [
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.gear),
                    title: const Text("Reset Settings"),
                    onTap: () {
                      log("Settings reset to default");
                      CacheHelper.clear();
                      // Reset app settings to default
                    },
                  ),
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.arrow_right_to_line),
                    title: const Text("Logout"),
                    onTap: () async {
                      await CacheHelper.clear();

                      Navigator.pop(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        //        (route) => false, // Remove all previous routes
                      );
                    },
                  ),
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.trash),

                    title: const Text("Delete Account"),
                    onTap: () async {
                      await CacheHelper.clear();

                      // Navigate to SplashScreen and remove all previous routes
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
