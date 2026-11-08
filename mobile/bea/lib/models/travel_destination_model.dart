class TravelDestination {
  const TravelDestination({
    required this.cityId,
    required this.name,
    required this.country,
    this.image,
    this.latitude,
    this.longitude,
    this.timezone,
    this.distance,
  });

  final String cityId;
  final String name;
  final String country;
  final String? image;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final double? distance;

  bool get hasCoordinates => latitude != null && longitude != null;

  String get label => country.isEmpty ? name : '$name, $country';

  String get distanceLabel {
    final value = distance;
    if (value == null) return '';
    if (value < 1) return '<1 mi';
    return '${value.round()} mi';
  }

  static double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  factory TravelDestination.fromJson(Map<String, dynamic> json) {
    final image = json['image'] as String?;

    return TravelDestination(
      cityId: (json['cityId'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      image: image == null || image.isEmpty || image == '/images/default_city.jpg'
          ? null
          : image,
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      timezone: json['timezone'] as String?,
      distance: _toDouble(json['distance']),
    );
  }

  Map<String, dynamic> toJson() => {
        'cityId': cityId,
        'name': name,
        'country': country,
        'image': image,
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'distance': distance,
      };

  TravelDestination copyWith({double? latitude, double? longitude}) =>
      TravelDestination(
        cityId: cityId,
        name: name,
        country: country,
        image: image,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timezone: timezone,
        distance: distance,
      );
}

class TravelTrip {
  const TravelTrip({
    this.destination,
    this.arrivalDate,
    this.departureDate,
    this.isTraveling = false,
  });

  final TravelDestination? destination;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final bool isTraveling;

  bool get isEmpty => destination == null;

  bool get isComplete => destination != null && arrivalDate != null;

  factory TravelTrip.fromUserJson(Map<String, dynamic> json) {
    final location = json['travel_location'];
    if (location is! Map<String, dynamic>) {
      return TravelTrip(isTraveling: json['is_traveling'] == true);
    }

    final coordinates = location['coordinates'];
    double? lat;
    double? lng;
    if (coordinates is List && coordinates.length == 2) {
      lng = TravelDestination._toDouble(coordinates[0]);
      lat = TravelDestination._toDouble(coordinates[1]);
    }

    final name = (location['city_name'] ?? '').toString();

    return TravelTrip(
      isTraveling: json['is_traveling'] == true,
      destination: name.isEmpty
          ? null
          : TravelDestination(
              cityId: (location['city_id'] ?? '').toString(),
              name: name,
              country: (location['country_name'] ?? '').toString(),
              latitude: lat,
              longitude: lng,
            ),
      arrivalDate: location['arrival_date'] == null
          ? null
          : DateTime.tryParse(location['arrival_date'].toString()),
      departureDate: location['departure_date'] == null
          ? null
          : DateTime.tryParse(location['departure_date'].toString()),
    );
  }

  TravelTrip copyWith({
    TravelDestination? destination,
    DateTime? arrivalDate,
    DateTime? departureDate,
    bool? isTraveling,
    bool clearDestination = false,
    bool clearArrival = false,
  }) =>
      TravelTrip(
        destination: clearDestination ? null : destination ?? this.destination,
        arrivalDate: clearArrival ? null : arrivalDate ?? this.arrivalDate,
        departureDate: departureDate ?? this.departureDate,
        isTraveling: isTraveling ?? this.isTraveling,
      );
}
