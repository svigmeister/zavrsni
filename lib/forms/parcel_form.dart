import 'package:flutter/material.dart';

import '../models/parcel.dart';
import '../utils/database_helper.dart';

// Create a Form Widget
class ParcelForm extends StatefulWidget {
  final String appBarTitle;
  final Parcel parcel;

  ParcelForm(this.appBarTitle, this.parcel);

  @override
  State<StatefulWidget> createState() {
    return ParcelFormState(this.parcel, this.appBarTitle);
  }
}

// This class will hold the data related to the form
class ParcelFormState extends State<ParcelForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<ParcelFormState>!
  final _parcelFormKey = GlobalKey<FormState>();

  static var _crops = ['Kuruza', 'Paradajz', 'Mrkva', 'Pšenica', 'Tikvice'];
  Parcel parcel;
  String appBarTitle;
  TextEditingController parcelNameController = TextEditingController();
  TextEditingController m2Controller = TextEditingController();

  ParcelFormState(this.parcel, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _parcelFormKey we created above
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    debugPrint('User clicked back [parcel form]');
                    moveToLastScreen();
                  }),
            ),
            body: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: DropdownButton(
                        items: _crops.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: parcel.crop,
                        hint: Text('Odaberite usjev'),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            debugPrint('User selected $valueSelectedByUser [parcel_form]');
                            parcel.crop = valueSelectedByUser;
                          });
                        }),
                  ),
                  parcelFormUI()
                ],
              ),
            )
        )
    );
  }

  Widget parcelFormUI() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _parcelFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: parcelNameController,
            style: textStyle,
            validator: (value) {
              if (value.isEmpty) {
                return 'Molim unesite jedinstven naziv parcele';
              }
            },
          ),
          TextFormField(
            controller: m2Controller,
            style: textStyle,
            validator: (value) {
              RegExp numRegex = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
              if (value.isEmpty) {
                return 'Molim unesite površinu parcele';
              }
              if (!numRegex.hasMatch(value)) {
                return 'Molim unesite valjani broj (za decimalni zapis koristite točku)';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button save [parcel form]');
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_parcelFormKey.currentState.validate()) {
                  _catchUserInput(parcelNameController.text, m2Controller.text);
                  _save(parcel);
                  moveToLastScreen();
                }
              },
              child: Text('Spremi'),
            ),
          ),
        ],
      ),
    );
  }

  void _save(Parcel parcelToSave) async {
    debugPrint('Entered _save method [parcel_form]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    // _showAlertDialog(context, 'Parcel info:', parcel.parcelName);
    if (parcelToSave.income == null) {
      parcelToSave.income = 0.0;
    }
    if (parcelToSave.currentQuantity == null) {
      parcelToSave.currentQuantity = 0.0;
    }
    if (parcelToSave.totalQuantity == null) {
      parcelToSave.totalQuantity = 0.0;
    }

    debugPrint('parcelToSave: [parcel_form]' + parcelToSave.toString());
    // await dbHelper.insertParcel(parcelToSave.toMap());
  }

  void _catchUserInput(String parcelName, String m2) {
    parcel.parcelName = parcelName;
    parcel.m2 = double.parse(m2);
  }

  Future<void> _showAlertDialog(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
