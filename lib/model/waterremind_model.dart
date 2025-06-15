import 'package:flutter/material.dart';

class WaterRemindModel {
  final String? time;  
  final String? waterML; 
  final TimeOfDay? timeOfDay;
  final int? id;

  // Constructor
  WaterRemindModel({
    this.time,
    this.waterML,
    this.timeOfDay,
    this.id,
  
  });
  String get formattedTime => 
      '${timeOfDay?.hour.toString().padLeft(2, '0')}:${timeOfDay?.minute.toString().padLeft(2, '0')}';

 WaterRemindModel copyWith({
    String? time,
    String? waterML,
    TimeOfDay? timeOfDay,
    int? id,
  }) {
    return WaterRemindModel(
      time: time ?? this.time,
      waterML: waterML ?? this.waterML,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      id: id ?? this.id,
    );
  }

}