import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:jobhop/company/pages/home.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iban/iban.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jobhop/utils/auth.dart';
import 'package:jobhop/utils/generic.dart';
import 'package:jobhop/utils/state.dart';
import 'package:jobhop/company/models/models.dart';
import 'package:jobhop/company/api/api.dart';
import 'package:jobhop/core/widgets/widgets.dart';
import 'package:jobhop/mobile/pages/assigned_list.dart';

GetIt getIt = GetIt.instance;

class ProfileFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfileFormWidgetState();
}

class _ProfileFormWidgetState extends State<ProfileFormWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? userPk;
  bool _isFirstTimeProfile = true;
  bool _isAgreed = false;

  File? _imagePickedFile;
  Image _defaultImageImage = Image(image: AssetImage('assets/blank-profile-picture.png'));
  Image? _imageShownImage;
  final picker = ImagePicker();

  String _countryCode = 'NL';

  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  String _gender = 'profile.gender_male'.tr();
  DateTime _dayOfBirth = DateTime.now();
  String _driversLicence = 'profile.no'.tr();
  var _driversLicenceTypeController = TextEditingController();
  String _boxTruck = 'profile.no'.tr();
  var _bsnController = TextEditingController();

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
        child: _buildMainContainer(),
        inAsyncCall: _inAsyncCall
    );
  }

  @override
  void initState() {
    // default image
    _imageShownImage = _defaultImageImage;

    super.initState();
    _doAsync();
  }

  _doAsync() async {
    await _fetchUserData();
    _isFirstTimeProfile = await isFirstTimeProfile();
  }

  _fetchUserData() async {
    userPk = await auth.getUserFieldInt('userPk');

    setState(() {
      _inAsyncCall = true;
    });

    StudentUser user = await companyApi.fetchStudentUser(userPk!);

    _usernameController.text = user.username;
    _emailController.text = user.email;
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _addressController.text = user.studentUser!.address ?? '';
    _postalController.text = user.studentUser!.postal ?? '';
    _cityController.text = user.studentUser!.city ?? '';
    _countryCode = user.studentUser!.countryCode ?? 'NL';
    _mobileController.text = user.studentUser!.mobile ?? '';
    _remarksController.text = user.studentUser!.remarks ?? '';
    _ibanController.text = user.studentUser!.iBan ?? '';
    _infoController.text = user.studentUser!.info ?? '';
    _gender = _genderToApp(user.studentUser!.gender ?? 'M');

    if (user.studentUser!.dayOfBirth != null) {
      _dayOfBirth = DateFormat('yyyy-M-d').parse('${user.studentUser!.dayOfBirth!}');
    }

    if (user.studentUser!.driversLicence != null) {
      _driversLicence = _yesNoToApp(user.studentUser!.driversLicence!);
    }

    if (user.studentUser!.driversLicenceType != null) {
      _driversLicenceTypeController.text = user.studentUser!.driversLicenceType!;
    }

    if (user.studentUser!.boxTruck != null) {
      _boxTruck = _yesNoToApp(user.studentUser!.boxTruck!);
    }

    if (user.studentUser!.bsn != null) {
      _bsnController.text = user.studentUser!.bsn!;
    }

    if (user.studentUser!.picture != null) {
      _imageShownImage = Image.network(user.studentUser!.picture!);
    }

    setState(() {
      if (!_isFirstTimeProfile) {
        _isAgreed = true;
      }
      _inAsyncCall = false;
    });
  }

  _genderToInternal(String valIn) {
    if (valIn == 'profile.gender_male'.tr()) {
      return 'M';
    }

    if (valIn == 'profile.gender_female'.tr()) {
      return 'F';
    }

    if (valIn == 'profile.gender_other'.tr()) {
      return 'O';
    }

    throw('Help unknown gender: $valIn');
  }

  _genderToApp(String valIn) {
    if (valIn == 'M') {
      return 'profile.gender_male'.tr();
    }

    if (valIn == 'F') {
      return 'profile.gender_female'.tr();
    }

    if (valIn == 'O') {
      return 'profile.gender_other'.tr();
    }

    throw('Help unknown gender: $valIn');
  }

  _yesNoToInternal(String valIn) {
    if (valIn == 'profile.yes'.tr()) {
      return 'Y';
    }

    if (valIn == 'profile.no'.tr()) {
      return 'N';
    }

    throw('Help unknown yes/no: $valIn');
  }

  _yesNoToApp(String valIn) {
    if (valIn == 'Y') {
      return 'profile.yes'.tr();
    }

    if (valIn == 'N') {
      return 'profile.no'.tr();
    }

    throw('Help unknown yes/no: $valIn');
  }

  _openImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _imagePickedFile = File(pickedFile.path);
        _imageShownImage = Image.file(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  _openImagePicker() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePickedFile = File(pickedFile.path);
        _imageShownImage = Image.file(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildTakePictureButton() {
    return createBlueElevatedButton(
        'profile.button_take_picture'.tr(), _openImageCamera);
  }

  Widget _buildChooseImageButton() {
    return createBlueElevatedButton(
        'profile.button_choose_image'.tr(), _openImagePicker);
  }

  _selectDayOfBirth(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.blueAccent,
            backgroundColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)
        ),
        onChanged: (date) {
        }, onConfirm: (date) {
          setState(() {
            _dayOfBirth = date;
          });
        },
        currentTime: _dayOfBirth,
        locale: LocaleType.en
    );
  }

  String? validateMobile(String value) {
    String patttern = r'(^\+[0-9]{11}$)';
    RegExp regExp = new RegExp(patttern);

    if (!regExp.hasMatch(value)) {
      return 'profile.mobile_invalid'.tr();
    }

    return null;
  }

  Widget _buildMainContainer() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    createHeader('profile.header'.tr()),
                    _createInfoSection(),
                    _createPictureSection(),
                    _createProfileForm(context),
                    _createSubmitButton(),
                    SizedBox(height: 20),
                    if (_isFirstTimeProfile)
                      _createIAgreeSection(),
                    SizedBox(height: 40),
                    _createDeleteButton()
                  ],
                )
            )
        )
    );
  }

  Widget _createIAgreeSection() {
    double width = MediaQuery.of(context).size.width*0.8;

    return Container(
      padding: const EdgeInsets.all(16.0),
      width: width,
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreed = value!;
                  });
                },
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Text(
                  'profile.agree_section'.tr(),
                  style: TextStyle(fontStyle: FontStyle.italic)
                ))
            ],
          )
        ],
      )
    );
  }

  Widget _createInfoSection() {
    return Center(child: Text(
        'profile.info_section'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(fontStyle: FontStyle.italic),
    ));
  }

  void _deleteProfile() async {
    setState(() {
      _inAsyncCall = true;
    });

    final result = await companyApi.deleteMe();

    if (result) {
      createSnackBar(context, 'profile.snackbar_profile_deleted'.tr());
      final page = JobHopHome();
      bool loggedOut = await auth.logout();
      if (loggedOut == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => page)
        );
        return;
      }
    }

    displayDialog(context,
        'profile.error_deleting_profile_title'.tr(),
        'profile.error_deleting_profile_content'.tr(),
    );
  }

  Widget _createDeleteButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.red, // background
          onPrimary: Colors.white, // foreground
        ),
        child: Text('profile.delete'.tr()),
        onPressed: () async {
          showDeleteDialogWrapper(
              'profile.delete_dialog_title'.tr(),
              'profile.delete_dialog_content'.tr(),
              context,
              _deleteProfile
          );
        }
    );
  }

  Widget _createSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
      ),
      child: Text('profile.submit'.tr()),
      onPressed: () async {
        if (!_isAgreed) {
          displayDialog(context,
            'profile.not_agreed_title'.tr(),
            'profile.not_agreed_content'.tr(),
          );

          return;
        }

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
              info: _infoController.text,
              gender: _genderToInternal(_gender),
              dayOfBirth: "${_dayOfBirth.toLocal()}".split(' ')[0],
              driversLicence: _yesNoToInternal(_driversLicence),
              driversLicenceType: _driversLicenceTypeController.text,
              boxTruck: _yesNoToInternal(_boxTruck),
              bsn: _bsnController.text,
          );

          if (_imagePickedFile != null) {
            studentUserProperty.picture = base64Encode(_imagePickedFile!.readAsBytesSync());
          }

          StudentUser user = StudentUser(
            email: _emailController.text,
            username: _usernameController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            studentUser: studentUserProperty,
          );

          try {
            final bool result = await companyApi.updateStudentUser(user, userPk!);

            setState(() {
              _inAsyncCall = false;
            });

            if (result) {
              createSnackBar(context, 'profile.snackbar_saved'.tr());

              // store if this is the first time the user fills in this form
              await setFirstTimeProfile();

              // store in app state
              final String? token = await getToken();
              getIt<AppModel>().setUserFull(user, token!);

              // nav to assignedorders list
              final page = AssignedOrderListPage();

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => page)
              );
            } else {
              createSnackBar(context, 'profile.snackbar_saving_error'.tr());
            }
          } catch(e) {
            createSnackBar(context, 'profile.snackbar_saving_error'.tr());

            setState(() {
              _inAsyncCall = false;
            });
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
                // readOnly: true,
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
                child: Text('profile.gender'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ['profile.gender_male'.tr(), 'profile.gender_female'.tr(), 'profile.gender_other'.tr()].map((String value) {
                return new DropdownMenuItem<String>(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _gender = newValue!;
                });
              },
            )
          ]),
          TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('profile.date_of_birth'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                InkWell(
                  onTap: () => _selectDayOfBirth(context),
                  child: SizedBox(
                    height: 45,
                    width: 100,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),

                      ),
                      child: Text(
                        "${_dayOfBirth.toLocal()}".split(' ')[0],
                        textAlign: TextAlign.left,
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1),
                      ),
                    ),
                  ),
                ),
              ]
          ),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.postal'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _postalController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.validator_postal'.tr();
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
                    return 'profile.validator_city'.tr();
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
                    return 'profile.mobile_empty'.tr();
                  }

                  return validateMobile(value);
                }),
          ]),
          TableRow(children: [
            SizedBox(height: 2, width: 2),
            Text(
                'profile.mobile_info_text'.tr(),
                style: TextStyle(fontStyle: FontStyle.italic)
            )
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.iban'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold)
                )
            ),
            TextFormField(
                controller: _ibanController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.iban_empty'.tr();
                  }

                  if (!isValid(value)) {
                    return 'profile.iban_invalid'.tr();
                  }

                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.bsn'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            TextFormField(
                controller: _bsnController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'profile.bsn_empty'.tr();
                  }

                  return null;
                }),
          ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.drivers_licence'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DropdownButtonFormField<String>(
              value: _driversLicence,
              items: ['profile.yes'.tr(), 'profile.no'.tr()].map((String value) {
                return new DropdownMenuItem<String>(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _driversLicence = newValue!;
                });
              },
            )
          ]),
          if (_driversLicence == 'profile.yes'.tr())
            TableRow(children: [
              Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('profile.drivers_licence_type'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold))),
              TextFormField(
                  controller: _driversLicenceTypeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'profile.drivers_licence_type_empty'.tr();
                    }
                    return null;
                  }),
            ]),
          TableRow(children: [
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('profile.box_truck'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DropdownButtonFormField<String>(
              value: _boxTruck,
              items: ['profile.yes'.tr(), 'profile.no'.tr()].map((String value) {
                return new DropdownMenuItem<String>(
                  child: new Text(value),
                  value: value,
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _boxTruck = newValue!;
                });
              },
            )
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
                child: Text('profile.info'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: 300.0,
                height: 160.0,
                child: TextFormField(
                  controller: _infoController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15.0, bottom: 100.0),
                  ),
                )),
          ]),
        ])
    );
  }

  Widget _createPictureSection() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('profile.picture'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold))
        ),
        Container(
          width: 200,
          height: 200,
          child: _imageShownImage,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildChooseImageButton(),
            _buildTakePictureButton(),
          ],
        )
      ],
    );
  }
}
