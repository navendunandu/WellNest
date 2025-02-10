import 'package:admin_wellnest/components/sidebar_button.dart';
import 'package:admin_wellnest/screens/dashboard.dart';
import 'package:admin_wellnest/screens/manage_room.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> pages = [
    {'icon': Icons.home, 'label': 'Home', 'page': Dashboard()},
    {
      'icon': Icons.room_preferences,
      'label': 'Manage Room',
      'page': ManageRoom()
    },
    {
      'icon': Icons.local_hospital_sharp,
      'label': 'Manage Caretaker',
      'page': Dashboard()
    },
    {
      'icon': Icons.wallet_membership,
      'label': 'Family Member',
      'page': Dashboard()
    },
    {'icon': Icons.person_outlined, 'label': 'Resident', 'page': Dashboard()},
    {'icon': Icons.feedback, 'label': 'Feedback', 'page': Dashboard()},
    {'icon': Icons.feedback_sharp, 'label': 'Complaints', 'page': Dashboard()},
  ];

  Widget currentPage = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF0DC),
            ),
            child: SizedBox(
              child: ListView(
                children: [
                  Text("Administrator",
                      style: TextStyle(
                          color: Color(0xFF543A14),
                          fontSize: 25,
                          letterSpacing: 2)),
                  SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'asset/logo.jpg',
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                  Text("Admin Name",
                      style: TextStyle(
                          color: Color(0xFF543A14),
                          fontSize: 20,
                          letterSpacing: 2)),
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentPage = page['page'];
                          });
                        },
                        child: SideButton(
                          icon: page['icon'] ?? Icons.home,
                          label: page['label'] ?? "Home",
                        ),
                      );
                    },
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        Text("          Logout",
                            style: TextStyle(
                                color: Color(0xFF543A14),
                                fontSize: 15,
                                letterSpacing: 2)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // child: Text("Sidebar")
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: currentPage),
        )
      ],
    ));
  }
}
