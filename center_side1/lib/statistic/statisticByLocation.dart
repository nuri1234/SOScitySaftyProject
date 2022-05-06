import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/uses/share_data.dart';


class locationData{

  final String city;
  final String street;
  final int count;
  Color color=Colors.green;
  String monthString="";

  locationData(this.city,this.street, this.count);



}


class ByLocation extends StatelessWidget {
  List<Map<String,dynamic>> locations;


  ByLocation({Key? key,required this.locations}) : super(key: key);

  List<locationData> _data=[];




  void init(){
    print("ByMonth init");
    for(var e in locations){
      // print(e);
      locationData newL=locationData(e["city"],e['street'],e["count"],);
      if(newL.count>0) newL.color=const Color(0xff8B8000);;
      if(newL.count>3) newL.color=Colors.orangeAccent;
      if(newL.count>5) newL.color=Colors.orange;
      if(newL.count>8) newL.color=Colors.red;
      _data.add(newL);

    }

    for(locationData m in _data){
      print("street:${m.street}, count:${m.count}");
    }



  }




  @override
  Widget build(BuildContext context) {
    init();
    return Container(
      height:600,
      width: 750,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
          color: app_colors.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow:[
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(8,5)

            ),
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(-8,-5)
            ),
          ]
      ),
      child:SfCartesianChart(
          primaryYAxis: CategoryAxis(),
          primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: 7,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500
              ),

          ),
          title: ChartTitle(
              text: my_texts.contactsByLocation,
              textStyle:const TextStyle(color: Colors.black,fontSize: 20)),
          //   legend: Legend(isVisible: true,),
          // tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<locationData, String>>[
            // Renders column chart
            ColumnSeries<locationData, String>(
                dataSource: _data,
                yValueMapper: (locationData locatin, _) => locatin.count,
                xValueMapper:(locationData locatin, _) =>locatin.street,

                pointColorMapper:(locationData locatin, _) => locatin.color,
                width: 0.2,
              spacing: 0,
            ),

          ]


      ),



    );
  }
}
