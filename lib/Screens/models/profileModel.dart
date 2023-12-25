class ProfileModel {
  String? emiscode;
  String? fullName;
  String? avatarUrl;

  ProfileModel({this.emiscode, this.fullName, this.avatarUrl});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    emiscode = json['emiscode'];
    fullName = json['fullName'];
    avatarUrl = json['avatarUrl'];
  }
  ProfileModel.fromMap(
    Map<String, dynamic> data,
  ) {
    emiscode = data['emiscode'];
    fullName = data['fullName'];
    avatarUrl = data['avatarUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'emiscode': emiscode,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emiscode'] = emiscode;
    data['fullName'] = fullName;
    data['avatarUrl'] = avatarUrl;
    return data;
  }
}
