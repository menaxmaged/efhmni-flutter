import 'package:flutter/material.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String imageUrl;

  const TeamMemberCard({required this.name, required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    // print("Team Member Card: $name");
    // print("object: $imageUrl");
    // Using a Card widget to create a card-like appearance

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          // Using CircleAvatar to display the team member's image
          radius: 30,

          backgroundImage: AssetImage(imageUrl),
        ),
        title: Text(name),
        subtitle: const Text("Role: Developer"),
        //tileColor: Colors.white,

        // Customize role as needed
        // trailing: IconButton(
        //   icon: const Icon(Icons.message),
        //   onPressed: () {
        //     // Handle message button press
        //     // You can implement your messaging functionality here
        //   },
        // ),
      ),
    );
  }
}
