import 'package:flutter/material.dart';

class MoreDetailsScreen extends StatelessWidget {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController eddController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
                }
              },
            ),
            TextField(
              controller: eddController,
              decoration: const InputDecoration(labelText: 'EDD or LMP Date'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  eddController.text = "${pickedDate.toLocal()}".split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Submit details to backend or skip
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
