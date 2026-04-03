import 'package:equatable/equatable.dart';
import '../../domain/entities/schedule.dart';
import '../../../medicine/domain/entities/medicine.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchedules extends ScheduleEvent {
  final String userId;
  const LoadSchedules(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddSchedule extends ScheduleEvent {
  final Schedule schedule;
  final Medicine medicine; // Needed for notification details
  const AddSchedule(this.schedule, this.medicine);

  @override
  List<Object?> get props => [schedule, medicine];
}

class UpdateSchedule extends ScheduleEvent {
  final Schedule schedule;
  final Medicine medicine;
  const UpdateSchedule(this.schedule, this.medicine);

  @override
  List<Object?> get props => [schedule, medicine];
}

class DeleteSchedule extends ScheduleEvent {
  final String scheduleId;
  const DeleteSchedule(this.scheduleId);

  @override
  List<Object?> get props => [scheduleId];
}
