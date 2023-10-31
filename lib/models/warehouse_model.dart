class WarehouseModel {
  final String? id;
  final String? title;
  final bool? isAvailable;
  final String? imgUrl;
  final double? latitude;
  final double? longitude;

  WarehouseModel({
    this.id,
    this.title,
    this.isAvailable,
    this.imgUrl,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isAvailable': isAvailable,
      'imgUrl': imgUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory WarehouseModel.fromMap(Map<String, dynamic> map) {
    return WarehouseModel(
      id: map['id'],
      title: map['title'],
      isAvailable: map['isAvailable'],
      imgUrl: map['imgUrl'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  WarehouseModel copyWith({
    String? id,
    String? title,
    bool? isAvailable,
    String? imgUrl,
    double? latitude,
    double? longitude,
  }) =>
      WarehouseModel(
        id: id ?? this.id,
        title: title ?? this.title,
        isAvailable: isAvailable ?? this.isAvailable,
        imgUrl: imgUrl ?? this.imgUrl,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
