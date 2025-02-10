import 'package:family_member/components/form_validation.dart';
import 'package:family_member/screens/userregistration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isVisible = true;

  String email = '';
  String password = '';

  void submit() {
    setState(() {
      email = emailController.text;
      password = passwordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 24, 56, 111)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Login Page",
          style: TextStyle(
            color: Color.fromARGB(255, 24, 56, 111),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(230, 255, 252, 197),
        elevation: 0,
      ),
      body: Container(
        color: const Color.fromARGB(
            230, 255, 252, 197), // Set background color here
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 24, 56, 111), // Updated color
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Login to Continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 24, 56, 111),
                          fontSize: 15),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Email Address",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(255, 24, 56, 111),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: (value) => FormValidation.validateEmail(value),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 24, 56, 111),
                            width: 1,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 24, 56, 111),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(255, 24, 56, 111),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) =>
                          FormValidation.validatePassword(value),
                      obscureText: _isVisible,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 24, 56, 111),
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: Icon(_isVisible
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 24, 56, 111),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print("Validated");
                          submit();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const ContinuousRectangleBorder(),
                        backgroundColor: const Color.fromARGB(255, 24, 56, 111),
                        fixedSize: const Size(
                            100, 55), // Ensures button is exactly this size
                      ),
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Color.fromARGB(230, 255, 252, 197),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Add "Create Account" link here
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: "If you do not have an account, ",
                          style: GoogleFonts.lato(
                            // Change 'lato' to any font you want
                            color: Colors.black, // Normal text color
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: "Create Account",
                              style: GoogleFonts.lato(
                                color: Color.fromARGB(
                                    255, 24, 56, 111), // Hyperlink color
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration
                                    .underline, // Underline for hyperlink effect
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Navigate to the UserRegistration page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Userregistration(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(
                      'asset/login.png',
                      fit: BoxFit.contain,
                      height: 300,
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
}
