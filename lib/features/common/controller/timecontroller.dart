import 'dart:async';

import 'package:get/get.dart';



class TimerController extends GetxController {
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxBool isTimerZero = false.obs;
  late DateTime endTime;
  Timer? timer;

  void startTimer(DateTime endTime) {
    this.endTime = endTime;
    updateRemainingTime();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateRemainingTime();

      if (endTime.isBefore(DateTime.now())) {
        // Timer has reached the end time, stop the timer.
        stopTimer();
      }
    });
  }

  void updateRemainingTime() {
    Duration remainingTime = endTime.difference(DateTime.now());
    if (remainingTime.isNegative) {
      // If remaining time is negative, set to zero and stop the timer.
      minutes.value = 0;
      seconds.value = 0;
      isTimerZero.value = true;
      stopTimer();
    } else {
      minutes.value = remainingTime.inMinutes;
      seconds.value = remainingTime.inSeconds % 60;
    }
  }

  void stopTimer() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
  }
}
