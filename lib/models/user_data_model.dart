class UserData{
  final String uid;
  final String displayName;
  final String creationDate;
  final int? avatar;

  const UserData ({
    required this.uid,
    required this.displayName,
    required this.creationDate,
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(
      uid: json['UID'].toString(),
      displayName: json['DisplayName'].toString(),
      creationDate: json['CreationDate'].toString(),
      avatar: json['Avatar'] as int,
    );
  }
}