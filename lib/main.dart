//00110010 00110010 01001101 01001001 01000011 00110000 00110001 00110000 00110001
import 'package:flutter/material.dart';
import 'package:project_23/pages/about_application_page.dart';
import 'package:project_23/pages/application_settings_page.dart';
import 'package:project_23/pages/balance_sheet_page.dart';
import 'package:project_23/pages/loading_page.dart';
import 'package:flutter/services.dart';
import 'package:project_23/pages/statistics_page.dart';
import 'package:project_23/pages/transactions_history_page.dart';
import 'package:project_23/primary.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExpenseTracker());
}
class ExpenseTracker extends StatefulWidget{
  const ExpenseTracker({super.key});
  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}
class _ExpenseTrackerState extends State<ExpenseTracker> {
  _ExpenseTrackerState();
  @override
  Widget build(BuildContext context){
    (){SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent));}();
    return MaterialApp(
      routes:{
        '/':(context)=>const LoadingPage(),
        '/expense_tracker':(context)=>const ExpenseTracker(),
        '/primary_page':(context)=>const Primary(),
        '/app_information_page':(context)=>const AboutApplication(),
        '/app_settings_page':(context)=>const ApplicationSettings(),
        '/income_page':(context)=>const BalanceSheetPage(index:0),
        '/balance_sheet_funds_flow_page':(context)=>const BalanceSheetPage(),
        '/expense_page':(context)=>const BalanceSheetPage(index:2),
        '/stats_settings_page':(context)=>const StatisticsPage(index:0),
        '/statistics_pie_page':(context)=>const StatisticsPage(),
        '/statistics_graph_page':(context)=>const StatisticsPage(index:2),
        '/transaction_history_page':(context)=>const TransactionsHistory(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}