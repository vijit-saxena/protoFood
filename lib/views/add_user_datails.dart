import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/dataplane/dataplane_service.dart';

// ignore: constant_identifier_names
enum Gender { Male, Female }

class AddUserDetailsView extends StatefulWidget {
  const AddUserDetailsView({super.key});

  @override
  State<AddUserDetailsView> createState() => _AddUserDetailsViewState();
}

class _AddUserDetailsViewState extends State<AddUserDetailsView> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  Gender? _gender = Gender.Male;

  String? contact = AuthService.firebase().currentUser?.phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: contact),
            enabled: false,
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _firstNameController,
            decoration: const InputDecoration(
              hintText: "First Name",
            ),
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: _lastNameController,
            decoration: const InputDecoration(
              hintText: "Last Name",
            ),
          ),
          ListTile(
            title: const Text('Male'),
            leading: Radio<Gender>(
              value: Gender.Male,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Female'),
            leading: Radio<Gender>(
              value: Gender.Female,
              groupValue: _gender,
              onChanged: (Gender? value) {
                setState(() {
                  _gender = value;
                });
              },
            ),
          ),
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: "Email Id",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String? contact = AuthService.firebase().currentUser?.phoneNumber;
              print(
                  "User data to submit : ${_firstNameController.text}, ${_lastNameController.text}, ${_gender!.name}, $contact, ${_emailController.text}");
              await DataplaneService.addNewUser(
                      _firstNameController.text,
                      _lastNameController.text,
                      _gender!.name,
                      contact!,
                      _emailController.text)
                  .then((value) {
                Navigator.pop(context);
              });
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
