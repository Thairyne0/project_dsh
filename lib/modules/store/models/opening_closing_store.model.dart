import 'package:flutter/material.dart';
import 'package:project_dsh/utils/models/custom_model.model.dart';

class OpeningClosingStore extends BaseModel {
  int id;
  TimeOfDay? morningOpening;
  TimeOfDay? morningClosing;
  TimeOfDay? eveningOpening;
  TimeOfDay? eveningClosing;

  // Controller per i campi di input
  late TextEditingController morningOpeningTEC = TextEditingController();
  late TextEditingController morningClosingTEC = TextEditingController();
  late TextEditingController eveningOpeningTEC = TextEditingController();
  late TextEditingController eveningClosingTEC = TextEditingController();

  @override
  String get modelIdentifier => "$id";

  OpeningClosingStore._internal({
    required this.id,
    this.morningOpening,
    this.morningClosing,
    this.eveningOpening,
    this.eveningClosing,
  });

  factory OpeningClosingStore({
    int id = 0,
    TimeOfDay? morningOpening,
    TimeOfDay? morningClosing,
    TimeOfDay? eveningOpening,
    TimeOfDay? eveningClosing,
  }) {
    return OpeningClosingStore._internal(
      id: id,
      morningOpening: morningOpening,
      morningClosing: morningClosing,
      eveningOpening: eveningOpening,
      eveningClosing: eveningClosing,
    );
  }

  factory OpeningClosingStore.fromJson({
    required dynamic jsonObject,
  }) {
    // Funzione ausiliaria per convertire una stringa in TimeOfDay oppure restituire null se vuota
    TimeOfDay? parseTime(String? timeStr) {
      if (timeStr == null || timeStr.isEmpty) return null;
      final parts = timeStr.split(":");
      if (parts.length != 2) return null;
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    }

    final instance = OpeningClosingStore(
      id: int.tryParse(jsonObject["id"]) ?? 0,
      morningOpening: parseTime(jsonObject["morningOpening"]?.toString()),
      morningClosing: parseTime(jsonObject["morningClosing"]?.toString()),
      eveningOpening: parseTime(jsonObject["eveningOpening"]?.toString()),
      eveningClosing: parseTime(jsonObject["eveningClosing"]?.toString()),
    );

    // Imposta i controller: se il valore è null, lascialo vuoto
    instance.morningOpeningTEC.text = instance.morningOpening != null
        ? "${instance.morningOpening!.hour.toString().padLeft(2, '0')}:${instance.morningOpening!.minute.toString().padLeft(2, '0')}"
        : "";
    instance.morningClosingTEC.text = instance.morningClosing != null
        ? "${instance.morningClosing!.hour.toString().padLeft(2, '0')}:${instance.morningClosing!.minute.toString().padLeft(2, '0')}"
        : "";
    instance.eveningOpeningTEC.text = instance.eveningOpening != null
        ? "${instance.eveningOpening!.hour.toString().padLeft(2, '0')}:${instance.eveningOpening!.minute.toString().padLeft(2, '0')}"
        : "";
    instance.eveningClosingTEC.text = instance.eveningClosing != null
        ? "${instance.eveningClosing!.hour.toString().padLeft(2, '0')}:${instance.eveningClosing!.minute.toString().padLeft(2, '0')}"
        : "";

    return instance;
  }

  Map<String, dynamic> toMap() {
    // Se il valore è null, restituisci una stringa vuota
    String formatTime(TimeOfDay? time) => time != null
        ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
        : "";

    return {
      'id': id,
      'morningOpening': formatTime(morningOpening),
      'morningClosing': formatTime(morningClosing),
      'eveningOpening': formatTime(eveningOpening),
      'eveningClosing': formatTime(eveningClosing),
    };
  }
}