import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_23/database/transaction_model.dart';
import 'package:project_23/database/stat_settings_model.dart';
class TransactionWithAmount{
  final String type;
  final double amount;
  TransactionWithAmount(this.type,this.amount);
}
class StatisticsPiePage extends StatefulWidget{
  const StatisticsPiePage({super.key});
  @override
  State<StatisticsPiePage> createState() =>_StatisticsPiePageState();
}
List<TransactionWithAmount> transactionWithAmountList=[];
List<TransactionWithAmount> getTransactionWithAmount(List<TransactionModel> transactionModelList){
  int count=transactionModelList.length;
  List<TransactionWithAmount> transactionWithAmountList=[];
  for(int i=0;i<count;i++){
    TransactionWithAmount variable=TransactionWithAmount(transactionModelList[i].tSubType as String,
    double.parse(transactionModelList[i].sAmount as String));
    transactionWithAmountList.add(variable);
  }
  return transactionWithAmountList;
}
class _StatisticsPiePageState extends State<StatisticsPiePage>{
  _StatisticsPiePageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  int loopLimiter=0;
  List<StatSettingsModel> statSettingList=[];
  List<TransactionModel> transactionList=[];
  Future<void> initalizeTransactions()async{
    statSettingList=await databaseHelper.getStatSettingsList();
    if(statSettingList[0].tQuery=='Income') {
      if(statSettingList[0].tTime=='Weekly'){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getWeeklyFundsInflowTransactionList();
        if(transactionList1[0].tSubType!=null){
        transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyPrizeMoneyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyLoanReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyLoanTakenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyInvestmentReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklySalaryTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
      else if(statSettingList[0].tTime=='Monthly'){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getMonthlyFundsInflowTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyPrizeMoneyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanTakenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyInvestmentReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlySalaryTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
      else if(statSettingList[0].tTime=='All'){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getAllFundsInflowTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getAllPrizeMoneyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getAllLoanReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getAllLoanTakenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getAllInvestmentReturnsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getAllSalaryTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
      }
    else if(statSettingList[0].tQuery=='Expense'){
      if(statSettingList[0].tTime=='Weekly'){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getWeeklyFoodAndBeverageTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyStationarySuppliesTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyEntertainmentAndLeisureTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklySubscriptionsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyLoanReturnedTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyLoanGivenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyMedicalTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyClothingTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyGeneralSupplyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyPartnerTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyCelebrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyEventRegistrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyTravelTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getWeeklyMiscellaneousTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
      else if(statSettingList[0].tTime=="Monthly"){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getMonthlyFoodAndBeverageTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyStationarySuppliesTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyEntertainmentAndLeisureTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlySubscriptionsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanReturnedTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanGivenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyMedicalTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyClothingTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyGeneralSupplyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyPartnerTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyCelebrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyEventRegistrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyTravelTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyMiscellaneousTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
      else if(statSettingList[0].tTime=='All'){
        List<TransactionModel> transactionList1 = [];
        transactionList1=await databaseHelper.getMonthlyFoodAndBeverageTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyStationarySuppliesTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyEntertainmentAndLeisureTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlySubscriptionsTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanReturnedTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyLoanGivenTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyMedicalTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyClothingTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyGeneralSupplyTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyPartnerTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyCelebrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyEventRegistrationTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyTravelTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
        transactionList1=await databaseHelper.getMonthlyMiscellaneousTransactionList();
        if(transactionList1[0].tSubType!=null){
          transactionList.addAll(transactionList1);
        }
      }
    }
    transactionWithAmountList=getTransactionWithAmount(transactionList);
    setState((){});
    }
  @override
  Widget build(BuildContext context) {
    if(transactionList.isEmpty){
      if(loopLimiter<5) {
        initalizeTransactions();
        loopLimiter++;
        return Container(
          decoration:const BoxDecoration(
            gradient:LinearGradient(
              begin:Alignment.bottomLeft,
              end:Alignment.topRight,
              colors:<Color>[Colors.greenAccent,Colors.white],
            ),
          ),
          child:Scaffold(
            backgroundColor: Colors.transparent,
            body:Center(
              child: Text('Loading Statistics Please Wait...',style:GoogleFonts.montserrat(color:Colors.black)),
            ),
          ),
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
        child:Scaffold(
          backgroundColor: Colors.transparent,
          body:Center(
              child: Text('No Statistics To Display',style:GoogleFonts.montserrat(color:Colors.black)),
          ),
        ),
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
          backgroundColor: Colors.transparent,
          body:SizedBox(
            child:SfCircularChart(
              centerY:'150',
              backgroundColor:Colors.transparent,
              title:ChartTitle(text:'${statSettingList[0].tTime} '
                  '${statSettingList[0].tQuery} Statistics',textStyle:GoogleFonts.montserrat(color:Colors.black,
              fontWeight:FontWeight.w500,)),
              legend:const Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap,
                  shouldAlwaysShowScrollbar:true),
              palette:const [Colors.black,Colors.blue,Colors.yellow,Colors.indigo,
                Colors.green,Colors.red,Colors.purple,Colors.white,Colors.cyan,
              Colors.grey,Colors.orange,Colors.pink,Colors.brown,Colors.teal],
              margin: EdgeInsets.zero,
              series:<PieSeries>[
                PieSeries<TransactionWithAmount,String>(
                  animationDelay: 1,
                  explodeGesture: ActivationMode.doubleTap,
                  explode: true,
                  strokeColor: Colors.black,
                  radius: '120.0',
                  dataSource: transactionWithAmountList,
                  xValueMapper: (TransactionWithAmount data,_)=>data.type,
                  yValueMapper: (TransactionWithAmount data,_)=>data.amount,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true, textStyle: GoogleFonts.montserrat(),
                      overflowMode: OverflowMode.shift),
                ),
              ],
            ),
          ),

          ),
      );
  }
}