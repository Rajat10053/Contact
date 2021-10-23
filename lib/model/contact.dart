// ignore_for_file: unnecessary_this, unused_field

import 'package:firebase_database/firebase_database.dart';

class Contact {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _email;
  String? _address;
  String? _photoUrl;

//constructure for add

  Contact(this._address, this._email, this._firstName, this._lastName,
      this._phone, this._photoUrl);
//constructure for edit

  Contact.withId(this._address, this._email, this._firstName, this._lastName,
      this._phone, this._photoUrl, this._id);

  //getters

  String? get id => this._id;
  String? get firstName => this._firstName;
  String? get lastName => this._lastName;
  String get phone => this._phone!;
  String get email => this._email!;
  String get address => this._address!;
  String get photoUrl => this._photoUrl!;

  //setters
  set firstName(String? firstName) {
    this._firstName = firstName;
  }

  set lastName(String? lastName) {
    this._lastName = lastName;
  }

  set phone(String phone) {
    this._phone = phone;
  }

  set email(String email) {
    this._email = email;
  }

  set address(String address) {
    this._address = address;
  }

  set photoUrl(String photoUrl) {
    this._photoUrl = photoUrl;
  }

  Contact.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._phone = snapshot.value['phone'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._photoUrl = snapshot.value['photoUrl'];
  }

  Map<String, dynamic> toJason() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl
    };
  }
}
