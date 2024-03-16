import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_23/database/stat_settings_model.dart';
class TransactionWithDay{
  String day;
  double amount;
  TransactionWithDay(this.day,this.amount);
}
class StatisticsGraphPage extends StatefulWidget{
  const StatisticsGraphPage({super.key});
  @override
  State<StatisticsGraphPage> createState() =>_StatisticsGraphPageState();
}
class _StatisticsGraphPageState extends State<StatisticsGraphPage> {
  _StatisticsGraphPageState();
  int loopLimiter=0;
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<StatSettingsModel> statSettingList=[];
  List<TransactionWithDay> transactionWithDay=[];
  void initializeDB()async{
    statSettingList=await databaseHelper.getStatSettingsList();
    if(statSettingList[0].tQuery=='Income') {
      if(statSettingList[0].tTime=='Weekly'){
        List<TransactionModel>transactionList = await databaseHelper.getWeeklyDailyIncomeTransactionList();
        int count = transactionList.length;
        for (int i = 0; i < count; i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String)))
                  .toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
      else if(statSettingList[0].tTime=='Monthly'){
        List<TransactionModel>transactionList = await databaseHelper.getMonthlyDailyIncomeTransactionList();
        int count = transactionList.length;
        for (int i = 0; i < count; i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String)))
                  .toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
      else if(statSettingList[0].tTime=='All'){
        List<TransactionModel>transactionList = await databaseHelper.getAllDailyIncomeTransactionList();
        int count = transactionList.length;
        for (int i = 0; i < count; i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String)))
                  .toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
    }
    else if(statSettingList[0].tQuery=='Expense'){
      if(statSettingList[0].tTime=='Weekly'){
        List<TransactionModel>transactionList = await databaseHelper.getWeeklyDailyExpenseTransactionList();
        int count=transactionList.length;
        for (int i=0;i<count;i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String))).toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
      else if(statSettingList[0].tTime=='Monthly'){
        List<TransactionModel>transactionList = await databaseHelper.getMonthlyDailyExpenseTransactionList();
        int count=transactionList.length;
        for (int i=0;i<count;i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String))).toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
      else if(statSettingList[0].tTime=='All'){
        List<TransactionModel>transactionList = await databaseHelper.getAllDailyExpenseTransactionList();
        int count=transactionList.length;
        for (int i=0;i<count;i++) {
          transactionWithDay.add(TransactionWithDay(
              (DateFormat('d MMM yyyy').format(
                  DateTime.parse(transactionList[i].dateReadable as String))).toString(),
              double.parse(transactionList[i].sAmount as String)));
        }
      }
    }
    setState((){});
  }
  @override
  Widget build(BuildContext context){
    if(transactionWithDay.isEmpty){
      if(loopLimiter<50){
        initializeDB();
        loopLimiter++;
        return Container(
          decoration:const BoxDecoration(
            gradient:LinearGradient(
              begin:Alignment.bottomLeft,
              end:Alignment.topRight,
              colors:<Color>[Colors.greenAccent,Colors.white],
            ),
          ),
          child: Scaffold(
              backgroundColor:Colors.transparent,
              body:Center(
                  child: Text('Loading Statistics Please Wait...',style:GoogleFonts.montserrat(
                      color:Colors.black)))),
        );
      }
      return Container(
        decoration:const BoxDecoration(
          gradient:LinearGradient(
            begin:Alignment.bottomLeft,
            end:Alignment.topRight,
            colors:<Color>[Colors.greenAccent,Colors.white],
          ),
        ),
        child: Scaffold(
            backgroundColor:Colors.transparent,
            body:Center(
                child: Text('No Statistics To Display',
                    style:GoogleFonts.montserrat(color:Colors.black)))),
      );
    }
    else {
      return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[Colors.greenAccent, Colors.white],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              child: SfCartesianChart(
                title: ChartTitle(text: '${statSettingList[0].tTime} '
                    '${statSettingList[0].tQuery} Bar Statistics',
                    textStyle: GoogleFonts.montserrat(
                      color: Colors.black, fontWeight: FontWeight.w500,
                    )),
                backgroundColor: Colors.transparent,
                primaryXAxis: const CategoryAxis(
                    majorGridLines: MajorGridLines(color: Colors.transparent)),
                primaryYAxis: const NumericAxis(
                  majorGridLines: MajorGridLines(color: Colors.transparent),
                ),
                zoomPanBehavior: ZoomPanBehavior(
                    enablePanning:true,),
                palette: const [Colors.green,Colors.red],
                isTransposed: true,
                series: <BarSeries>[
                  BarSeries<TransactionWithDay, String>(
                    dataSource: transactionWithDay,
                    xValueMapper: (TransactionWithDay data, _) => data.day,
                    yValueMapper: (TransactionWithDay data, _) => data.amount,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,),
                    animationDelay: 3,
                    borderColor: Colors.black,
                    color: Colors.green,
                  ),
                ],

              ),
            ),
          )
      );
    }
  }
}