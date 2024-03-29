import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:protofood/auth/auth_service.dart';
import 'package:protofood/config/constants.dart';
import 'package:protofood/data_models/user_data_model.dart';
import 'package:protofood/service/computation_service.dart';
import 'package:protofood/service/management_service.dart';
import 'package:protofood/views/add_building_marker_view.dart';
import 'package:protofood/views/home_view.dart';

// ignore: constant_identifier_names
enum Gender { Male, Female }

class AddUserDetailsView extends StatefulWidget {
  const AddUserDetailsView({super.key});

  @override
  State<AddUserDetailsView> createState() => _AddUserDetailsViewState();
}

class _AddUserDetailsViewState extends State<AddUserDetailsView> {
  ManagementService managementService = ManagementService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
              UserDataModel userModel = UserDataModel(
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
                gender: _gender!.name,
                contact: contact!,
                email: _emailController.text,
                timeCreated: DateTime.now(),
              );

              await managementService.addNewUser(userModel).then((isSuccess) {
                if (isSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AddBuildingMarkerView()),
                      (route) => false);
                }
              });
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
