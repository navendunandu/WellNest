import 'dart:io';

import 'package:family_member/components/form_validation.dart';
import 'package:family_member/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Residentregistration extends StatefulWidget {
  const Residentregistration({super.key});

  @override
  State<Residentregistration> createState() => _ResidentregistrationState();
}

class _ResidentregistrationState extends State<Residentregistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = true;
  File? _photo;
  File? _proof;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> relation = [];
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await supabase.from('tbl_relation').select();
      print("Fetched data: $response");
      setState(() {
        relation = response;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String? selectedRelation;

  // Pick Image Function
  Future<void> _pickImage(bool isPhoto) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isPhoto) {
          _photo = File(pickedFile.path);
        } else {
          _proof = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> register() async {
    try {
      final auth = await supabase.auth.signUp(
          password: _passwordController.text, email: _emailController.text);
      String uid = auth.user!.id;
      submit(uid);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> submit(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_familymember').insert({
        'resident_id': uid,
        'resident_name': _nameController.text,
        'resident_email': _emailController.text,
        'resident_password': _passwordController.text,
        'resident_contact': _phoneController.text,
        'resident_address': _addressController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration Successful"),
          backgroundColor: Color.fromARGB(255, 86, 1, 1),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(230, 255, 252, 197),
        appBar: AppBar(
          title: Text(
            'Resident Registration Page',
            style: TextStyle(color: Color.fromARGB(230, 255, 252, 197)),
          ),
          backgroundColor: Color.fromARGB(255, 0, 38, 81),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(230, 255, 252, 197)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ),
        body: Expanded(
          child: SingleChildScrollView(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    "Resident Registration",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 24, 56, 111)),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                      _nameController,
                                      'Name',
                                      Icons.person,
                                      FormValidation.validateName),
                                  _buildTextField(
                                      _addressController,
                                      'Address',
                                      Icons.home,
                                      FormValidation.validateAddress),
                                  _buildTextField(
                                      _phoneController,
                                      'Phone',
                                      Icons.phone_android_outlined,
                                      FormValidation.validateContact),
                                  _buildTextField(
                                      _emailController,
                                      'Email',
                                      Icons.email,
                                      FormValidation.validateEmail),
                                  _buildTextField(
                                      _passwordController,
                                      'Password',
                                      Icons.lock,
                                      FormValidation.validatePassword,
                                      obscureText: true),
                                  _buildTextField(
                                    _confirmPasswordController,
                                    'Confirm Password',
                                    Icons.lock_outline,
                                    (value) =>
                                        FormValidation.validateConfirmPassword(
                                            value, _passwordController.text),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 10),
                                  DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: "Select Relation",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.white,
  ),
  value: selectedRelation, // Ensure this matches one of the values in the list
  hint: Text("Select an option"), // Hint text when no value is selected
  items: relation.map((value) {
    return DropdownMenuItem<String>(
      value: value['relation_id'].toString(), // Ensure this is unique
      child: Text(value['relation_name']),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedRelation = value; // Update the selected value
    });
  },
),
                                  const SizedBox(height: 10),
                                  const Text("Upload Proof (ID or Document)",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  _proof != null
                                      ? Image.file(_proof!, height: 100)
                                      : ElevatedButton.icon(
                                          icon: const Icon(Icons.upload_file),
                                          label: const Text("Upload Proof"),
                                          onPressed: () => _pickImage(false),
                                        ),
                                  // Upload Photo
                                  const SizedBox(height: 10),
                                  const Text("Upload Photo",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5),
                                  _photo != null
                                      ? Image.file(_photo!, height: 100)
                                      : ElevatedButton.icon(
                                          icon: const Icon(Icons.camera_alt),
                                          label: const Text("Upload Photo"),
                                          onPressed: () => _pickImage(true),
                                        ),
                                  const SizedBox(height: 20),

                                  const Divider(),
                                  const SizedBox(height: 20),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 24, 56, 111),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                      }
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                              230, 255, 252, 197)),
                                    ),
                                  ),
                                ]))),
                  ))),
        ));
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String? Function(String?)? validator,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}
