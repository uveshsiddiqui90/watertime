import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:watertime/constants/app_color.dart';
import 'package:watertime/presentation/weight_measure/weight_controller.dart';
import 'package:watertime/settings/setting_controller.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
                
                textStyle: TextStyle(fontSize: 24,color: AppColor.textColor,fontWeight: FontWeight.bold),
                selectedTextStyle: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(height: 10),
              Text('${weight} kg',
                style: TextStyle(fontSize: 30,color: AppColor.textColor,fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        
      ],
    );
  }
}



class WeightPickerDialog extends StatefulWidget 
{
  final int? initialWeight; 

  WeightPickerDialog({this.initialWeight}); 

  @override
  _WeightPickerDialogState createState() => _WeightPickerDialogState();
}

class _WeightPickerDialogState extends State<WeightPickerDialog> 
{

 final SettingController settingController = Get.put(SettingController());
 late int _currentWeight;

  @override
  void initState() {
    super.initState();
    _currentWeight = widget.initialWeight ?? 70; 
  }

  //int _currentWeight = 60;
  
  @override
  Widget build(BuildContext context) {
    print( "Current weight: $_currentWeight");
    return AlertDialog(
      title: Text("Select Your Weight (kg)"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NumberPicker(
            value: _currentWeight,
            minValue: 20,
            maxValue: 200,
            step: 1,
            itemHeight: 50,
            axis: Axis.vertical,
            selectedTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            textStyle: TextStyle(color: Colors.grey),
            onChanged: (value) => setState(() => _currentWeight = value),
          ),
          SizedBox(height: 10),
          Text("Selected: $_currentWeight kg", style: TextStyle(fontSize: 16)),
        ],
      ),
       actions: [
    Center(
      child: Row(
        mainAxisSize: MainAxisSize.min, // 👈 Keeps buttons centered
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              settingController.weightTxt.value.text = _currentWeight.toString();
              Navigator.pop(context);
            },
            child: Text("Done"),
          ),
        ],
       ))]);
  }
}

Widget waveWidget(){
  // Deeper Ocean Blue
final List<List<Color>> oceanGradients = [
  [Color(0xFF2F80ED), Color(0xFF2F80ED)], [Color(0xFF56CCF2), Color(0xFF2F80ED)], // Light Sky Blue to Royal Blue
  

];


return WaveWidget(
               config: CustomConfig(
               gradients: oceanGradients, // Use the calm river gradient
                durations: [5000, 4000],
                heightPercentages: [0.65, 0.66],
                blur: MaskFilter.blur(BlurStyle.solid, 5),
              ),
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, 150),
              waveAmplitude: 0, // 0 for smooth flat wave
                          );


}
          
