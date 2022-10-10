import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../controllers/http_controller.dart';
import '../../controllers/db_controller.dart';
import '../../models/sportsman.dart';
import 'widgets/field_name.dart';
import 'widgets/auth_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final HttpController _httpController = HttpController.instance;
  final DBController _dbController = DBController.instance;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late ValueNotifier<bool> _loginValidation;
  late ValueNotifier<bool> _passwordValidation;
  Future<Sportsman>? _futureSportsman;
  final RegExp _regExpEmail = RegExp(
      r"^[\w.%+-]+@[A-z0-9.-]+\.[A-z]{2,}$",
      multiLine: false
  );

  @override
  void initState() {
    super.initState();

    _loginValidation = ValueNotifier(true);
    _passwordValidation = ValueNotifier(true);
  }

  @override
  void dispose() {
    _loginValidation.dispose();
    _passwordValidation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 90),
              child: Column(
                children: [
                  const Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  const FieldName(text: 'Login'),
                  AuthField(
                    controller: _loginController,
                    validation: _loginValidation,
                    errorText: 'Invalid login',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const FieldName(text: 'Password'),
                  AuthField(
                    controller: _passController,
                    validation: _passwordValidation,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black12,
                        side: const BorderSide(
                            color: mainColor, width: 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() {
                        if (validateFields()) {
                          _futureSportsman = _httpController.getSportsman(
                              _loginController.text.trim(),
                              _passController.text);
                        }
                      }),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<Sportsman>(
                      future: _futureSportsman,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator(
                                color: mainColor);
                          default:
                            if (snapshot.hasError) {
                              return const Text('Incorrect login or password');
                            }
                            if (snapshot.hasData) {
                              _dbController.saveOrUpdateSportsman(snapshot.data!);
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                Navigator.pushReplacementNamed(context, 'home');
                              }); //Сначала переход на страницу, а потом рисую, видимо это ошибка
                              return const Icon(Icons.check, color: mainColor, size: 24);
                            } else {
                              return const Text('not found');
                            }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    _loginValidation.value = _regExpEmail.hasMatch(_loginController.text.trim());
    _passwordValidation.value = _passController.text.isNotEmpty;
    return _loginValidation.value && _passwordValidation.value;
  }
}
