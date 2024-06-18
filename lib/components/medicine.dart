import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final int compartment;
  final Color color;
  final String type;
  final String quantity;
  final int totalCount;
  final String frequency;

  Medicine({
    required this.name,
    required this.compartment,
    required this.color,
    required this.type,
    required this.quantity,
    required this.totalCount,
    required this.frequency,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'compartment': compartment,
      'color': color.value,
      'type': type,
      'quantity': quantity,
      'totalCount': totalCount,
      'frequency': frequency,
    };
  }
}
