import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class LoansGivenPage extends StatefulWidget{
  const LoansGivenPage({super.key});
  @override
  State<LoansGivenPage> createState()=>_LoansGivenPageState();
}
class _LoansGivenPageState extends State<LoansGivenPage>{
  _LoansGivenPageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<TransactionModel> loanGivenReturnsList=[];
  List<TransactionModel> loanReturnsSumList=[];
  List<TransactionModel> loanGivenSumList=[];
  int loanGivenReturnsListCount=0;
  int loopLimiter=0;
  String placeHolderText='Loading Transactions Please Wait...';
  void initializeTransaction()async{
    loanReturnsSumList=await databaseHelper.getLoansReturnsTransactionList();
    loanGivenSumList=await databaseHelper.getLoansGivenTransactionList();
    if((double.parse(loanReturnsSumList[0].sAmount as String)-double.parse(loanGivenSumList[0].sAmount as String))!=0) {
      loanGivenReturnsList=await databaseHelper.getLoansGivenReturnsTransactionList();
      loanGivenReturnsListCount=loanGivenReturnsList.length;
    }
    else{
      placeHolderText='All Taken Loans Have Been Returned To You';
    }
    setState((){});
  }
  @override
  Widget build(BuildContext context){
    if(loanGivenReturnsList.isEmpty){
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
                'Loans Given And Returns', style: GoogleFonts.montserrat(
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
                'Loans Given And Returns', style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 19)),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount:loanGivenReturnsListCount,
            itemBuilder: (context,index){
              if(loanGivenReturnsList[index].tType=='Income'){
                return Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                      leading:const Image(image:AssetImage('assets/icons/income_list_view_icon.png')),
                      title:Text(loanGivenReturnsList[index].amount!,style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.bold,
                      )),
                      subtitle:Text('From: ${loanGivenReturnsList[index].sord}',style:GoogleFonts.montserrat()),
                      trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                      onTap:(){
                        Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                        {'id':(loanGivenReturnsList[index].id).toString(),'tType':(loanGivenReturnsList[index].tType).toString(),
                          'tSubType':(loanGivenReturnsList[index].tSubType).toString(),'fType':(loanGivenReturnsList[index].fType).toString(),
                          'amount':(loanGivenReturnsList[index].amount).toString(),'dTime':(loanGivenReturnsList[index].dTime).toString(),
                          'sord':(loanGivenReturnsList[index].sord).toString(),'desc':(loanGivenReturnsList[index].desc).toString()},);
                        },
                    ),
                  );
                }
              else{
                return Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                      leading:const Image(image:AssetImage('assets/icons/expense_list_view_icon.png')),
                      title:Text(loanGivenReturnsList[index].amount!,style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.bold,
                      )),
                      subtitle:Text('To: ${loanGivenReturnsList[index].sord}',style:GoogleFonts.montserrat()),
                      trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                      onTap:(){
                        Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                        {'id':(loanGivenReturnsList[index].id).toString(),'tType':(loanGivenReturnsList[index].tType).toString(),
                          'tSubType':(loanGivenReturnsList[index].tSubType).toString(),'fType':(loanGivenReturnsList[index].fType).toString(),
                          'amount':(loanGivenReturnsList[index].amount).toString(),'dTime':(loanGivenReturnsList[index].dTime).toString(),
                          'sord':(loanGivenReturnsList[index].sord).toString(),'desc':(loanGivenReturnsList[index].desc).toString()},);
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