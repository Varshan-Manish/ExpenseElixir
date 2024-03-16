import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class BalanceSheetFundsFlowPage extends StatefulWidget{
  const BalanceSheetFundsFlowPage({super.key});
  @override
  State<BalanceSheetFundsFlowPage> createState() =>_BalanceSheetFundsFlowPageState();
}
class _BalanceSheetFundsFlowPageState extends State<BalanceSheetFundsFlowPage>{
  _BalanceSheetFundsFlowPageState();
  String placeholderText='Loading Transactions Please Wait...';
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<TransactionModel>transactionList=[];
  List<TransactionModel>loanTakenTransactionList=[];
  List<TransactionModel>loanReturnedTransactionList=[];
  List<TransactionModel>loanGivenTransactionList=[];
  List<TransactionModel>loanReturnsTransactionList=[];
  String? dropdownValue='week';
  int transactionTableCount=0;
  int loopLimiter=0;
  double loansTaken=0;
  double loansGiven=0;
  void initializeTransactionList()async{
    List<TransactionModel>transactionList1;
    loanTakenTransactionList=await databaseHelper.getLoansTakenTransactionList();
    loanReturnedTransactionList=await databaseHelper.getLoansReturnedTransactionList();
    loanGivenTransactionList=await databaseHelper.getLoansGivenTransactionList();
    loanReturnsTransactionList=await databaseHelper.getLoansReturnsTransactionList();
    loansTaken=double.parse(loanTakenTransactionList[0].sAmount as String)-double.parse(loanReturnedTransactionList[0].sAmount as String);
    loansGiven=double.parse(loanGivenTransactionList[0].sAmount as String)-double.parse(loanReturnsTransactionList[0].sAmount as String);
    if(dropdownValue=='week'){
      transactionList1 = await databaseHelper.getWeeklyTransactionList();
      transactionTableCount = transactionList1.length;
    }
    else{
      transactionList1 = await databaseHelper.getMonthlyTransactionList();
      transactionTableCount = transactionList1.length;
    }
    setState((){
      transactionList=transactionList1;
      placeholderText='No Transactions To Show';
    });
  }
  @override
  Widget build(BuildContext context){
    if(transactionList.isEmpty){
      if(loopLimiter<50) {
        loopLimiter++;
        initializeTransactionList();
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
            body:Column(
              children: <Widget>[
                  Column(
                  children:<Widget>[
                    Card(
                      shape:const BeveledRectangleBorder(),
                      child:ListTile(
                        leading:const Image(image:AssetImage('assets/icons/loan_taken_icon.png')),
                        title: Text('Loans Taken',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
                          color:Colors.black,)),
                        subtitle: Text('Total Amount: 0',style:
                        GoogleFonts.montserrat()),
                      ),
                    ),
                    Card(
                      shape:const BeveledRectangleBorder(),
                    child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/loan_given_icon.png')),
                    title: Text('Loans Given',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
                    color:Colors.black,)),
                    subtitle: Text('Total Amount: 0',style:
                    GoogleFonts.montserrat()),),
                    )
                  ],
                ),
                const Divider(color:Colors.black,),
                Text('Recent Transactions',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:<Widget>[
                    DropdownButton<String>(
                      value:dropdownValue,
                      icon:const ImageIcon(AssetImage('assets/icons/drop_down_icon.png'),color:Colors.black),
                      style: GoogleFonts.montserrat(),
                      onChanged: (String? newValue){},
                      items:<DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value:'week',
                          child:Text('This Week',style:GoogleFonts.montserrat(color:Colors.black)),
                        ),
                        DropdownMenuItem<String>(
                          value:'month',
                          child:Text('This Month',style:GoogleFonts.montserrat(color:Colors.black)),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style:ElevatedButton.styleFrom(shape: const BeveledRectangleBorder()),
                      icon:const ImageIcon(AssetImage('assets/icons/view_all_icon.png'),color:Colors.black),
                      label: Text('View All Transactions',style:GoogleFonts.montserrat(color:Colors.black)),
                      onPressed: (){Navigator.pushNamed(context,'/transactions_history_page');},
                    ),
                  ],
                ),
                Text(placeholderText,style:GoogleFonts.montserrat(color:Colors.black)),
              ],
            ),
          ),
        );
    }
    loopLimiter=0;
    return Container(
      decoration:const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.bottomLeft,
          end:Alignment.topRight,
          colors:<Color>[Colors.greenAccent,Colors.white],
        ),
      ),
      child:Scaffold(
        backgroundColor:Colors.transparent,
        body: Column(
          children: <Widget>[
            Column(
              children:<Widget>[
                Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/loan_taken_icon.png')),
                    title: Text('Loans Taken',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
                      color:Colors.black,)),
                    subtitle: Text('Total Amount: $loansTaken,\n Tap To View Loans Taken',style:
                    GoogleFonts.montserrat()),
                    trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                    onTap:(){
                      Navigator.pushNamed(context,'/loans_taken_page');
                    }
                  ),
                ),
                Card(
                    shape:const BeveledRectangleBorder(),
                    child:ListTile(
                      leading:const Image(image:AssetImage('assets/icons/loan_given_icon.png')),
                      title: Text('Loans Given',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
                        color:Colors.black,)),
                      subtitle: Text('Total Amount: $loansGiven,\n Tap To View Loans Given',style:
                      GoogleFonts.montserrat()),
                     trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                      onTap:(){
                        Navigator.pushNamed(context,'/loans_given_page');
                      }
                    )
                )
              ],
            ),
            const Divider(color:Colors.black,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment:Alignment.center,
                    child: Text('Recent Transactions',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,))),
                Align(alignment:Alignment.centerRight,child: IconButton(
                  icon:const ImageIcon(AssetImage('assets/icons/reload_icon.png')),
                  onPressed: ()async{
                    dropdownValue='week';
                    initializeTransactionList();
                    setState(() {
                    });
                  },),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                DropdownButton<String>(
                  value:dropdownValue,
                  icon:const ImageIcon(AssetImage('assets/icons/drop_down_icon.png'),color:Colors.black),
                  style: GoogleFonts.montserrat(),
                  onChanged: (String? newValue){
                    setState((){dropdownValue=newValue;
                      initializeTransactionList();
                    });
                  },
                  items:<DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value:'week',
                      child:Text('This Week',style:GoogleFonts.montserrat(color:Colors.black)),
                    ),
                    DropdownMenuItem<String>(
                      value:'month',
                      child:Text('This Month',style:GoogleFonts.montserrat(color:Colors.black)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style:ElevatedButton.styleFrom(shape:const BeveledRectangleBorder()),
                  icon:const ImageIcon(AssetImage('assets/icons/view_all_icon.png'),color:Colors.black),
                  label: Text('Transactions History',style:GoogleFonts.montserrat(color:Colors.black)),
                  onPressed: (){Navigator.pushNamed(context,'/transactions_history_page');},
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                child:ListView.builder(
                    itemCount: transactionTableCount,
                    itemBuilder: (context,index){
                      if(transactionList[index].tType=='Income'){
                      return Card(
                        shape:const BeveledRectangleBorder(),
                        child: ListTile(
                          leading: const Image(image:AssetImage('assets/icons/income_list_view_icon.png')),
                          title:Text(transactionList[index].amount!,style:GoogleFonts.montserrat(
                            fontWeight:FontWeight.bold,color:Colors.black,
                          )),
                          subtitle: Text('From: ${transactionList[index].sord}',style:GoogleFonts.montserrat(
                          )),
                          trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                          onTap:() {
                            Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                            {'id':(transactionList[index].id).toString(),'tType':(transactionList[index].tType).toString(),
                            'tSubType':(transactionList[index].tSubType).toString(),'fType':(transactionList[index].fType).toString(),
                            'amount':(transactionList[index].amount).toString(),'dTime':(transactionList[index].dTime).toString(),
                            'sord':(transactionList[index].sord).toString(),'desc':(transactionList[index].desc).toString()},);
                          },
                        ),
                      );}
                      else{
                      return Card(
                        shape:const BeveledRectangleBorder(),
                        child: ListTile(
                        leading: const Image(image:AssetImage('assets/icons/expense_list_view_icon.png')),
                        title:Text(transactionList[index].amount!,style:GoogleFonts.montserrat(
                        fontWeight:FontWeight.bold,color:Colors.black,
                        )),
                        subtitle: Text('To: ${transactionList[index].sord}',style:GoogleFonts.montserrat(
                        )),
                          trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                          onTap:() {
                            Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                            {'id':(transactionList[index].id).toString(),'tType':(transactionList[index].tType).toString(),
                              'tSubType':(transactionList[index].tSubType).toString(),'fType':(transactionList[index].fType).toString(),
                              'amount':(transactionList[index].amount).toString(),'dTime':(transactionList[index].dTime).toString(),
                              'sord':(transactionList[index].sord).toString(),'desc':(transactionList[index].desc).toString()});
                          },
                        ),
                        );}
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
