class Crop {

  int _id;
  String _cropName;

  Crop(this._cropName);

  Crop.withId(this._id, this._cropName);

  int get id => _id;
  String get cropName => _cropName;

  set cropName(nName) {
    this._cropName = nName;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['cropName'] = _cropName;

    return map;
  }

  Crop.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._cropName = map['cropName'];
  }
}