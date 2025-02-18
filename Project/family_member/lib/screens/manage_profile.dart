import 'package:family_member/screens/landingpage.dart';
import 'package:flutter/material.dart';
import 'residentregistration.dart'; // Import the ResidentRegistration class

void main() {
  runApp(const ManageProfile());
}

class ManageProfile extends StatelessWidget {
  const ManageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Profiles',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text(
          'Manage Profiles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(230, 255, 252, 197),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 24, 56, 111),
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined,
              color: Color.fromARGB(230, 255, 252, 197)),
          onPressed: () {
            Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Landingpage()));
          },
        ),
      ),
      body: ProfileGrid(),
    );
  }
}

class ProfileGrid extends StatelessWidget {
  final List<Profile> profiles = [
    Profile(name: 'User 1', imageUrl: 'https://via.placeholder.com/150'),
    Profile(name: 'User 2', imageUrl: 'https://via.placeholder.com/150'),
    // Add more profiles here
  ];

  ProfileGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: profiles.length + 1, // +1 for the add profile card
      itemBuilder: (context, index) {
        if (index < profiles.length) {
          return ProfileCard(profile: profiles[index]);
        } else {
          return const AddProfileCard();
        }
      },
    );
  }
}

class Profile {
  final String name;
  final String imageUrl;

  Profile({required this.name, required this.imageUrl});
}

class ProfileCard extends StatelessWidget {
  final Profile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profile.imageUrl),
              radius: 50,
            ),
            const SizedBox(height: 8.0),
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 56, 111),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProfileCard extends StatelessWidget {
  const AddProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Residentregistration()),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Add Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 24, 56, 111),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}