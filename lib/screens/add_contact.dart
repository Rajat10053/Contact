// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, duplicate_ignore, unnecessary_this

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '../model/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String? _firstName = '';
  String? _lastName = '';
  String? _phone = '';
  String? _email = '';
  String? _address = '';
  String? _photoUrl = "empty";

  saveContact(BuildContext contex) async {
    if (_firstName!.isNotEmpty &&
        _lastName!.isNotEmpty &&
        _phone!.isNotEmpty &&
        _email!.isNotEmpty &&
        _address!.isNotEmpty) {
      Contact contact = Contact(this._address, this._email, this._firstName,
          this._lastName, this._phone, this._photoUrl);

      await _databaseReference.push().set(contact.toJason());
      navigateToLastScreen(contex);
    } else {
      showDialog(
          context: contex,
          builder: (contex) {
            // ignore: prefer_const_constructors
            return AlertDialog(
              title: Text("Feild Require"),
              content: Text("All feild are require"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(contex).pop();
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

  navigateToLastScreen(contex) {
    Navigator.of(contex).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add contact"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
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
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _photoUrl == "empty"
                                ? AssetImage("assets/logo.png") as ImageProvider
                                : NetworkImage(_photoUrl!),
                          )),
                    ),
                  ),
                ),
              ),
              //first name
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _firstName = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _lastName = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _phone = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'phone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              //save
              Container(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(100, 20, 100, 20),
                  onPressed: () {
                    saveContact(context);
                  },
                  color: Colors.red,
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
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
