import '/core/widgets/member_card.dart';
import '/core/utils/helper.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late List<Map<String, String>> shuffledTeamMembers;

  @override
  void initState() {
    super.initState();
    shuffledTeamMembers = List<Map<String, String>>.from(teamMembers)
      ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text("About Us"),
        transitionBetweenRoutes: true,
        previousPageTitle: "Back",
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(appDescription, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              const Text(
                "Meet the Team",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: shuffledTeamMembers.length,
                  itemBuilder: (context, index) {
                    final teamMember = shuffledTeamMembers[index];
                    return TeamMemberCard(
                      name: teamMember['name']!,
                      imageUrl: teamMember['imageUrl']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
