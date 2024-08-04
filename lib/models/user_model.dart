import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserProfile {
  final String? fullName;
  final String email;
  final String photoUrl;
  final String uid;
  final String password;
  final String regiDate;
  final bool verified;
  final String loginMode;
  final String pushId;
  final bool pushSwitch;
  final bool emailSwitch;
  final List searchIndex;

  UserProfile({
    this.fullName,
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.password,
    required this.regiDate,
    required this.verified,
    required this.loginMode,
    required this.pushId,
    required this.pushSwitch,
    required this.emailSwitch,
    required this.searchIndex,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'uid': uid,
      'password': password,
      'regiDate': regiDate,
      'verified': verified,
      'loginMode': loginMode,
      'pushId': pushId,
      'pushSwitch': pushSwitch,
      'emailSwitch': emailSwitch,
      'searchIndex': searchIndex,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      uid: map['uid'] as String,
      password: map['password'] as String,
      regiDate: map['regiDate'] as String,
      verified: map['verified'] as bool,
      loginMode: map['loginMode'] as String,
      pushId: map['pushId'] as String,
      pushSwitch: map['pushSwitch'] as bool,
      emailSwitch: map['emailSwitch'] as bool,
      searchIndex: List.from(
        (map['searchIndex'] as List),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
