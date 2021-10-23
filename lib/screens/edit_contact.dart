// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import '../model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditContact extends StatefulWidget {
  final String id;
  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {
  String? id;
  _EditContactState(this.id);

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String? _photoUrl;

  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();

  bool isLoading = true;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }

  getContact(id) async {
    Contact contact;
    _databaseReference.child(id).onValue.listen((event) {
      contact = Contact.fromSnapshot(event.snapshot);

      _fnController.text = contact.firstName!;
      _lnController.text = contact.lastName!;
      _poController.text = contact.phone;
      _emController.text = contact.email;
      _adController.text = contact.address;

      setState(() {
        _firstName = contact.firstName!;
        _lastName = contact.lastName!;
        _phone = contact.phone;
        _email = contact.email;
        _address = contact.address;
        _photoUrl = contact.photoUrl;

        isLoading = false;
      });
    });
  }

  updateContact(BuildContext context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _phone.isNotEmpty &&
        _email.isNotEmpty &&
        _address.isNotEmpty) {
      Contact contact = Contact.withId(
          this._address,
          this._email,
          this._firstName,
          this._lastName,
          this._phone,
          this._photoUrl,
          this.id);
      await _databaseReference.child(id!).set(contact.toJason());
      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            // ignore: prefer_const_constructors
            return AlertDialog(
              title: Text("Feild Require"),
              content: Text("All feild are require"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close"))
              ],
            );
          });
    }
  }

  Future pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 200.0, maxWidth: 200.0);
    File file = File(pickedFile!.path);
    String filename = basename(file.path);
    UploadImage(file, filename);
  }

  // ignore: non_constant_identifier_names
  void UploadImage(File file, String filename) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(filename);
    storageReference.putFile(file).whenComplete(() async {
      var dowloadUrl = storageReference.getDownloadURL();

      setState(() {
        _photoUrl = dowloadUrl.toString();
      });
    });
  }

  navigateToLastScreen(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                // ignore: unnecessary_new
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    // ignore: unnecessary_new
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("assets/logo.png")
                                              as ImageProvider
                                          : NetworkImage(_photoUrl!),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.red,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
