import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/schedule.dart';

part 'schedule_model.g.dart';

@collection
@JsonSerializable()
class ScheduleModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  @Index()
  late String medicineId;

  @Index()
  String? userId;

  late DateTime startDate;
  DateTime? endDate;
  
  late DateTime reminderTime;
  
  @enumerated
  late RepeatType repeatType;
  
  int? repeatInterval;
  String? daysOfWeek;
  List<int>? customRepeatDays;
  late bool isActive;
  String? notes;

  ScheduleModel();

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel()
      ..id = schedule.id
      ..medicineId = schedule.medicineId
      ..userId = schedule.userId
      ..startDate = schedule.startDate
      ..endDate = schedule.endDate
      ..reminderTime = schedule.reminderTime
      ..repeatType = schedule.repeatType
      ..repeatInterval = schedule.repeatInterval
      ..daysOfWeek = schedule.daysOfWeek
      ..customRepeatDays = schedule.customRepeatDays
      ..isActive = schedule.isActive
      ..notes = schedule.notes;
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
      repeatInterval: repeatInterval,
      daysOfWeek: daysOfWeek,
      customRepeatDays: customRepeatDays,
      isActive: isActive,
      notes: notes,
    );
  }
}

class _ScheduleImpl extends Schedule {
  const _ScheduleImpl({
    required super.id,
    required super.medicineId,
    super.userId,
    required super.startDate,
    super.endDate,
    required super.reminderTime,
    required super.repeatType,
    super.repeatInterval,
    super.daysOfWeek,
    super.customRepeatDays,
    required super.isActive,
    super.notes,
  });
}
