import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationSettings extends NotificationsEvent {}

class ToggleNotifications extends NotificationsEvent {
  final bool isEnabled;

  const ToggleNotifications(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}
