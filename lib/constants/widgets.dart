import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:watertime/presentation/weight_measure/weight_controller.dart';

class WeightInput extends StatefulWidget {
  @override
  _WeightInputState createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  int weight = 70;
WeightController weightController = Get.put(WeightController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300.w,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.blue[100]!, Colors.white]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              NumberPicker(
                minValue: 30,
                maxValue: 200,
              //  decimalPlaces: 1,
                value: weight,
                onChanged: (v) {
                  setState(() {
                   // Get.find<WeightController>().userWeight.value = v;
                   weightController.userWeight.value = v;
                    weight = v;
                  });
                },
                
                textStyle: TextStyle(fontSize: 24),
                selectedTextStyle: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              Text('${weight} kg',
                style: TextStyle(fontSize: 30)),
            ],
          ),
        ),
        
      ],
    );
  }
}

