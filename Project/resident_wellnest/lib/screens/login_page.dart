import 'package:resident_wellnest/components/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:resident_wellnest/main.dart';
import 'package:resident_wellnest/screens/homepage.dart';
// import 'package:flutter/gestures.dart';

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
  bool _isLoading = false;

  String email = '';
  String password = '';

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        email = emailController.text;
        password = passwordController.text;
      });

      try {
        // Sign in with email and password
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        
        final resident = await supabase
            .from('tbl_resident')
            .select()
            .eq('resident_id', response.user!.id)
            .single();
        print('resident: $resident');

        if (resident.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        } else {
          // Handle invalid credentials
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } catch (e) {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    
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
        color: const Color.fromARGB(230, 255, 252, 197),
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
                        color: Color.fromARGB(255, 24, 56, 111),
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
                      onPressed: _isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        shape: const ContinuousRectangleBorder(),
                        backgroundColor: const Color.fromARGB(255, 24, 56, 111),
                        fixedSize: const Size(100, 55),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Sign in",
                              style: TextStyle(
                                color: Color.fromARGB(230, 255, 252, 197),
                                fontSize: 20,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
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
