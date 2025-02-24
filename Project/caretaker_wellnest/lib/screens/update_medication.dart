import 'package:caretaker_wellnest/main.dart';
import 'package:flutter/material.dart';

class UpdateMedication extends StatefulWidget {
  const UpdateMedication({super.key});

  @override
  State<UpdateMedication> createState() => _UpdateMedicationState();
}

class _UpdateMedicationState extends State<UpdateMedication> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _foodtiming = TextEditingController();
  final TextEditingController _medicinecount = TextEditingController();
  final TextEditingController _medicinetime = TextEditingController();
  

  bool isLoading = true;

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      await supabase.from('tbl_medication').insert({
        'medication_timing': _foodtiming.text,
        'medication_count': _medicinecount.text,
        'medication_time': _medicinetime.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Updation Successful"),
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
                      "Set Routine",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 56, 111)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_foodtiming, 'Medicine timing', Icons.food_bank),
                    _buildTextField(
                      _medicinecount,
                      'Total',
                      Icons.medication_rounded,
                    ),
                    _buildTextField(
                      _medicinetime,
                      'Medicines time',
                      Icons.av_timer,
                    ),
              
                    const Divider(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 24, 56, 111),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        {
                          submit();
                        }
                      },
                      child: const Text(
                        'Update Medication',
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
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
      ),
    );
  }
}