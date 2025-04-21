import '/core/widgets/member_card.dart';
import '/core/utils/helper.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of team members stored in a map with their names and image URLs
    teamMembers.shuffle();
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
              Text(appDescription, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              const Text(
                "Meet the Team",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    final teamMember = teamMembers[index];
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
