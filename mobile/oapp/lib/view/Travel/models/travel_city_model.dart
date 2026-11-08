class TravelCity {
  int? postsCount;
  DateTime? latestStoryAt;
  String? cityId;
  String? name;
  String? country;
  String? image;

  TravelCity({
    this.postsCount,
    this.latestStoryAt,
    this.cityId,
    this.name,
    this.country,
    this.image,
  });

  factory TravelCity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TravelCity();

    String? imageValue = json['image'];

    // Treat default image as empty
    if (imageValue == "/images/default_city.jpg") {
      imageValue = null;
    }

    return TravelCity(
      postsCount: json['postsCount'],
      latestStoryAt: json['latestStoryAt'] != null
          ? DateTime.tryParse(json['latestStoryAt'])
          : null,
      cityId: json['cityId'],
      name: json['name'],
      country: json['country'],
      image: imageValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postsCount': postsCount,
      'latestStoryAt': latestStoryAt?.toIso8601String(),
      'cityId': cityId,
      'name': name,
      'country': country,
      'image': image,
    };
  }
}

class City {
  final String name;
  final String imageUrl;
  final double latitude;
  final double longitude;

  const City(this.name, this.imageUrl, this.latitude, this.longitude);
}

class LocationItem {
  final String name;
  final String distance;
  final double latitude;
  final double longitude;

  const LocationItem(this.name, this.distance, this.latitude, this.longitude);

  City toCity() => City(name, '', latitude, longitude);
  TravelCity toTravelCity() => TravelCity(name: name, image: '', postsCount: 0);
}
