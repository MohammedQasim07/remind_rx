import 'package:isar/isar.dart';
import '../../domain/entities/schedule.dart';

part 'schedule_model.g.dart';

@collection
class ScheduleModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String medicineId;

  @Index()
  late String userId;

  late DateTime startDate;
  DateTime? endDate;
  
  late DateTime reminderTime;
  
  @enumerated
  late RepeatType repeatType;
  
  List<int>? customRepeatDays;

  ScheduleModel();

  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel()
      ..id = schedule.id
      ..medicineId = schedule.medicineId
      ..userId = schedule.userId
      ..startDate = schedule.startDate
      ..endDate = schedule.endDate
      ..reminderTime = schedule.reminderTime
      ..repeatType = schedule.repeatType
      ..customRepeatDays = schedule.customRepeatDays;
  }

  Schedule toEntity() {
    return _ScheduleImpl(
      id: id,
      medicineId: medicineId,
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      reminderTime: reminderTime,
      repeatType: repeatType,
      customRepeatDays: customRepeatDays,
    );
  }
}

class _ScheduleImpl extends Schedule {
  const _ScheduleImpl({
    required super.id,
    required super.medicineId,
    required super.userId,
    required super.startDate,
    super.endDate,
    required super.reminderTime,
    required super.repeatType,
    super.customRepeatDays,
  });
}
