import 'package:flutter/material.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/utils/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jobhop/company/api/api.dart';


class ProfileFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _countryCode = 'NL';

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();

  var _addressController = TextEditingController();
  var _cityController = TextEditingController();
  var _postalController = TextEditingController();
  var _mobileController = TextEditingController();
  var _remarksController = TextEditingController();
  var _ibanController = TextEditingController();
  var _infoController = TextEditingController();

  bool _inAsyncCall = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: _buildMainContainer(), inAsyncCall: _inAsyncCall);
  }

  @override
  void initState() {
    super.initState();
    _doAsync();
  }

  _doAsync() async {
    setState(() {
      _inAsyncCall = true;
    });
    await _fetchUserData();
    setState(() {
      _inAsyncCall = false;
    });
  }

  _fetchUserData() async {}

  Widget _buildMainContainer() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    createHeader('profile.header'.tr()),
                    _createProfileForm(context),
                    _createSubmitButton(),
                  ],
                ))));
  }

  Widget _createSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      child: Text('profile.submit'.tr()),
      onPressed: () async {
        if (this._formKey.currentState!.validate()) {
          this._formKey.currentState!.save();

          setState(() {
            _inAsyncCall = true;
          });

          // save profile model
          StudentUserProperty studentUserProperty = StudentUserProperty(
              address: _addressController.text,
              postal: _postalController.text,
              city: _cityController.text,
              countryCode: _countryCode,
              mobile: _mobileController.text,
              remarks: _remarksController.text,
              iBan: _ibanController.text,
              info: _infoController.text
          );

          StudentUser user = StudentUser(
            email: _emailController.text,
            username: _usernameController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            studentUser: studentUserProperty,
          );

          final bool result = await companyApi.updateStudentUser(user);

          setState(() {
            _inAsyncCall = false;
          });

          if (result) {
            createSnackBar(context, 'profile.saved'.tr());
          } else {
            createSnackBar(context, 'profile.snackbar_saving_error'.tr());
          }
        }
      },
    );
  }

  Widget _createProfileForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Table(children: [
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.username'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                readOnly: true,
                controller: _usernameController,
                validator: (value) {
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.email'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _emailController,
                readOnly: true,
                validator: (value) {
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.firstName'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _firstNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.validator_firstName'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.lastName'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _lastNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.validator_lastName'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.address'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _addressController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.address'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.postal'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _postalController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.postal'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.city'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _cityController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.city'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.countryCode'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DropdownButtonFormField<String>(
              value: _countryCode,
              items: ['NL', 'BE', 'LU', 'FR', 'DE'].map((String value) {
                return new DropdownMenuItem<String>(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _countryCode = newValue!;
                });
              },
            )
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.mobile'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _mobileController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.mobile'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.remarks'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: 300.0,
                child: TextFormField(
                  controller: _remarksController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.iban'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _ibanController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.iban'.tr();
                  }
                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.info'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: 300.0,
                child: TextFormField(
                  controller: _infoController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )),
          ]),
        ]));
  }
}
