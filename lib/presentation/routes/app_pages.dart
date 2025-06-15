import 'package:get/get.dart';
import 'package:watertime/presentation/activity/activity_binding.dart';
import 'package:watertime/presentation/activity/activity_view.dart';
import 'package:watertime/presentation/boarding/boarding_binding.dart';
import 'package:watertime/presentation/boarding/boarding_view.dart';
import 'package:watertime/presentation/gender_selection/genderselection_binding.dart';
import 'package:watertime/presentation/gender_selection/genderselection_view.dart';
import 'package:watertime/presentation/home/homebinding.dart';
import 'package:watertime/presentation/home/homeview.dart';
import '../weight_measure/weight_binding.dart';
import '../weight_measure/weight_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.BOARDING,
      page: () =>  BoardingView(),
      binding: BoardingBinding(), // ✨ This is where you link the binding!
    ),
    GetPage(
      name: AppRoutes.GENDERSELECTION,
      page: () =>  GenderselectionView(),
      binding: GenderselectionBinding(), // ✨ This is where you link the binding!
    ),
    GetPage(
      name: AppRoutes.WEIGHT,
      page: () =>  WeightView(),
      binding: WeightBinding(), // ✨ This is where you link the binding!
    ),
     GetPage(
      name: AppRoutes.ACTIVITY,
      page: () =>  ActivityView(),
      binding: ActivityBinding(), // ✨ This is where you link the binding!
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () =>  HomeView(),
      binding: Homebinding(), // ✨ This is where you link the binding!
    )
    // ... other routes
  ];
}

class AppRoutes { // Route names define karne ke liye
    static const BOARDING = '/boarding';
    static const GENDERSELECTION = '/genderselection';
    static const WEIGHT = '/weight';
    static const ACTIVITY = '/activity';
    static const HOME = '/home';
    
}