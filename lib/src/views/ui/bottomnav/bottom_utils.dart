import 'package:flutter/material.dart';
import 'package:team360/src/views/ui/attendence_screen.dart';
import 'package:team360/src/views/ui/schedule_all.dart';

import '../approval_screen.dart';

List<Widget> homeScreenItems2 = [
  const AllSchedule(isFirst: true,),
  const AttendanceScreen(),
  const Approval(),
];