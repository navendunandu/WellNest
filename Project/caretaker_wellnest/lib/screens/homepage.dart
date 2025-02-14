import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSidebarExpanded = true;
  final double sidebarWidth = 200.0;
  final double collapsedSidebarWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(230, 255, 252, 197),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 24, 56, 111),
              ),
              child: const Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: const Text('Home',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Profile',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Settings',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Expanded(
        child: Column(
          children: [
            AppBar(
              title: const Text('CareTaker Wellnest'),
            ),
            Container(
              color: const Color.fromARGB(230, 255, 252, 197),
              height: 100,
              width: double.infinity,
              child: Row(
                children: [
                  
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Abin Sunny'),
                          Text('ID: 123456'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 250,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'asset/login.png', // Replace with the actual path to the caretaker's photo
                      height: 80,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            // GridView Content
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/parentlandingpage.png',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                          Text("Resident ID - ${index + 1}"),
                          const SizedBox(height: 8),
                          const Text("Resident Name"),
                          const SizedBox(height: 8),
                          Text("Age: ${45 + index * 5}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
