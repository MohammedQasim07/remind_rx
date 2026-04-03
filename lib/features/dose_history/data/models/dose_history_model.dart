import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dose_history.dart';

part 'dose_history_model.g.dart';

@collection
@JsonSerializable()
class DoseHistoryModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String scheduleId;

  @Index()
  late String medicineId;

  @Index()
  String? userId;

  @Index()
  late DateTime scheduledTime;

  DateTime? actualTime;

  @enumerated
  late DoseStatus status;
  
  String? notes;

  DoseHistoryModel();

  factory DoseHistoryModel.fromJson(Map<String, dynamic> json) => _$DoseHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoseHistoryModelToJson(this);

  factory DoseHistoryModel.fromEntity(DoseHistory history) {
    return DoseHistoryModel()
      ..id = history.id
      ..scheduleId = history.scheduleId
      ..medicineId = history.medicineId
      ..userId = history.userId
      ..scheduledTime = history.scheduledTime
      ..actualTime = history.actualTime
      ..status = history.status
      ..notes = history.notes;
  }

  DoseHistory toEntity() {
    return _DoseHistoryImpl(
      id: id,
      scheduleId: scheduleId,
      medicineId: medicineId,
      userId: userId,
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      status: status,
      notes: notes,
    );
  }
}

class _DoseHistoryImpl extends DoseHistory {
  const _DoseHistoryImpl({
    required super.id,
    required super.scheduleId,
    required super.medicineId,
    super.userId,
    required super.scheduledTime,
    super.actualTime,
    required super.status,
    super.notes,
  });
}
