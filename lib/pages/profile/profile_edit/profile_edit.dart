import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../widgets/image_selector.dart';
import '../../widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/loading_buttons/loading_icon_button.dart';
import '../../widgets/my_text_form_field.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/profile-edit';

  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;

  late Account _account;
  String _name = '';
  String _phone = '';
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _account = Provider.of<AccountPr>(context, listen: false).account!;
      _name = _account.firstName;
      _phone = _account.phone;
      _gender = ValueNotifier(_account.gender);
      _iconNum = ValueNotifier(_account.iconNum);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _trySubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await Provider.of<AccountPr>(context, listen: false).put(Account(
            id: _account.id,
            email: _account.email,
            lastName: _account.lastName,
            phone: _phone,
            firstName: _name,
            gender: _gender.value,
            iconNum: _iconNum.value,
            dateOfBirth: _account.dateOfBirth,
            role: _account.role));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.i18n()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LoadingIconButton(
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async => _trySubmit(),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 10)
              .copyWith(top: 20),
          children: [
            CircleImage(
                image: AssetImage('images/profileImg${_iconNum.value}.png'),
                icon: Icons.edit,
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageSelector(iconNum: _iconNum)));
                  setState(() {
                    _iconNum.value;
                  });
                }),
            const SizedBox(height: 10),
            MyTextFormField(
              initialValue: _name,
              fieldName: 'name'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.text,
              onSaved: (value) {
                if (value != null) {
                  _name = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _phone,
              fieldName: 'phone'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                if (value != null) {
                  _phone = value.trim();
                }
              },
            ),
            const SizedBox(height: 10),
            GenderSwitcher(
                gender: _gender,
                onPressedMale: () => setState(() => _gender.value = true),
                onPressedFemale: () => setState(() => _gender.value = false)),
          ],
        ),
      ),
    );
  }
}
