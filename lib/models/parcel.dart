class Parcel {

  int _id;
  String _parcelName;
  double _m2;
  String _crop;
  double _income;
  double _totalQuantity;
  double _currentQuantity;

  Parcel(this._parcelName, this._m2, this._crop, [this._income,
    this._totalQuantity, this._currentQuantity]);

  Parcel.withId(this._id, this._parcelName, this._m2, this._crop, [this._income,
    this._totalQuantity, this._currentQuantity]);

  int get id => _id;
  String get parcelName => _parcelName;
  double get m2 => _m2;
  String get crop => _crop;
  double get income => _income;
  double get totalQuantity => _totalQuantity;
  double get currentQuantity => _currentQuantity;

  set parcelName(nName) {
    this._parcelName = nName;
  }
  set m2(nM2) {
    this._m2 = nM2;
  }
  set crop(nCrop) {
    this._crop = nCrop;
  }
  set income(nIncome) {
    this._income = nIncome;
  }
  set totalQuantity(nTQuantity) {
    this._totalQuantity = nTQuantity;
  }
  set currentQuantity(nCQuantity) {
    this._currentQuantity = nCQuantity;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['parcelName'] = _parcelName;
    map['m2'] = _m2;
    map['crop'] = _crop;
    map['income'] = _income;
    map['totalQuantity'] = _totalQuantity;
    map['currentQuantity'] = _currentQuantity;

    return map;
  }

  Parcel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._parcelName = map['parcelName'];
    this._m2 = map['m2'];
    this._crop = map['crop'];
    this._income = map['income'];
    this._totalQuantity = map['totalQuantity'];
    this._currentQuantity = map['currentQuantity'];
  }
}