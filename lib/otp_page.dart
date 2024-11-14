import 'package:flutter/material.dart';
import 'package:notedeck_app/newpass_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  // Controllers for each OTP box
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter OTP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 241, 223, 58),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // OTP Input Fields (4 boxes)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _otpBox(_otpController1),
                _otpBox(_otpController2),
                _otpBox(_otpController3),
                _otpBox(_otpController4),
              ],
            ),

            const SizedBox(
                height: 40), // Space between OTP boxes and the button

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Get OTP values
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateNewPasswordPage()),
                );

                // You can add OTP verification logic here
                // For now, we'll just print the OTP
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP Submitted: ')),
                );
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Full-width button
                backgroundColor:
                    const Color.fromARGB(255, 241, 223, 58), // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create each OTP box
  Widget _otpBox(TextEditingController controller) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1, // Only one digit per box
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none, // No border needed
          ),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
