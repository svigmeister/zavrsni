class ActivityType {

  int _id;
  String _activityType;
  bool _repetitive;

  ActivityType(this._activityType, this._repetitive);

  ActivityType.withId(this._id, this._activityType, this._repetitive);

  int get id => _id;
  String get activityType => _activityType;
  bool get repetitive => _repetitive;

  set activityType(nType) {
    this._activityType = nType;
  }
  set repetitive(nRepetitive) {
    this._repetitive = nRepetitive;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['activityType'] = _activityType;
    map['repetitive'] = _repetitive;

    return map;
  }

  ActivityType.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._activityType = map['activityType'];
    this._repetitive = map['repetitive'];
  }
}