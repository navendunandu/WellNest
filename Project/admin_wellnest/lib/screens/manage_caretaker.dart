import 'package:admin_wellnest/components/form_validation.dart';
import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';

class ManageCaretaker extends StatefulWidget {
  const ManageCaretaker({super.key});

  @override
  State<ManageCaretaker> createState() => _ManageCaretakerState();
}

class _ManageCaretakerState extends State<ManageCaretaker> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = true;
  List<Map<String, dynamic>> caretaker = [];

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
      final response = await supabase.from('tbl_caretaker').select();
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

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await supabase.from('tbl_caretaker').insert({
          'caretaker_name': nameController.text,
          'caretaker_email': emailController.text,
          'caretaker_password': passwordController.text,
          'caretaker_contact': phoneController.text,
        });

        print("Insert Successful");

        // Clear fields after successful submission
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        phoneController.clear();
        formKey.currentState!.reset();

        // Refresh data after insert
        await fetchData();
      } catch (e) {
        print("Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
 Future<void> deleteRoom(int id) async {
    try {
      await supabase.from('tbl_caretaker').delete().eq('caretaker_id', id);
      print("Delete Successful");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Details deleted successfully!'),
          backgroundColor: const Color.fromARGB(255, 0, 61, 2),
        ),
      );
      print("Deleted caretaker details with id: $id");
      fetchData();
    } catch (e) {
      print("Error deleting caretaker: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete details. Please try again.'),
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
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white, 
            margin: EdgeInsets.symmetric(horizontal: 100, vertical: 30),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Add Caretaker",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 56, 111),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                        nameController,
                        "Name",
                        "Enter Caretaker Name",
                        Icons.person,
                        (value) => FormValidation.validateName(value)),
                    _buildTextField(
                        emailController,
                        "Email",
                        "Enter Email",
                        Icons.email,
                        (value) => FormValidation.validateEmail(value)),
                    _buildTextField(
                        passwordController,
                        "Password",
                        "Enter Password",
                        Icons.lock,
                        (value) => FormValidation.validatePassword(value),
                        obscureText: true),
                    _buildTextField(
                        confirmPasswordController,
                        "Confirm Password",
                        "Re-enter Password",
                        Icons.lock_outline,
                        (value) => FormValidation.validateConfirmPassword(
                            value, passwordController.text),
                        obscureText: true),
                    _buildTextField(
                        phoneController,
                        "Contact",
                        "Enter Contact Information",
                        Icons.phone,
                        (value) => FormValidation.validateContact(value)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 20),
                    Text(
                      "Caretaker List",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 56, 111),
                      ),
                    ),
                    SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator()
                        : caretaker.isEmpty
                            ? Text("No caretakers found.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: caretaker.length,
                                itemBuilder: (context, index) {
                                  final data = caretaker[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: ListTile(
                                      title: Text(data['name']),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Email: ${data['email']}"),
                                          Text("Contact: ${data['contact']}"),
                                          IconButton(
                                        icon: Icon(Icons.delete,
                                            color: const Color.fromARGB(
                                                255, 67, 4, 0)),
                                        onPressed: () {
                                          deleteRoom(data['caretaker_id']);
                                        },
                                      ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon, String? Function(String?)? validator,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Color.fromARGB(255, 24, 56, 111)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: Color.fromARGB(255, 24, 56, 111), width: 2),
          ),
        ),
      ),
    );
  }
}
