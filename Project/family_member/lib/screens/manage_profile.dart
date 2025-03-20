import 'package:family_member/main.dart';
import 'package:family_member/screens/fam_profile.dart';
import 'package:family_member/screens/homepage.dart';
import 'package:family_member/screens/login_page.dart';
import 'package:family_member/screens/visit_booking.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'residentregistration.dart';

class ManageProfile extends StatefulWidget {
  const ManageProfile({super.key});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? familyMember;

  @override
  void initState() {
    super.initState();
    fetchFamilyMember();
  }

  Future<void> fetchFamilyMember() async {
    try {
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        debugPrint("User not logged in.");
        return;
      }

      final response = await supabase
          .from('tbl_familymember')
          .select()
          .eq('familymember_id', userId)
          .maybeSingle();

      if (mounted) {
        setState(() {
          familyMember = response;
        });
      }
    } catch (error) {
      debugPrint("Error fetching family member: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text(
          'Manage Profiles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (familyMember != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamProfile(
                      familymemberID:
                          familyMember!['familymember_id'].toString(),
                    ),
                  ),
                );
              }
            },
            child: CircleAvatar(
              backgroundImage: familyMember?['familymember_photo'] != null
                  ? NetworkImage(familyMember!['familymember_photo'])
                  : const AssetImage('assets/default_avatar.png')
                      as ImageProvider,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: ProfileGrid(),
    );
  }
}

class ProfileGrid extends StatefulWidget {
  const ProfileGrid({super.key});

  @override
  State<ProfileGrid> createState() => _ProfileGridState();
}

class _ProfileGridState extends State<ProfileGrid> {
  List<Map<String, dynamic>> residents = [];

  @override
  void initState() {
    super.initState();
    fetchResident();
  }

  Future<void> fetchResident() async {
    try {
      final response = await supabase
          .from('tbl_resident')
          .select()
          .eq('familymember_id', supabase.auth.currentUser!.id);
      print(response);
      setState(() {
        residents = response;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(230, 255, 252, 197),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: residents.length + 1, // +1 for the add profile card
        itemBuilder: (context, index) {
          if (index < residents.length) {
            return ProfileCard(profile: residents[index]);
          } else {
            return const AddProfileCard();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitBooking(),
              ));
        },
        label: const Text(
          'Book Visit',
          style: TextStyle(color: Colors.white, fontSize: 20), // Set text color
        ),
        icon: const Icon(Icons.event, color: Colors.white), // Set icon color
        backgroundColor: Color.fromARGB(255, 0, 36, 94), // Custom ARGB color
        foregroundColor: Colors.white, // Ensures icon and text are white
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(profile: profile['resident_id'])),
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
              CircleAvatar(
                backgroundImage: NetworkImage(profile['resident_photo']),
                radius: 50,
              ),
              const SizedBox(height: 8.0),
              Text(
                profile['resident_name'],
                style: const TextStyle(
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
