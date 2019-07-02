class Crop {

  int _id;
  String _cropName;
  double _expectedIncomeByM2;

  Crop(this._cropName, this._expectedIncomeByM2);

  Crop.withId(this._id, this._cropName, this._expectedIncomeByM2);

  int get id => _id;
  String get cropName => _cropName;
  double get expectedIncomeByM2 => _expectedIncomeByM2;

  set cropName(nName) {
    this._cropName = nName;
  }
  set cropPrice(nExpInc) {
    this._expectedIncomeByM2 = nExpInc;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['cropName'] = _cropName;
    map['expectedIncomeByM2'] = _expectedIncomeByM2;

    return map;
  }

  Crop.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._cropName = map['cropName'];
    this._expectedIncomeByM2 = map['expectedIncomeByM2'];
  }
}