import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/parcel.dart';
import '../models/activity.dart';
import '../models/tool.dart';
import '../models/crop.dart';
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

  // Note: This is a GlobalKey<FormState>, not a GlobalKey<ParcelFormState>!
  final _parcelFormKey = GlobalKey<FormState>();

  static var _crops = ['Kukuruz', 'Mrkva', 'Pšenica', 'Rajčica'];
  Parcel parcel;
  String appBarTitle;
  bool nameChanged = false;
  String oldName;
  TextEditingController parcelNameController = TextEditingController();
  TextEditingController m2Controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  // State constructor
  ParcelFormState(this.parcel, this.appBarTitle);

  // A method for date picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(parcel.startTime),
        firstDate: DateTime(2018),
        lastDate: DateTime(2096));
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _parcelFormKey we created above
    TextStyle textStyle = Theme.of(context).textTheme.title;
    parcelNameController.text = parcel.parcelName;
    m2Controller.text = parcel.m2.toString();

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
          body: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0),
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
                              debugPrint(
                                  'User selected $valueSelectedByUser [parcel_form]');
                              parcel.crop = valueSelectedByUser;
                            });
                          }),
                    ),
                    parcelFormUI()
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget parcelFormUI() {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _parcelFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextFormField(
              controller: parcelNameController,
              style: textStyle,
              decoration: InputDecoration(
                  labelText: 'Naziv',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5))),
              onEditingComplete: () {
                updateName();
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Unesite naziv parcele koji još ne koristite!';
                }
                if (value == 'Nova parcela') {
                  return 'Naziv ne smije biti "Nova parcela"!';
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextFormField(
              controller: m2Controller,
              style: textStyle,
              decoration: InputDecoration(
                  labelText: 'Površina',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.5))),
              onEditingComplete: () {
                updateM2();
              },
              validator: (value) {
                RegExp numRegex = new RegExp(r'^[0-9]+(\.[0-9]+)?$');
                if (value.isEmpty) {
                  return 'Unesite površinu parcele!';
                }
                if (!numRegex.hasMatch(value)) {
                  return 'Unesite brojčanu vrijednost (za decimalni zapis koristite točku)!';
                }
              },
            ),
          ),
          Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Odaberi datum'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                debugPrint('User clicked button spremi [parcel form]');
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_parcelFormKey.currentState.validate()) {
                  _catchDateInput(selectedDate);
                  if (appBarTitle == 'Nova parcela') {
                    _saveParcel(parcel);
                    // _showAlertDialog(context, 'Parcel info:', parcel.toString());
                    moveToLastScreen();
                  } else {
                    _updateParcel(parcel);
                    moveToLastScreen();
                  }
                }
              },
              child: Text('Spremi parcelu'),
            ),
          ),
        ],
      ),
    );
  }

  void updateName() {
    if(parcel.parcelName != parcelNameController.text) {
      oldName = parcel.parcelName;
      parcel.parcelName = parcelNameController.text;
      nameChanged = true;
    }
  }

  void updateM2() {
    parcel.m2 = double.parse(m2Controller.text);
  }

  void _saveParcel(Parcel parcelToSave) async {
    debugPrint('Entered _saveParcel method [parcel_form]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    if (parcelToSave.income == null) {
      parcelToSave.income = 0.0;
    }
    if (parcelToSave.currentQuantity == null) {
      parcelToSave.currentQuantity = 0.0;
    }
    if (parcelToSave.totalQuantity == null) {
      parcelToSave.totalQuantity = 0.0;
    }
    if (parcelToSave.expectedExpense == null) {
      parcelToSave.expectedExpense = 0.0;
    }
    if (parcelToSave.expectedIncome == null) {
      Crop parcelCrop = await dbHelper.getParcelCrop(parcelToSave);
      parcelToSave.expectedIncome = (parcelCrop.expectedIncomeByM2 * parcelToSave.m2);
    }

    List<Activity> parcelCropActivities = await dbHelper.getCropActivities(parcelToSave.crop);
    int count = parcelCropActivities.length;
    for(int i = 0; i < count; i++) {
      parcelToSave.expectedExpense += (parcelToSave.m2 * parcelCropActivities[i].expenseByM2);
      List<Tool> activityTools = await dbHelper.getActivityTools(parcelCropActivities[i]);
      int toolCount = activityTools.length;
      if (toolCount > 0) {
        for (int j = 0; j < toolCount; j++) {
          parcelToSave.expectedExpense += activityTools[j].price;
        }
      }
    }

    debugPrint('parcelToSave: [parcel_form]\n' + parcelToSave.toString());
    int id = await dbHelper.insertParcel(parcelToSave.toMap());
    debugPrint('Save returned id: $id [parcel_form]');
  }

  void _updateParcel(Parcel parcelToUpdate) async {
    debugPrint('Entered _updateParcel method [parcel_form]');
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    debugPrint('parcelToUpdate: [parcel_form]\n' + parcelToUpdate.toString());
    int id = await dbHelper.updateParcel(parcelToUpdate.toMap());
    debugPrint('Update returned id: $id [parcel_form]');

    // If we changed the name of the parcel, we need to update records
    if (nameChanged) {
      int id2 = await dbHelper.updateRecordsOnParcelUpdate(oldName, parcelToUpdate.parcelName);
      debugPrint('Update records returned id: $id2 [parcel_form]');
    }
  }

  void _catchDateInput(DateTime date) {
    parcel.startTime = DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _showAlertDialog(
      BuildContext context, String title, String message) {
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
