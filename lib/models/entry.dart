import 'package:geocoding/geocoding.dart';

class Entry {
  late DateTime createdAt;
  Placemark? placemark;

  Entry([DateTime? createdAt, this.placemark]) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  Entry clone() {
    return Entry(createdAt, placemark);
  }
}
