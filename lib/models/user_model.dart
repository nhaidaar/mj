class UserModel {
  final String? uid;
  final String? email;
  final String? fullName;
  final String? profilePict;
  final double? totalMinyak;
  final int? totalPoin;
  final int? totalPendapatan;

  UserModel({
    this.uid,
    this.email,
    this.fullName,
    this.profilePict,
    this.totalMinyak,
    this.totalPoin,
    this.totalPendapatan,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'profilePict': profilePict,
      'totalMinyak': totalMinyak,
      'totalPoin': totalPoin,
      'totalPendapatan': totalPendapatan,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      profilePict: map['profilePict'],
      totalMinyak: map['totalMinyak'],
      totalPoin: map['totalPoin'],
      totalPendapatan: map['totalPendapatan'],
    );
  }
}
