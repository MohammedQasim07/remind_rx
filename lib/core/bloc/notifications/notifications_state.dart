import 'package:equatable/equatable.dart';

class NotificationsState extends Equatable {
  final bool isEnabled;

  const NotificationsState({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}
