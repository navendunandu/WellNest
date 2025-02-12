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

  Future<void> submit() async {
    try {
      await supabase.from('tbl_caretaker').insert({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'contact': phoneController.text,
      });

      print("Insert Successful");

      // Clear fields after successful submission
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      phoneController.clear();
      formKey.currentState!.reset();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 227, 242, 253), // Light Blue Background
      padding: EdgeInsets.all(30), // Some padding for spacing
      child: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white, // White card for contrast
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          submit();
                        }
                      },
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
