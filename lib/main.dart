import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Form with Photo Upload',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName;
  int? _age;
  String? _photoPath;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_photoPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a photo.')),
        );
        return;
      }

      try {
        // Prepare the request
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('http://localhost:3000/submit'), // Replace with your backend URL
        );

        request.fields['firstName'] = _firstName!;
        request.fields['lastName'] = _lastName!;
        request.fields['age'] = _age.toString();
        request.files.add(
          await http.MultipartFile.fromPath('photo', _photoPath!),
        );

        // Send the request
        final response = await request.send();

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form Submitted Successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit the form.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      final extension = result.files.single.extension?.toLowerCase();
      if (extension == 'jpg' || extension == 'jpeg') {
        setState(() {
          _photoPath = result.files.single.path;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a valid JPEG photo.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Form with Photo Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) => _firstName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a first name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => _lastName = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a last name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = int.tryParse(value ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickPhoto,
                    child: const Text('Upload Photo'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _photoPath == null
                          ? 'No photo selected'
                          : 'Photo: ${_photoPath!.split('/').last}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
