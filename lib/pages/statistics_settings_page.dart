import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/stat_settings_model.dart';
import 'package:project_23/database/database_helper.dart';
class StatisticsSettingsPage extends StatefulWidget{
  const StatisticsSettingsPage({super.key});
  @override
  State<StatisticsSettingsPage> createState() =>_StatisticsSettingsPageState();
}
class _StatisticsSettingsPageState extends State<StatisticsSettingsPage> {
  _StatisticsSettingsPageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<String>transactionTypeOptions=['Income','Expense'];
  List<String>transactionTimeOptions=['Weekly','Monthly','All',];
  List<StatSettingsModel>statSettingList=[];
  String? currentTypeOption;
  String? currentTimeOption;
  Future<void> initializeDB()async{
    statSettingList=await databaseHelper.getStatSettingsList();
    currentTypeOption=statSettingList[0].tQuery;
    currentTimeOption=statSettingList[0].tTime;
    setState(() {});
  }
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(statSettingList.isEmpty){
      initializeDB();
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
          body: Column(
            children:<Widget>[
              Align(
                alignment:Alignment.center,
                child: Text('Transaction Type Query Settings',style:GoogleFonts.montserrat(color:Colors.green,
                fontSize: 20,fontWeight: FontWeight.w500)),
              ),
              Align(
                alignment:Alignment.topLeft,
                child:RadioListTile<String>(
                  value:'Income',
                  groupValue: currentTypeOption,
                  title: Text('Income Statistics',style:GoogleFonts.montserrat()),
                  onChanged:(value)async{
                    await databaseHelper.updateQueryStatSettingsTable('Income');
                    setState((){
                      currentTypeOption=value as String;
                    });
                  },
                ),
              ),
              Align(
                alignment:Alignment.topLeft,
                child:RadioListTile<String>(
                  value:'Expense',
                  groupValue: currentTypeOption,
                  title: Text('Expense Statistics',style:GoogleFonts.montserrat()),
                  onChanged:(value)async{
                    await databaseHelper.updateQueryStatSettingsTable('Expense');
                    setState((){
                      currentTypeOption=value as String;
                    });
                  },
                ),
              ),
              const Divider(color:Colors.green),
              Align(
                alignment:Alignment.center,
                child:Text('Transaction Time Query Settings',style:GoogleFonts.montserrat(
                  color:Colors.green,fontSize:20,fontWeight:FontWeight.w500,
                ))
              ),
              Align(
                alignment:Alignment.topLeft,
                child:RadioListTile<String>(
                  value:'Weekly',
                  groupValue: currentTimeOption,
                  title: Text('Weekly Statistics',style:GoogleFonts.montserrat()),
                  onChanged:(value)async{
                    await databaseHelper.updateTimeStatSettingsTable('Weekly');
                    setState((){
                      currentTimeOption=value as String;
                    });
                  },
                ),
              ),
              Align(
                alignment:Alignment.topLeft,
                child:RadioListTile<String>(
                  value:'Monthly',
                  groupValue: currentTimeOption,
                  title: Text('Monthly Statistics',style:GoogleFonts.montserrat()),
                  onChanged:(value)async{
                    await databaseHelper.updateTimeStatSettingsTable('Monthly');
                    setState((){
                      currentTimeOption=value as String;
                    });
                  },
                ),
              ),
              Align(
                alignment:Alignment.topLeft,
                child:RadioListTile<String>(
                  value:'All',
                  groupValue: currentTimeOption,
                  title: Text('All Statistics',style:GoogleFonts.montserrat()),
                  onChanged:(value)async{
                    await databaseHelper.updateTimeStatSettingsTable('All');
                    setState((){
                      currentTimeOption=value as String;
                    });
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}