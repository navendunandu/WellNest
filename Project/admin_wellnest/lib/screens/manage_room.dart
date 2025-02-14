import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';

class ManageRoom extends StatefulWidget {
  const ManageRoom({super.key});

  @override
  State<ManageRoom> createState() => _ManageRoomState();
}

class _ManageRoomState extends State<ManageRoom> {
  final nameController = TextEditingController();
  final countController = TextEditingController();
  final priceController = TextEditingController();
  bool isLoading = true;
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase.from('tbl_room').select();
      print("Fetched data: $response");
      setState(() {
        rooms = response;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_room').insert({
        'name': nameController.text,
        'count': countController.text,
        'price': priceController.text,
      });

      print("Insert Successful");
      nameController.clear();
      countController.clear();
      priceController.clear();
      await fetchData(); // Refresh data after insert
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to delete a room
  Future<void> deleteRoom(int id) async {
    try {
      await supabase.from('tbl_room').delete().eq('room_id', id);
      print("Delete Successful");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Room deleted successfully!'),
          backgroundColor: const Color.fromARGB(255, 0, 61, 2),
        ),
      );
      print("Deleted room with id: $id");
      await fetchData(); // Refresh data after delete
    } catch (e) {
      print("Error deleting room: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete room. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 227, 242, 253),
      padding: EdgeInsets.all(30),
      child: Center(
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Manage Rooms',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 56, 111)),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(nameController, "Room Name",
                      "Enter Room Name", Icons.room),
                  _buildTextField(countController, "Count", "Enter Total Count",
                      Icons.numbers),
                  _buildTextField(priceController, "Price", "Enter Price",
                      Icons.price_check),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 24, 56, 111),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text(
                      "Submit",
                      style:
                          TextStyle(color: Color.fromARGB(255, 227, 242, 253)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(),
                  SizedBox(height: 15),
                  isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: rooms.length,
                            itemBuilder: (context, index) {
                              final data = rooms[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  title: Text(data['name']),
                                  subtitle: Text('Count: ${data['count']}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Price: \$${data['price']}'),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: const Color.fromARGB(
                                                255, 67, 4, 0)),
                                        onPressed: () {
                                          deleteRoom(data['room_id']);
                                        },
                                      ),
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
          ),
        ),
      ),
    );
  }
  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 24, 56, 111)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
