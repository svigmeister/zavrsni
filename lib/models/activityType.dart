class ActivityType {

  int _id;
  String _activityType;

  ActivityType(this._activityType);

  ActivityType.withId(this._id, this._activityType);

  int get id => _id;
  String get activityType => _activityType;

  set activityType(nType) {
    this._activityType = nType;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['_id'] = _id;
    }
    map['activityType'] = _activityType;

    return map;
  }

  ActivityType.fromMap(Map<String, dynamic> map) {
    this._id = map['_id'];
    this._activityType = map['activityType'];
  }
}