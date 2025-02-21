import 'package:flutter/material.dart';

class UpdateHealth extends StatefulWidget {
  const UpdateHealth({super.key});

  @override
  State<UpdateHealth> createState() => _UpdateHealthState();
}

class _UpdateHealthState extends State<UpdateHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Health'),
      ),
      body: Column(
        children: [
          Text('Health Data'),
          
          
        ],
      ),
    );
  }
}