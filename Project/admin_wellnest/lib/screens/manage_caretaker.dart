import 'dart:io';
import 'dart:typed_data';

import 'package:admin_wellnest/components/form_validation.dart';
import 'package:admin_wellnest/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  PlatformFile? pickedImage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only single file upload
    );
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
      });
    }
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

  Future<void> register() async {
    try {
      final auth = await supabase.auth.signUp(
          password: passwordController.text, email: emailController.text);
      String uid = auth.user!.id;
      submit(uid);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submit(String uid) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String? url = await photoUpload(uid);
        if (url!.isNotEmpty) {
          await supabase.from('tbl_caretaker').insert({
            'caretaker_id': uid,
            'caretaker_name': nameController.text,
            'caretaker_email': emailController.text,
            'caretaker_password': passwordController.text,
            'caretaker_contact': phoneController.text,
            'caretaker_photo': url,
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Caretaker details updated successfully!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 0, 40, 1),
        ));
        print("Insert Successful");

        // Clear fields after successful submission
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        phoneController.clear();
        formKey.currentState!.reset();
        setState(() {
          pickedImage = null;
        });
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

  Future<String?> photoUpload(String uid) async {
    try {
      final bucketName = 'ct_files'; // Replace with your bucket name
      final filePath = "$uid-${pickedImage!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!, // Use file.bytes for Flutter Web
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);
      // await updateImage(uid, publicUrl);
      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
      return null;
    }
  }

  Future<void> deletecaretaker(String id) async {
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 24, 56, 111),
            Color.fromARGB(255, 251, 247, 179),
          ],
        ),
      ),
      padding: EdgeInsets.all(30),
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 56, 111),
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black12,
                            offset: Offset(1, 1),
                          )
                        ],
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
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: pickedImage == null
                          ? GestureDetector(
                              onTap: handleImagePick,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Color(0xFF0277BD),
                                size: 50,
                              ),
                            )
                          : GestureDetector(
                              onTap: handleImagePick,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: pickedImage!.bytes != null
                                    ? Image.memory(
                                        Uint8List.fromList(
                                            pickedImage!.bytes!), // For web
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(pickedImage!
                                            .path!), // For mobile/desktop
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black26,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 56, 111),
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black12,
                            offset: Offset(1, 1),
                          )
                        ],
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
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        data['caretaker_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Email: ${data['caretaker_email']}"),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Contact: ${data['caretaker_contact']}"),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 67, 4, 0)),
                                                  onPressed: () {
                                                   deletecaretaker(data['caretaker_id'].toString());
                                                  },
                                                ),
                                              ),
                                            ],
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
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
