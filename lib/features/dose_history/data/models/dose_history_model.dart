import 'package:isar/isar.dart';
import '../../domain/entities/dose_history.dart';

part 'dose_history_model.g.dart';

@collection
class DoseHistoryModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String scheduleId;

  @Index()
  late String medicineId;

  @Index()
  late String userId;

  @Index()
  late DateTime scheduledTime;

  DateTime? actualTime;

  @enumerated
  late DoseStatus status;

  DoseHistoryModel();

  factory DoseHistoryModel.fromEntity(DoseHistory history) {
    return DoseHistoryModel()
      ..id = history.id
      ..scheduleId = history.scheduleId
      ..medicineId = history.medicineId
      ..userId = history.userId
      ..scheduledTime = history.scheduledTime
      ..actualTime = history.actualTime
      ..status = history.status;
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
    );
  }
}

class _DoseHistoryImpl extends DoseHistory {
  const _DoseHistoryImpl({
    required super.id,
    required super.scheduleId,
    required super.medicineId,
    required super.userId,
    required super.scheduledTime,
    super.actualTime,
    required super.status,
  });
}
