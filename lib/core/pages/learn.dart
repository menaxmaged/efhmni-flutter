import '/core/utils/helper.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  // List of button texts
  final List<String> buttonTexts = [
    "الارقــام", // Numbers
    "الحروف", // Letters
    "الكلمات", // Words
    "الجمل", // Sentences
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text("Learning"),
        transitionBetweenRoutes: true,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", height: 200, width: 250),
                const SizedBox(
                  height: 40,
                ), // Adds space between the logo and buttons
                // Using Wrap to loop over the buttons list
                Wrap(
                  spacing: 20, // Horizontal space between buttons
                  runSpacing: 20, // Vertical space between rows of buttons
                  alignment:
                      WrapAlignment.center, // Center the buttons horizontally
                  children:
                      buttonTexts.map((text) {
                        return _buildModernButton(
                          text: text,
                          onTap: () {
                            print("going to $text");
                            // Navigate to the corresponding learning page
                            // For example, if the button text is "الرقــام", navigate to NumbersPage
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => NumbersPage(),
                            //   ),
                            // );
                            // Add your navigation logic here
                            // For example, you can use a switch case or if-else statements
                            // to navigate to different pages based on the button text
                            // Example:
                            if (text == "الارقــام") {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => NumbersPage(),
                                ),
                              );
                            } else if (text == "الحروف") {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => LettersPage(),
                                ),
                              );
                            }
                            // Add similar conditions for other buttons
                            // For now, just print the button text
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modern styled button widget with increased size and same width
  Widget _buildModernButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              170, // Set maximum width for all buttons to ensure uniform size
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 40,
        ), // Increased padding for larger buttons
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7E4AEF), // Your specified color
              Color.fromARGB(
                255,
                88,
                131,
                243,
              ), // You can choose a second color to complement it
            ], // Teal to Blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.inactiveGray.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 24, // Increased font size for a more prominent text
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Center align the text
          ),
        ),
      ),
    );
  }
}
