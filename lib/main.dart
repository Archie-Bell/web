import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web/admin_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Missing Person Submission',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PublicSubmissionForm(),
    );
  }
}

class PublicSubmissionForm extends StatefulWidget {
  const PublicSubmissionForm({super.key});

  @override
  State<PublicSubmissionForm> createState() => _PublicSubmissionFormState();
}

class _PublicSubmissionFormState extends State<PublicSubmissionForm> {
  final _formKey = GlobalKey<FormState>();
  String? _missingPersonName;
  String? _lastSeenLocation;
  String? _contactName;
  String? _contactPhone;
  String? _additionalInfo;
  String? _fileName;
  DateTime? _lastSeenDate;
  TimeOfDay? _lastSeenTime;

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _lastSeenDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _lastSeenTime = pickedTime;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Manually format the date as MM/DD/YY
    String formattedDate = _lastSeenDate != null
        ? "${_lastSeenDate!.month.toString().padLeft(2, '0')}/${_lastSeenDate!.day.toString().padLeft(2, '0')}/${_lastSeenDate!.year.toString().substring(2, 4)}"
        : "MM/DD/YY";

    // Manually format the time as hh:mm AM/PM
    String formattedTime = _lastSeenTime != null
        ? "${_lastSeenTime!.hourOfPeriod.toString().padLeft(2, '0')}:${_lastSeenTime!.minute.toString().padLeft(2, '0')} ${_lastSeenTime!.period == DayPeriod.am ? 'AM' : 'PM'}"
        : "HH:MM AM/PM";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Missing Person Form'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to Admin Panel
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLoginPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // Set text color to black
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding for better visibility
              side: const BorderSide(color: Colors.black, width: 1), // Add black border around the button
            ),
            child: const Text('Admin Panel'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust width to 80% of screen width
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("* All provided inputs are mandatory."),
                  const SizedBox(height: 10),

                  // Row to split the form into two columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align both columns to the top
                    children: [
                      // First column with form fields
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Missing Person Name Label and TextField
                            const Text(
                              'Who is this missing person?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter the name of the missing person',
                              ),
                              onSaved: (value) => _missingPersonName = value,
                              validator: (value) => value!.isEmpty ? 'This field is required' : null,
                            ),

                            const SizedBox(height: 10),

                            // Last Seen Location Label and TextField
                            const Text(
                              'Where have you last seen this person?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter the last known location',
                              ),
                              onSaved: (value) => _lastSeenLocation = value,
                              validator: (value) => value!.isEmpty ? 'This field is required' : null,
                            ),

                            const SizedBox(height: 10),
                            const Text(
                              "How long has it been since their last appearance?",
                              style: TextStyle(fontWeight: FontWeight.w600)
                              ),
                            const SizedBox(height: 10),
                            // Date and Time Picker on the same line
                            Row(
                              children: [
                                const Text("Date: "), // Label for Date
                                ElevatedButton(
                                  onPressed: _selectDate,
                                  child: Text(formattedDate), // Show formatted date
                                ),
                                const SizedBox(width: 20), // Spacer between date and time
                                const Text("Time: "), // Label for Time
                                ElevatedButton(
                                  onPressed: _selectTime,
                                  child: Text(formattedTime), // Show formatted time
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Do you have a photo of this missing person?",
                              style: TextStyle(fontWeight: FontWeight.w600)
                              ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: _pickPhoto,
                                  child: const Text("Choose File"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(_fileName ?? "No file chosen"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      // Second column for Contact Information
                      const SizedBox(width: 20), // Spacer between columns
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Can we have your contact information?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              'Legal Name:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your legal name',
                              ),
                              onSaved: (value) => _contactName = value,
                              validator: (value) => value!.isEmpty ? 'This field is required' : null,
                            ),
                            const SizedBox(height: 10),

                            const Text(
                              'Phone Number:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter your phone number',
                              ),
                              keyboardType: TextInputType.phone,
                              onSaved: (value) => _contactPhone = value,
                              validator: (value) => value!.isEmpty ? 'This field is required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // The "Anything else you want us to know?" section below the two columns
                  const SizedBox(height: 20),
                  const Text(
                    'Anything else you want us to know?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  TextFormField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Additional information (optional)',
                    ),
                    onSaved: (value) => _additionalInfo = value,
                  ),
                  const SizedBox(height: 20),

                  const Center(
                    child: Text(
                      "Ensure the details you provided are accurate before submitting.",
                      textAlign: TextAlign.center, 
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Submit Form"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
