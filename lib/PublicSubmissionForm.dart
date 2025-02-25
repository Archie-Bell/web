import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Public Submission Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("* All provided inputs are mandatory."),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: "Who is this missing person?"),
                onSaved: (value) => _missingPersonName = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Where have you last seen this person?"),
                onSaved: (value) => _lastSeenLocation = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "How long has it been since their last appearance?"),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 10),
              const Text("Do you have a photo of this missing person?"),
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
              TextFormField(
                decoration: const InputDecoration(labelText: "Anything else you want us to know?"),
                onSaved: (value) => _additionalInfo = value,
              ),
              const SizedBox(height: 20),
              const Text("Can we have your contact information?"),
              TextFormField(
                decoration: const InputDecoration(labelText: "Legal Name"),
                onSaved: (value) => _contactName = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _contactPhone = value,
                validator: (value) => value!.isEmpty ? 'This field is required' : null,
              ),
              const SizedBox(height: 20),
              const Text("Ensure the details you provided are accurate before submitting."),
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
    );
  }
}