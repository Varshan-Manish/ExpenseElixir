import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class TransactionsHistory extends StatefulWidget{
  const TransactionsHistory({super.key});
  @override
  State<TransactionsHistory> createState()=>_TransactionsHistoryState();
}
class _TransactionsHistoryState extends State<TransactionsHistory>{
  _TransactionsHistoryState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<TransactionModel>transactionList=[];
  int transactionTableCount=0;
  String? dropdownValue='all';
  String placeHolderText='Loading Transactions Please Wait...';
  int showCustomResults=0;
  int loopLimiter=0;
  String fromDate=DateTime.now().toString();
  String toDate=(DateTime.now().subtract(const Duration(days:7))).toString();
  Future<void> selectFromDate()async{
    DateTime? picked=await showDatePicker(
    context:context,
    initialDate: DateTime.now(),
    firstDate:DateTime(2024),
    lastDate:DateTime(2030),
    );
    fromDate=picked.toString();}
  Future<void> selectToDate()async{
    DateTime? picked=await showDatePicker(
      context:context,
      initialDate: DateTime.now(),
      firstDate:DateTime(2024),
      lastDate:DateTime(2030),
    );
      toDate=picked.toString();}
  void initializeTransactions()async{
    if(dropdownValue=='all'){
      transactionList=await databaseHelper.getTransactionList();
      transactionTableCount = transactionList.length;
    }
    else if(dropdownValue=='week'){
      transactionList=await databaseHelper.getWeeklyTransactionList();
      transactionTableCount = transactionList.length;
    }
    else if(dropdownValue=='month'){
      transactionList=await databaseHelper.getMonthlyTransactionList();
      transactionTableCount = transactionList.length;
    }
    else if(dropdownValue=='custom' && showCustomResults==1){
      transactionList=await databaseHelper.getCustomTransactionList(fromDate,toDate);
      transactionTableCount=transactionList.length;
    }
    setState((){placeHolderText='No Transactions To Show';});
  }
  @override
  Widget build(BuildContext context){
   if(transactionList.isEmpty){
     if(loopLimiter<50) {
       loopLimiter++;
       initializeTransactions();
     }
     if (dropdownValue == 'custom' && showCustomResults == 0) {
       return Container(
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.bottomLeft,
             end: Alignment.bottomRight,
             colors: [Colors.greenAccent, Colors.white],
           ),
         ),
         child: Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.green,
             title: Text('Transaction History',
                 style: GoogleFonts.montserrat(
                     fontSize: 25, fontWeight: FontWeight.w500)),
             centerTitle: true,
           ),
           body: Column(
             children: <Widget>[
               Align(alignment: Alignment.center,
                   child: Text(
                       'Choose Custom Dates', style: GoogleFonts.montserrat(
                       color: Colors.black, fontWeight: FontWeight.bold))),
               const SizedBox(height: 25.0),
               Expanded(
                 child: SizedBox(
                   height: 200,
                   child: ListView(
                     children: <Widget>[
                       Card(
                         shape: const BeveledRectangleBorder(),
                         child: ListTile(
                           leading: const Image(image: AssetImage(
                               'assets/icons/calendar_icon.png')),
                           title: Text('From ${fromDate.substring(0, 11)}',
                               style: GoogleFonts.montserrat(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black)),
                           subtitle: Text('Tap To Change Date',
                               style: GoogleFonts.montserrat()),
                           onTap: ()async{
                             await selectFromDate();
                             setState(() {});
                           },
                         ),
                       ),
                       Card(
                         shape: const BeveledRectangleBorder(),
                         child: ListTile(
                           leading: const Image(image: AssetImage(
                               'assets/icons/calendar_icon.png')),
                           title: Text('To ${toDate.substring(0, 11)}',
                               style: GoogleFonts.montserrat(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black)),
                           subtitle: Text('Tap To Change Date',
                               style: GoogleFonts.montserrat()),
                           onTap: ()async{
                             await selectToDate();
                             setState(() {});
                           },
                         ),
                       ),
                       TextButton.icon(
                           icon: const Icon(Icons.check_circle),
                           label: Text('Done', style: GoogleFonts.montserrat()),
                           onPressed: () =>
                               setState(() {
                                 dropdownValue = 'custom';
                                 showCustomResults = 1;
                                 initializeTransactions();
                               }))
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       );
     }
     return Container(
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           begin: Alignment.bottomLeft,
           end: Alignment.bottomRight,
           colors: [Colors.greenAccent, Colors.white],
         ),
       ),
       child: Scaffold(
         backgroundColor: Colors.transparent,
       appBar: AppBar(
       backgroundColor: Colors.green,
       title: Text('Transaction History',
           style: GoogleFonts.montserrat(
               fontSize: 25, fontWeight: FontWeight.w500)),
       centerTitle: true,
     ),
    body: Column(children: <Widget>[DropdownButton<String>(
    icon: const ImageIcon(
        AssetImage('assets/icons/drop_down_icon.png')),
       value: dropdownValue,
       items: <DropdownMenuItem<String>>[
         DropdownMenuItem(
           value: 'all',
           child: Text('All',
               style: GoogleFonts.montserrat(color: Colors.black)),
         ),
         DropdownMenuItem(
           value: 'week',
           child: Text('This Week',
               style: GoogleFonts.montserrat(color: Colors.black)),
         ),
         DropdownMenuItem(
           value: 'month',
           child: Text('This Month',
               style: GoogleFonts.montserrat(color: Colors.black)),
         ),
         DropdownMenuItem(
           value: 'custom',
           child: Text('Custom',
               style: GoogleFonts.montserrat(color: Colors.black)),
         ),
       ],
       onChanged: (newValue) =>
           setState(() {
             dropdownValue = newValue;
             showCustomResults=0;
             initializeTransactions();
           }),
     ),Center(child:Text(placeHolderText,style:GoogleFonts.montserrat(color:Colors.black))),
          ],
        ),
      ),
     );
   }
   else{
     if (dropdownValue == 'custom' && showCustomResults == 0) {
       return Container(
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.bottomLeft,
             end: Alignment.bottomRight,
             colors: [Colors.greenAccent, Colors.white],
           ),
         ),
         child: Scaffold(
           appBar: AppBar(
             backgroundColor: Colors.green,
             title: Text('Transaction History',
                 style: GoogleFonts.montserrat(
                     fontSize: 25, fontWeight: FontWeight.w500)),
             centerTitle: true,
           ),
           body: Column(
             children: <Widget>[
               Align(alignment: Alignment.center,
                   child: Text(
                       'Choose Custom Dates', style: GoogleFonts.montserrat(
                       color: Colors.black, fontWeight: FontWeight.bold))),
               const SizedBox(height: 25.0),
               Expanded(
                 child: SizedBox(
                   height: 200,
                   child: ListView(
                     children: <Widget>[
                       Card(
                         shape: const BeveledRectangleBorder(),
                         child: ListTile(
                           leading: const Image(image: AssetImage(
                               'assets/icons/calendar_icon.png')),
                           title: Text('From ${fromDate.substring(0, 11)}',
                               style: GoogleFonts.montserrat(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black)),
                           subtitle: Text('Tap To Change Date',
                               style: GoogleFonts.montserrat()),
                           onTap: ()async{
                             await selectFromDate();
                             setState(() {});
                           },
                         ),
                       ),
                       Card(
                         shape: const BeveledRectangleBorder(),
                         child: ListTile(
                           leading: const Image(image: AssetImage(
                               'assets/icons/calendar_icon.png')),
                           title: Text('To ${toDate.substring(0, 11)}',
                               style: GoogleFonts.montserrat(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black)),
                           subtitle: Text('Tap To Change Date',
                               style: GoogleFonts.montserrat()),
                           onTap: ()async{
                             await selectToDate();
                             setState(() {});
                           },
                         ),
                       ),
                       TextButton.icon(
                           icon: const Icon(Icons.check_circle),
                           label: Text('Done', style: GoogleFonts.montserrat()),
                           onPressed: () =>
                               setState(() {
                                 dropdownValue = 'custom';
                                 showCustomResults = 1;
                                 initializeTransactions();
                               }))
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       );
     }
     else {
       loopLimiter=0;
       return Container(
         decoration: const BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.bottomLeft,
             end: Alignment.bottomRight,
             colors: [Colors.greenAccent, Colors.white],
           ),
         ),
         child: Scaffold(
           backgroundColor: Colors.transparent,
           appBar: AppBar(
             backgroundColor: Colors.green,
             title: Text('Transaction History',
                 style: GoogleFonts.montserrat(
                     fontSize: 25, fontWeight: FontWeight.w500)),
             centerTitle: true,
           ),
           body: Center(
             child: Column(
               children: <Widget>[
                 DropdownButton<String>(
                   icon: const ImageIcon(
                       AssetImage('assets/icons/drop_down_icon.png')),
                   value: dropdownValue,
                   items: <DropdownMenuItem<String>>[
                     DropdownMenuItem(
                       value: 'all',
                       child: Text('All',
                           style: GoogleFonts.montserrat(color: Colors.black)),
                     ),
                     DropdownMenuItem(
                       value: 'week',
                       child: Text('This Week',
                           style: GoogleFonts.montserrat(color: Colors.black)),
                     ),
                     DropdownMenuItem(
                       value: 'month',
                       child: Text('This Month',
                           style: GoogleFonts.montserrat(color: Colors.black)),
                     ),
                     DropdownMenuItem(
                       value: 'custom',
                       child: Text('Custom',
                           style: GoogleFonts.montserrat(color: Colors.black)),
                     ),
                   ],
                   onChanged: (newValue) =>
                       setState(() {
                         dropdownValue = newValue;
                         showCustomResults=0;
                         initializeTransactions();
                       }),
                 ),
                 Expanded(
                   child:SizedBox(
                     height:200,
                     child: ListView.builder(
                       itemCount:transactionTableCount,
                       itemBuilder: (context,index){
                         if(transactionList[index].tType=='Income'){
                           return Card(
                             shape:const BeveledRectangleBorder(),
                             child:ListTile(
                               leading:const Image(image:AssetImage('assets/icons/income_list_view_icon.png')),
                               title:Text(transactionList[index].amount!,
                                   style:GoogleFonts.montserrat(
                                       fontWeight:FontWeight.bold,color:Colors.black)),
                               subtitle:Text('From: ${transactionList[index].sord}\nFunds Type: ${transactionList[index].fType}',style:
                               GoogleFonts.montserrat()),
                               trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                               onTap:(){
                                 Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                                 {'id':(transactionList[index].id).toString(),'tType':(transactionList[index].tType).toString(),
                                   'tSubType':(transactionList[index].tSubType).toString(),'fType':(transactionList[index].fType).toString(),
                                   'amount':(transactionList[index].amount).toString(),'dTime':(transactionList[index].dTime).toString(),
                                   'sord':(transactionList[index].sord).toString(),'desc':(transactionList[index].desc).toString()},);
                               }
                             ),
                           );
                         }
                         else{
                           return Card(
                             shape:const BeveledRectangleBorder(),
                             child:ListTile(
                               leading:const Image(image:AssetImage('assets/icons/expense_list_view_icon.png')),
                               title:Text(transactionList[index].amount!,
                                   style:GoogleFonts.montserrat(
                                       fontWeight:FontWeight.bold,color:Colors.black)),
                               subtitle:Text('To: ${transactionList[index].sord}\nFunds Type: ${transactionList[index].fType}',style:
                               GoogleFonts.montserrat()),
                               isThreeLine: true,
                               trailing:const ImageIcon(AssetImage('assets/icons/view_all_icon.png')),
                               onTap:(){
                                 Navigator.pushNamed(context,'/individual_transaction_page',arguments:
                                 {'id':(transactionList[index].id).toString(),'tType':(transactionList[index].tType).toString(),
                                   'tSubType':(transactionList[index].tSubType).toString(),'fType':(transactionList[index].fType).toString(),
                                   'amount':(transactionList[index].amount).toString(),'dTime':(transactionList[index].dTime).toString(),
                                   'sord':(transactionList[index].sord).toString(),'desc':(transactionList[index].desc).toString()},);
                               }
                             ),
                           );
                         }
                       },
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       );
     }
   }
  }
}