import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/pages/profile/settings/widgets/setting_pack.dart';
import 'package:sportmen_in_gym/pages/widgets/my_text_field.dart';

import '../../../controllers/http_controller.dart';
import '../../../models/sportsman.dart';
import '../../../services/db/sportsman_db_service.dart';

class PasswordChanger extends StatefulWidget {
  const PasswordChanger({Key? key}) : super(key: key);

  @override
  State<PasswordChanger> createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  late Sportsman _sportsman;
  final HttpController _httpController = HttpController.instance;
  final SportsmanDBService _sportsmanDBService = SportsmanDBService();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPass1Controller = TextEditingController();
  final TextEditingController _newPass2Controller = TextEditingController();
  late ValueNotifier<bool> _oldPassValidator;
  late ValueNotifier<bool> _newPass1Validator;
  late ValueNotifier<bool> _newPass2Validator;

  @override
  initState() {
    super.initState();

    _sportsman = _sportsmanDBService.getFirst()!;
    _oldPassValidator = ValueNotifier(true);
    _newPass1Validator = ValueNotifier(true);
    _newPass2Validator = ValueNotifier(true);
  }

  @override
  void dispose() {
    _oldPassValidator.dispose();
    _newPass1Validator.dispose();
    _newPass2Validator.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check, size: 28),
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (validateFields()) {
                bool success = await _httpController.putSportsman(Sportsman(
                    id: _sportsman.id,
                    email: _sportsman.email,
                    password: _newPass2Controller.text,
                    phone: _sportsman.phone,
                    firstName: _sportsman.firstName,
                    gender: _sportsman.gender,
                    iconNum: _sportsman.iconNum,
                    dateOfBirth: _sportsman.dateOfBirth,
                    subscriptions: _sportsman.subscriptions));
                if (success) {
                  _sportsman.password = _newPass2Controller.text;
                  _sportsmanDBService.put(_sportsman);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No connection'),
                  ));
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              SettingPack(children: [
                MyTextField(
                  controller: _oldPassController,
                  validation: _oldPassValidator,
                  hintText: 'Old password',
                  textAlign: TextAlign.center,
                  fontSize: 18,
                  obscureText: true,
                  errorText: 'Incorrect password',
                  inBox: true,
                ),
              ]),
              const SizedBox(height: 10),
              SettingPack(children: [
                MyTextField(
                  controller: _newPass1Controller,
                  validation: _newPass1Validator,
                  hintText: 'New password',
                  textAlign: TextAlign.center,
                  fontSize: 18,
                  obscureText: true,
                  inBox: true,
                ),
              ]),
              const SizedBox(height: 10),
              SettingPack(children: [
                MyTextField(
                  controller: _newPass2Controller,
                  validation: _newPass2Validator,
                  hintText: 'Repeat password',
                  textAlign: TextAlign.center,
                  fontSize: 18,
                  obscureText: true,
                  errorText: 'Passwords are not equals',
                  inBox: true,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    setState(() {
      _oldPassValidator.value = _oldPassController.text.isNotEmpty;
      _newPass1Validator.value = _newPass1Controller.text.isNotEmpty;
      _newPass2Validator.value = _newPass2Controller.text.isNotEmpty;
    });
    if (_oldPassController.text != _sportsman.password) {
      _oldPassValidator.value = false;
    }
    if (_newPass1Controller.text != _newPass2Controller.text) {
      _newPass2Validator.value = false;
    }
    return _oldPassValidator.value &&
        _newPass1Validator.value &&
        _newPass2Validator.value;
  }
}
