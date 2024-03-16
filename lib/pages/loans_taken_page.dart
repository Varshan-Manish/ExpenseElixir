import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class LoansTakenPage extends StatefulWidget{
  const LoansTakenPage({super.key});
  @override
  State<LoansTakenPage> createState()=>_LoansTakenPageState();
}
class _LoansTakenPageState extends State<LoansTakenPage>{
  _LoansTakenPageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<TransactionModel> loanTakenReturnedList=[];
  List<TransactionModel> loanTakenSumList=[];
  List<TransactionModel> loanReturnedSumList=[];
  int loanTakenReturnedListCount=0;
  int loopLimiter=0;
  String placeHolderText='Loading Transactions Please Wait...';
  void initializeTransaction()async{
    loanTakenSumList=await databaseHelper.getLoansTakenTransactionList();
    loanReturnedSumList=await databaseHelper.getLoansReturnedTransactionList();
    if((double.parse(loanTakenSumList[0].sAmount as String)-double.parse(loanReturnedSumList[0].sAmount as String))!=0) {
      loanTakenReturnedList=await databaseHelper.getLoansTakenReturnedTransactionList();
      loanTakenReturnedListCount=loanTakenReturnedList.length;
    }
    else{
      placeHolderText='All Taken Loans Has Been Returned';
    }
    setState((){});
  }
  @override
  Widget build(BuildContext context){
    if(loanTakenReturnedList.isEmpty){
      if(loopLimiter<50) {
        loopLimiter++;
        initializeTransaction();
      }
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [Colors.greenAccent, Colors.white],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: Text(
                  'Loans Taken And Returned', style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 19)),
              centerTitle: true,
            ),
            body: Center(child: Text(placeHolderText,
                style: GoogleFonts.montserrat(color: Colors.black))),
          ),
        );
    }
    else {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.greenAccent, Colors.white],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(
                'Loans Taken And Returned', style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 19)),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount:loanTakenReturnedListCount,
            itemBuilder: (context,index){
              if(loanTakenReturnedList[index].tType=='Income'){
                return Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                      leading:const Image(image:AssetImage('assets/icons/income_list_view_icon.png')),
                      title:Text(loanTakenReturnedList[index].amount!,style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.bold,
                      )),
                      subtitle:Text('From: ${loanTakenReturnedList[index].sord}',style:GoogleFonts.montserrat()),
                      trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                      onTap:(){
                        Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                        {'id':(loanTakenReturnedList[index].id).toString(),'tType':(loanTakenReturnedList[index].tType).toString(),
                          'tSubType':(loanTakenReturnedList[index].tSubType).toString(),'fType':(loanTakenReturnedList[index].fType).toString(),
                          'amount':(loanTakenReturnedList[index].amount).toString(),'dTime':(loanTakenReturnedList[index].dTime).toString(),
                          'sord':(loanTakenReturnedList[index].sord).toString(),'desc':(loanTakenReturnedList[index].desc).toString()},);
                      },
                  ),
                );
              }
              else{
                return Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                      leading:const Image(image:AssetImage('assets/icons/expense_list_view_icon.png')),
                      title:Text(loanTakenReturnedList[index].amount!,style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.bold,
                      )),
                      subtitle:Text('To: ${loanTakenReturnedList[index].sord}',style:GoogleFonts.montserrat()),
                      trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                      onTap:(){
                        Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                        {'id':(loanTakenReturnedList[index].id).toString(),'tType':(loanTakenReturnedList[index].tType).toString(),
                          'tSubType':(loanTakenReturnedList[index].tSubType).toString(),'fType':(loanTakenReturnedList[index].fType).toString(),
                          'amount':(loanTakenReturnedList[index].amount).toString(),'dTime':(loanTakenReturnedList[index].dTime).toString(),
                          'sord':(loanTakenReturnedList[index].sord).toString(),'desc':(loanTakenReturnedList[index].desc).toString()},);
                      },
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }
}