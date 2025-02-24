import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the LoginPage

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isSidebarExpanded = true;
  final double sidebarWidth = 200.0;
  final double collapsedSidebarWidth = 60.0;
  bool isLoading = true;
  List<Map<String, dynamic>> caretaker = [];
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase.from('tbl_resident').select();
      print("Fetched data: $response");
      setState(() {
        caretaker = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
              leading: const Icon(Icons.home,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Home',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Profile',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Settings',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 24, 56, 111)),
              title: const Text('Logout',
                  style: TextStyle(color: Color.fromARGB(255, 24, 56, 111))),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          AppBar(
            title: const Text('CareTaker Wellnest'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  }),
            ],
          ),
          Container(
            color: const Color.fromARGB(230, 255, 252, 197),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('asset/login.png'),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Abin Sunny',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('ID: 123456', style: TextStyle(fontSize: 14)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
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
                return GestureDetector(
                  onTap: () {
                    
                  },
                  child: Card(
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
                          Text("Resident ID - ${index + 1}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text("Resident Name"),
                          const SizedBox(height: 8),
                          Text("Age: ${45 + index * 5}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
