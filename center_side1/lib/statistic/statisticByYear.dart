import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/uses/share_data.dart';


class yearData{

  final int year;
  final int count;
  Color color=Colors.green;


  yearData(this.year, this.count);



}


class ByYear extends StatelessWidget {
  List<Map<String,dynamic>> years;


  ByYear({Key? key,required this.years}) : super(key: key);

  List<yearData> _data=[];




  void init(){
    print("ByMonth init");
    for(var e in years){
      // print(e);
      yearData newM=yearData(e["year"],e["count"]);
      if(newM.count>0) newM.color=const Color(0xff8B8000);;
      if(newM.count>3) newM.color=Colors.orangeAccent;
      if(newM.count>5) newM.color=Colors.orange;
      if(newM.count>8) newM.color=Colors.red;
      _data.add(newM);

    }

    for(yearData m in _data){
      print("year:${m.year}, count:${m.count}");
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
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(
              text: my_texts.contactsByYear,
              textStyle:const TextStyle(color: Colors.black,fontSize: 20)),
          //   legend: Legend(isVisible: true,),
          // tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<yearData, int>>[

            // Renders column chart
            ColumnSeries<yearData, int>(
              dataSource: _data,
              yValueMapper: (yearData yeard, _) => yeard.count,
              xValueMapper:(yearData yeard, _) =>yeard.year,
              pointColorMapper:(yearData month, _) => month.color,
              width: 0.2

            ),

          ]


      ),



    );
  }
}
