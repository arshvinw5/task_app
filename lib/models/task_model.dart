// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:task_app/core/constants/utils.dart';

class TaskModel {
  final String id;
  final String uId;
  final String title;
  final String description;
  final Color hexColor;
  final DateTime dueAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int isSynced;
  TaskModel({
    required this.id,
    required this.uId,
    required this.title,
    required this.description,
    required this.hexColor,
    required this.dueAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  TaskModel copyWith({
    String? id,
    String? uId,
    String? title,
    String? description,
    Color? hexColor,
    DateTime? dueAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? isSynced,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uId: uId ?? this.uId,
      title: title ?? this.title,
      description: description ?? this.description,
      hexColor: hexColor ?? this.hexColor,
      dueAt: dueAt ?? this.dueAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uId': uId,
      'title': title,
      'description': description,
      'hexColor': rgbToHex(hexColor),
      'dueAt': dueAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      uId: map['uId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      hexColor: hexToColor(map['hexColor'] ?? ''),
      dueAt: DateTime.parse(map['dueAt']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uId: $uId, title: $title, description: $description, hexColor: $hexColor, dueAt: $dueAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uId == uId &&
        other.title == title &&
        other.description == description &&
        other.hexColor == hexColor &&
        other.dueAt == dueAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSynced == isSynced;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        hexColor.hashCode ^
        dueAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSynced.hashCode;
  }
}
