import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/pages/income_page.dart';
import 'package:project_23/pages/expense_page.dart';
import 'package:project_23/pages/balance_sheet_funds_flow_page.dart';
class BalanceSheetPage extends StatefulWidget{
  final int index;
  const BalanceSheetPage({super.key,this.index=1});
  @override
  State<BalanceSheetPage> createState() =>_BalanceSheetPageState(index:index);
}
class _BalanceSheetPageState extends State<BalanceSheetPage>{
  int index=0;
  _BalanceSheetPageState({this.index=1});
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex:index,
      length:3,
      child:Scaffold(
        backgroundColor:Colors.transparent,
        appBar:AppBar(
          title:Text('Balance Sheet',style:GoogleFonts.montserrat(
            fontSize:30.0,
            fontWeight:FontWeight.w500,)
            ),
          backgroundColor:Colors.green,
          centerTitle:true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs:<Tab>[
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/income_icon.png')),
                text:'Income',
                ),
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/balance_sheet_page_icon.png')),
                text:'Funds Flow'
                ),
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/expense_icon.png')),
                text:'Expense'
                ),
              ],
            ),
          ),
        body:const TabBarView(
          children: <Widget>[
            IncomePage(),BalanceSheetFundsFlowPage(),ExpensePage()
            ]
          ),
        ),
      );
  }
}