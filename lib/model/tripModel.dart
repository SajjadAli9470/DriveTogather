// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';

class Trip {
  String tripId;
  String userId;
  String driverId;
  RouteLocation startingLocation;
  RouteLocation destinationLocation;
  DateTime date;
  String time;
  int seat;
  String pricePerSeat;
  String driverName;
  String driverImage;
  String carColor;
  int driverRating;
  List<BookedSeats> bookedSeats;
  int finish;
  
  
  Trip({
    required this.tripId,
    required this.userId,
    required this.driverId,
    required this.startingLocation,
    required this.destinationLocation,
    required this.date,
    required this.time,
    required this.seat,
    required this.pricePerSeat,
    required this.driverName,
    required this.driverImage,
    required this.carColor,
    required this.driverRating,
    required this.bookedSeats,
    required this.finish
  });

  Trip copyWith({
    String? tripId,
    String? userId,
    String? driverId,
    RouteLocation? startingLocation,
    RouteLocation? destinationLocation,
    DateTime? date,
    String? time,
    int? seat,
    String? pricePerSeat,
    String? driverName,
    String? driverImage,
    String? carColor,
    int? driverRating,
    List<BookedSeats>? bookedSeats,
    int? finish
  }) {
    return Trip(
      tripId: tripId ?? this.tripId,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      startingLocation: startingLocation ?? this.startingLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      date: date ?? this.date,
      time: time ?? this.time,
      seat: seat ?? this.seat,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      driverName: driverName ?? this.driverName,
      driverImage: driverImage ?? this.driverImage,
      carColor: carColor ?? this.carColor,
      driverRating: driverRating ?? this.driverRating,
      bookedSeats: bookedSeats ?? this.bookedSeats,
      finish: finish ?? this.finish
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tripId': tripId,
      'userId': userId,
      'driverId': driverId,
      'startingLocation': startingLocation.toMap(),
      'destinationLocation': destinationLocation.toMap(),
      'date': date.millisecondsSinceEpoch,
      'time': time,
      'seat': seat,
      'pricePerSeat': pricePerSeat,
      'driverName': driverName,
      'driverImage': driverImage,
      'carColor': carColor,
      'driverRating': driverRating,
      'bookedSeats': bookedSeats.map((x) => x.toMap()).toList(),
      'finish':finish
    };
  }

  factory Trip.fromMap(Map map) {
    return Trip(
      tripId: map['tripId'] as String,
      userId: map['userId'] as String,
      driverId: map['driverId'] as String,
      startingLocation: RouteLocation.fromMap(
          map['startingLocation'] as Map<String, dynamic>),
      destinationLocation: RouteLocation.fromMap(
          map['destinationLocation'] as Map<String, dynamic>),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      time: map['time'] as String,
      seat: map['seat'] as int,
      pricePerSeat: map['pricePerSeat'] as String,
      driverName: map['driverName'] as String,
      driverImage: map['driverImage'] as String,
      carColor: map['carColor'] as String,
      driverRating: map['driverRating'],
      bookedSeats: (map['bookedSeats'] as List)
          .map<BookedSeats>((x) => BookedSeats.fromMap(x as Map))
          .toList(),
          finish: map['finish'] ?? 0
    );
  }

  String toJson() => json.encode(toMap());

  factory Trip.fromJson(String source) =>
      Trip.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Trip(tripId: $tripId, userId: $userId, driverId: $driverId, startingLocation: $startingLocation, destinationLocation: $destinationLocation, date: $date, time: $time, seat: $seat, pricePerSeat: $pricePerSeat, driverName: $driverName, driverImage: $driverImage, carColor: $carColor, driverRating: $driverRating, bookedSeats: $bookedSeats)';
  }

  @override
  bool operator ==(covariant Trip other) {
    if (identical(this, other)) return true;

    return other.tripId == tripId &&
        other.userId == userId &&
        other.driverId == driverId &&
        other.startingLocation == startingLocation &&
        other.destinationLocation == destinationLocation &&
        other.date == date &&
        other.time == time &&
        other.seat == seat &&
        other.pricePerSeat == pricePerSeat &&
        other.driverName == driverName &&
        other.driverImage == driverImage &&
        other.carColor == carColor &&
        other.driverRating == driverRating &&
        listEquals(other.bookedSeats, bookedSeats);
  }

  @override
  int get hashCode {
    return tripId.hashCode ^
        userId.hashCode ^
        driverId.hashCode ^
        startingLocation.hashCode ^
        destinationLocation.hashCode ^
        date.hashCode ^
        time.hashCode ^
        seat.hashCode ^
        pricePerSeat.hashCode ^
        driverName.hashCode ^
        driverImage.hashCode ^
        carColor.hashCode ^
        driverRating.hashCode ^
        bookedSeats.hashCode;
  }
}

class BookedSeats {
  String userId;
  int totalSeats;
  BookedSeats({
    required this.userId,
    required this.totalSeats,
  });

  BookedSeats copyWith({
    String? userId,
    int? totalSeats,
  }) {
    return BookedSeats(
      userId: userId ?? this.userId,
      totalSeats: totalSeats ?? this.totalSeats,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'totalSeats': totalSeats,
    };
  }

  factory BookedSeats.fromMap(Map map) {
    return BookedSeats(
      userId: map['userId'] as String,
      totalSeats: map['totalSeats'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookedSeats.fromJson(String source) =>
      BookedSeats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookedSeats(userId: $userId, totalSeats: $totalSeats)';

  @override
  bool operator ==(covariant BookedSeats other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.totalSeats == totalSeats;
  }

  @override
  int get hashCode => userId.hashCode ^ totalSeats.hashCode;
}

class RouteLocation {
  Placemark details;
  double lng;
  double lat;
  RouteLocation({
    required this.details,
    required this.lng,
    required this.lat,
  });

  RouteLocation copyWith({
    Placemark? details,
    double? lng,
    double? lat,
  }) {
    return RouteLocation(
      details: details ?? this.details,
      lng: lng ?? this.lng,
      lat: lat ?? this.lat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'details': details.toJson(),
      'lng': lng,
      'lat': lat,
    };
  }

  factory RouteLocation.fromMap(Map<String, dynamic> map) {
    return RouteLocation(
      details: Placemark.fromMap(map['details'] as Map),
      lng: map['lng'] as double,
      lat: map['lat'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteLocation.fromJson(String source) =>
      RouteLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RouteLocation(details: $details, lng: $lng, lat: $lat)';

  @override
  bool operator ==(covariant RouteLocation other) {
    if (identical(this, other)) return true;

    return other.details == details && other.lng == lng && other.lat == lat;
  }

  @override
  int get hashCode => details.hashCode ^ lng.hashCode ^ lat.hashCode;
}
