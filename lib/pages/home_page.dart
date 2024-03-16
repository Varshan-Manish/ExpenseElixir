import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:project_23/database/transaction_model.dart';
import 'package:project_23/database/budget_model.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
class BudgetVExpense{
  final String type;
  final double typeValue;
  BudgetVExpense(this.type,this.typeValue);
}
class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState()=>_HomePageState();
}
List<String> retrievalOptions=['weekly','monthly'];
class _HomePageState extends State<HomePage>{
  _HomePageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  late List<BudgetVExpense> budgetVExpenseData=[];
  String currentOption=retrievalOptions[0];
  List<TransactionModel> transactionTotalIncome=[];
  List<TransactionModel> transactionExpenseIncome=[];
  List<TransactionModel> transactionLoanReturned=[];
  List<TransactionModel> transactionLoanReturns=[];
  List<BudgetModel> budgetList=[];
  List<TransactionModel> allIncomeList=[];
  List<TransactionModel> allExpenseList=[];
  double income=0;
  double expense=0;
  double grandTotal=0;
  int loopLimiter=0;
  String budgetWarning='Your Budget Management Is Alright So Far';
  Color budgetWarningColor=Colors.green;
  TextEditingController budgetController=TextEditingController();
  List<BudgetVExpense> getBudgetVExpense(){
    BudgetVExpense budget=BudgetVExpense('budget',budgetList[0].budget);
    BudgetVExpense tExpense=BudgetVExpense('expense',expense);
    List<BudgetVExpense> list=[budget,tExpense];
    return list;
  }
  double incomeBarValue(double income,double expense){
    if(income==0){
      return 0.01;
    }
    else{
      return income*100/(income+expense)/100;
    }
  }
  double expenseBarValue(double income,double expense){
    if(expense==0){
      return 0.01;
    }
    else{
      return expense*100/(income+expense)/100;
    }
  }
  Future<String?> showBudgetDialog(){
    return showDialog<String>(
      context: context,
      builder:(context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title:Align(
            alignment:Alignment.center,
            child: Text('${currentOption[0].toUpperCase()+currentOption.substring(1)} Budget',
            style:GoogleFonts.montserrat(color:Colors.white,fontWeight:FontWeight.bold)),
          ),
          content: TextField(
            decoration:const InputDecoration(hintText: 'Enter Budget Amount',fillColor:Colors.white,filled:true,
              enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),
              focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
            LengthLimitingTextInputFormatter(8)],
            keyboardType: TextInputType.number,
            controller:budgetController,
          ),
          actions:[
            TextButton(child:Text('CANCEL',style:GoogleFonts.montserrat(color:Colors.green)),
            onPressed:(){
              Navigator.of(context).pop(null);
            }),
            TextButton(child:Text('SUBMIT',style:GoogleFonts.montserrat(color:Colors.green)),
                onPressed:(){
                  Navigator.of(context).pop(budgetController.text);
                }),
          ],
        );
      },
    );
  }
  void initializeTransaction()async{
    budgetList=await databaseHelper.getBudgetList();
    transactionLoanReturned=await databaseHelper.getLoansReturnedTransactionList();
    transactionLoanReturns=await databaseHelper.getLoansReturnsTransactionList();
    allIncomeList=await databaseHelper.getAllIncomeTransactionList();
    allExpenseList=await databaseHelper.getAllExpenseTransactionList();
    grandTotal=double.parse(allIncomeList[0].sAmount as String)-double.parse(allExpenseList[0].sAmount as String);
    if(budgetList[0].mode=='weekly'){
      transactionTotalIncome = await databaseHelper.getWeeklyIncomeTransactionList();
      transactionExpenseIncome = await databaseHelper.getWeeklyExpenseTransactionList();
      income = double.parse(transactionTotalIncome[0].sAmount as String)-
          double.parse(transactionLoanReturned[0].sAmount as String)-double.parse(transactionLoanReturns[0].sAmount as String);
      expense = double.parse(transactionExpenseIncome[0].sAmount as String)-
          double.parse(transactionLoanReturns[0].sAmount as String)-double.parse(transactionLoanReturned[0].sAmount as String);
      currentOption=retrievalOptions[0];
    }
    if(budgetList[0].mode=='monthly'){
      transactionTotalIncome = await databaseHelper.getMonthlyIncomeTransactionList();
      transactionExpenseIncome = await databaseHelper.getMonthlyExpenseTransactionList();
      income = double.parse(transactionTotalIncome[0].sAmount as String)-
          double.parse(transactionLoanReturned[0].sAmount as String)-double.parse(transactionLoanReturns[0].sAmount as String);
      expense = double.parse(transactionExpenseIncome[0].sAmount as String)-
          double.parse(transactionLoanReturns[0].sAmount as String)-double.parse(transactionLoanReturned[0].sAmount as String);
      currentOption=retrievalOptions[1];
    }
    if(expense<0){
      income=income-expense;
      expense=0;
    }
    if(income<0){
      expense=expense-income;
      income=0;
    }
    if(budgetList[0].budget==0){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:Text('Your Budget Has Been Reset Or Has Never Been Set Please Set Up Your Budget',
        style: GoogleFonts.montserrat(color:Colors.white),),
        backgroundColor: Colors.red,
      ),);
    }
    if(budgetList[0].budget*0.9<=expense && expense!=0){
      budgetWarning='About To Cross Your Budget Spend Wisely';
      budgetWarningColor=Colors.red;
    }
    if(expense>budgetList[0].budget && expense!=0){
      budgetWarning='Already Crossed Budget';
    }
    budgetVExpenseData=getBudgetVExpense();
    setState((){});
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(transactionTotalIncome.isEmpty && transactionExpenseIncome.isEmpty){
      if(loopLimiter<50){
        initializeTransaction();
        setState(() {});
      }
      return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[Colors.greenAccent, Colors.white],
            ),
          ),
          child: Scaffold(
            appBar:AppBar(
              backgroundColor: Colors.green,
              title:Text('Home',style:GoogleFonts.montserrat(color:Colors.black,fontSize:30,fontWeight:
              FontWeight.w500,),
              ),
              centerTitle:true,
            ),
            backgroundColor: Colors.transparent,
            body:Center(
                child: Text('Loading Home Page Please Wait...',style:GoogleFonts.montserrat())),
          ),
      );
    }
    else {
      if(budgetList[0].budget==0){
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
            appBar: AppBar(
                title: Text('Home',
                    style: GoogleFonts.montserrat(
                        fontSize: 30.0, fontWeight: FontWeight.w500)),
                backgroundColor: Colors.green,
                centerTitle: true),
            body: Wrap(
              children: [
                Column(
                  children: <Widget>[
                    Align(
                      alignment:Alignment.center,
                      child: Text('Budget VS Expense',
                        style: GoogleFonts.montserrat(color: Colors.black,fontWeight:FontWeight.w500),),
                    ),
                    const SizedBox(height:10),
                    Align(
                      alignment:Alignment.center,
                      child: Text('Enter budget to view doughNut chart',style:GoogleFonts.montserrat(color:
                      Colors.black)),
                    ),
                    const Divider(color:Colors.green),
                    Align(alignment: Alignment.center,
                      child: Text(
                        'Budget Overview',
                        style: GoogleFonts.montserrat(color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                                child: Text('Budget: ${budgetList[0].budget}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20, fontWeight: FontWeight.w600,
                                      color: Colors.black),),
                              ),
                              IconButton(icon: const ImageIcon(
                                  AssetImage('assets/icons/edit_icon.png')),
                                  onPressed: ()async{
                                    String? budget=await showBudgetDialog();
                                    if(budget!=null){
                                      await databaseHelper.updateBudgetBudgetTable(double.parse(budget));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Budget Updated Successfully',
                                            style:GoogleFonts.montserrat(color:Colors.white)),
                                          backgroundColor: Colors.green,),
                                      );
                                      budgetController.clear();
                                      setState((){initializeTransaction();});
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No Changes To Budget Occurred',
                                            style:GoogleFonts.montserrat(color:Colors.white)),
                                          backgroundColor: Colors.red,),
                                      );
                                      budgetController.clear();
                                    }
                                  }),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      'Weekly', style: GoogleFonts.montserrat()),
                                  leading: Radio(
                                    groupValue: currentOption,
                                    value: retrievalOptions[0],
                                    onChanged: (value)async{
                                      await databaseHelper.updateModeBudgetTable('weekly');
                                      setState(() {
                                        currentOption = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                      'Monthly', style: GoogleFonts.montserrat()),
                                  leading: Radio(
                                    groupValue: currentOption,
                                    value: retrievalOptions[1],
                                    onChanged: (value)async{
                                      await databaseHelper.updateModeBudgetTable('monthly');
                                      setState(() {
                                        currentOption = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text('${currentOption[0].toUpperCase()+currentOption.substring(1)} Income And Expense', style: GoogleFonts.montserrat(
                        fontSize: 20, color: Colors.black,
                        fontWeight: FontWeight.w500)),
                    Align(
                      alignment:Alignment.center,
                      child: Text('Income: +$income', style: GoogleFonts.montserrat(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                    ),
                    const SizedBox(height:20),
                    Align(
                      alignment:Alignment.center,
                      child: Text('Expense: -$expense', style: GoogleFonts.montserrat(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      )),
                    ),
                    const SizedBox(height:30),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Grand Total: $grandTotal',
                          style: GoogleFonts.montserrat(color: Colors.green,
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: () {
                Navigator.pushNamed(context, '/expense_page',);
              },
              child: const ImageIcon(AssetImage('assets/icons/expense_icon.png')),
            ),
          ),
        );
      }
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
          appBar: AppBar(
              title: Text('Home',
                  style: GoogleFonts.montserrat(
                      fontSize: 30.0, fontWeight: FontWeight.w500)),
              backgroundColor: Colors.green,
              centerTitle: true),
          body: Wrap(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 230,
                    child: SfCircularChart(
                      centerY: '75.0',
                      backgroundColor: Colors.transparent,
                      title: ChartTitle(text: 'Budget VS Expense',
                          textStyle: GoogleFonts.montserrat(color: Colors.black,fontWeight:FontWeight.w500),),
                      legend: const Legend(isVisible: true),
                      palette: const [Colors.green, Colors.redAccent],
                      margin: EdgeInsets.zero,
                      series: <DoughnutSeries>[
                        DoughnutSeries<BudgetVExpense, String>(
                          cornerStyle: CornerStyle.bothCurve,
                          explodeGesture: ActivationMode.doubleTap,
                          explode: true,
                          animationDelay: 3,
                          radius: '75.0',
                          innerRadius: '50',
                          dataSource: budgetVExpenseData,
                          xValueMapper: (BudgetVExpense data, _) => data.type,
                          yValueMapper: (BudgetVExpense data, _) => data.typeValue,
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true, textStyle: GoogleFonts.montserrat()),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment:Alignment.center,
                    child:Text(budgetWarning,style:GoogleFonts.montserrat(color:budgetWarningColor)),
                  ),
                  const Divider(color:Colors.green),
                  Align(alignment: Alignment.center,
                    child: Text(
                      'Budget Overview',
                      style: GoogleFonts.montserrat(color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                              child: Text('Budget: ${budgetList[0].budget}',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, fontWeight: FontWeight.w600,
                                    color: Colors.black),),
                            ),
                            IconButton(icon: const ImageIcon(
                                AssetImage('assets/icons/edit_icon.png')),
                                onPressed: ()async{
                                    String? budget=await showBudgetDialog();
                                    if(budget!=null){
                                      await databaseHelper.updateBudgetBudgetTable(double.parse(budget));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Budget Updated Successfully',
                                        style:GoogleFonts.montserrat(color:Colors.white)),
                                        backgroundColor: Colors.green,),
                                      );
                                      budgetController.clear();
                                      setState((){initializeTransaction();});
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('No Changes To Budget Occurred',
                                              style:GoogleFonts.montserrat(color:Colors.white)),
                                            backgroundColor: Colors.red,),
                                      );
                                      budgetController.clear();
                                    }
                                }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(
                                    'Weekly', style: GoogleFonts.montserrat()),
                                leading: Radio(
                                  groupValue: currentOption,
                                  value: retrievalOptions[0],
                                  onChanged: (value)async{
                                    await databaseHelper.updateModeBudgetTable('weekly');
                                    setState(() {
                                      currentOption = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                    'Monthly', style: GoogleFonts.montserrat()),
                                leading: Radio(
                                  groupValue: currentOption,
                                  value: retrievalOptions[1],
                                  onChanged: (value)async{
                                    await databaseHelper.updateModeBudgetTable('monthly');
                                    setState(() {
                                      currentOption = value as String;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text('${currentOption[0].toUpperCase()+currentOption.substring(1)} Income And Expense', style: GoogleFonts.montserrat(
                      fontSize: 20, color: Colors.black,
                      fontWeight: FontWeight.w500)),
                  Align(
                    alignment:Alignment.bottomLeft,
                    child: Align(
                      alignment:Alignment.center,
                      child: Text('Income: +$income', style: GoogleFonts.montserrat(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  Align(
                    alignment:Alignment.bottomLeft,
                    child: SimpleAnimationProgressBar(
                      height: 15,
                      width: 300,
                      backgroundColor: Colors.transparent,
                      foregrondColor: Colors.green,
                      ratio: incomeBarValue(income,expense),
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow:  const [
                        BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height:5),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Align(
                      alignment:Alignment.center,
                      child: Text('Expense: -$expense', style: GoogleFonts.montserrat(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),overflow:TextOverflow.ellipsis),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SimpleAnimationProgressBar(
                      height: 15,
                      width: 300,
                      backgroundColor: Colors.transparent,
                      foregrondColor: Colors.red,
                      ratio: expenseBarValue(income,expense),
                      direction: Axis.horizontal,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(seconds: 3),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow:  const [
                        BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('Grand Total: $grandTotal',
                        style: GoogleFonts.montserrat(color: Colors.green,
                            fontSize: 25, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.pushNamed(context, '/expense_page',);
            },
            child: const ImageIcon(AssetImage('assets/icons/expense_icon.png')),
          ),
        ),
      );
    }
  }
}
