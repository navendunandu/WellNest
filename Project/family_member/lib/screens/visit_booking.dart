import 'package:flutter/material.dart';

class VisitBooking extends StatefulWidget {
  const VisitBooking({super.key});

  @override
  State<VisitBooking> createState() => _VisitBookingState();
}

class _VisitBookingState extends State<VisitBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(230, 255, 252, 197),
      appBar: AppBar(
        title: const Text('Visit Booking'),
        backgroundColor: Color.fromARGB(255, 0, 36, 94),
        foregroundColor: Colors.white,
      ),
    );
  }
}