import 'package:family_member/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:family_member/components/form_validation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class Userregistration extends StatefulWidget {
  const Userregistration({super.key});

  @override
  State<Userregistration> createState() => _UserregistrationState();
}

class _UserregistrationState extends State<Userregistration> {
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
    } catch (e) {}
  }

  Future<void> submit(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_familymember').insert({
        'familymember_id': uid,
        'familymember_name': _nameController.text,
        'familymember_email': _emailController.text,
        'familymember_password': _passwordController.text,
        'familymember_contact': _phoneController.text,
        'familymember_address': _addressController.text,
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
        title: const Text(
          "Create Account",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(230, 255, 252, 197)),
        ),
        backgroundColor: Color.fromARGB(255, 24, 56, 111),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(230, 255, 252, 197)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Family Member Registration",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 56, 111)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_nameController, 'Name', Icons.person,
                        FormValidation.validateName),
                    _buildTextField(_addressController, 'Address', Icons.home,
                        FormValidation.validateAddress),
                    _buildTextField(_emailController, 'Email', Icons.email,
                        FormValidation.validateEmail),
                    _buildTextField(_passwordController, 'Password', Icons.lock,
                        FormValidation.validatePassword,
                        obscureText: true),
                    _buildTextField(
                      _confirmPasswordController,
                      'Confirm Password',
                      Icons.lock_outline,
                      (value) => FormValidation.validateConfirmPassword(
                          value, _passwordController.text),
                      obscureText: true,
                    ),
                    _buildTextField(_phoneController, 'Phone Number',
                        Icons.phone, FormValidation.validateContact),

                    // Upload Proof
                    const SizedBox(height: 10),
                    const Text("Upload Proof (ID or Document)",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    _photo != null
                        ? Image.file(_photo!, height: 100)
                        : ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Upload Photo"),
                            onPressed: () => _pickImage(true),
                          ),

                    const Divider(),

                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                            color: Color.fromARGB(230, 255, 252, 197)),
                      ),
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
