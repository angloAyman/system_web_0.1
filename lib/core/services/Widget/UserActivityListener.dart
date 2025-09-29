import 'package:flutter/material.dart';
import 'package:system/core/services/inactivity_service.dart';

class UserActivityListener extends StatelessWidget {
  final Widget child;
  final InactivityService inactivityService;

  const UserActivityListener({
    Key? key,
    required this.child,
    required this.inactivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => inactivityService.userActivityDetected(context),
      onPanDown: (_) => inactivityService.userActivityDetected(context),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          inactivityService.userActivityDetected(context);
          return false;
        },
        child: child,
      ),
    );
  }
}
