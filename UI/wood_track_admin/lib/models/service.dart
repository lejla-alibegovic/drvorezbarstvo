class Service {
  int id;
  String name;
  Duration duration;

  Service({
    required this.id,
    required this.name,
    required this.duration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      duration: parseDuration(json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration.toString(),
    };
  }

  static Duration parseDuration(String timeString) {
    final parts = timeString.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }
}
