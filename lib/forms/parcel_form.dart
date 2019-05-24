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
                    debugPrint('User clicked back in parcel form');
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
                            debugPrint('User selected $valueSelectedByUser');
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
                debugPrint('User clicked button save in parcel form');
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_parcelFormKey.currentState.validate()) {
                  String dataString = _catchData(parcelNameController.text,
                      m2Controller.text, parcel.crop);
                  _save(parcel);
                  moveToLastScreen();
                  _showAlertDialog('Catched info:', dataString);
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
    debugPrint('Entered _save method');
    DatabaseHelper helper = DatabaseHelper.instance;
    if (parcelToSave.income.isNaN || parcelToSave.income == null) {
      parcelToSave.income = 0;
    }
    if (parcelToSave.currentQuantity.isNaN || parcelToSave.currentQuantity == null) {
      parcelToSave.currentQuantity = 0;
    }
    if (parcelToSave.totalQuantity.isNaN || parcelToSave.totalQuantity == null) {
      parcelToSave.totalQuantity = 0;
    }

    await helper.insertParcel(parcelToSave);
  }

  String _catchData(String parcelName, String m2, String crop) {
    this.parcel.parcelName = parcelName;
    this.parcel.m2 = double.parse(m2);
    String resultString = 'Ime parcele: ' + this.parcel.parcelName +
        ', Površina: ' + this.parcel.m2.toString() +
        ', Usjev: ' + this.parcel.crop;
    return resultString;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog dialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => dialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
