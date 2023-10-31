class KurirModel {
  final String? name;
  final String? motor;
  final String? plat;
  final String? imgUrl;

  KurirModel({this.name, this.motor, this.plat, this.imgUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'motor': motor,
      'plat': plat,
      'imgUrl': imgUrl,
    };
  }

  factory KurirModel.fromMap(Map<String, dynamic> map) {
    return KurirModel(
      name: map['name'],
      motor: map['motor'],
      plat: map['plat'],
      imgUrl: map['imgUrl'],
    );
  }

  KurirModel copyWith({
    String? name,
    String? motor,
    String? plat,
    String? imgUrl,
  }) =>
      KurirModel(
        name: name ?? this.name,
        motor: motor ?? this.motor,
        plat: plat ?? this.plat,
        imgUrl: imgUrl ?? this.imgUrl,
      );
}
