import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:csvwriter/csvwriter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_23/database/database_helper.dart';
import 'dart:io';
import '../database/transaction_model.dart';
class ApplicationSettings extends StatefulWidget{
  const ApplicationSettings({super.key});
  @override
  State<ApplicationSettings> createState()=>_ApplicationSettingsState();
}
class _ApplicationSettingsState extends State<ApplicationSettings>{
  _ApplicationSettingsState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.bottomRight,
          end:Alignment.topLeft,
          colors:<Color>[Colors.greenAccent,Colors.white],
        ),
      ),
      child: Scaffold(
        appBar:AppBar(title:Text('App Settings',style:
        GoogleFonts.montserrat(
          fontSize:30.0,
          fontWeight:FontWeight.w500,
          color:Colors.black,
            ),
          ),
          centerTitle:true,
          backgroundColor:Colors.green,
        ),
        body: Column(
          children: [
            Align(
              alignment:Alignment.center,
              child: Text(
                  'CSV File Export',
                  style:GoogleFonts.montserrat(color:Colors.black,
                      fontSize:20,fontWeight:FontWeight.w500)),
            ),
            const SizedBox(height:10),
            ElevatedButton(
              child:Text('Export To CSV',style:GoogleFonts.montserrat(color:Colors.black)),
              onPressed:()async{
                if(Platform.isAndroid){
                  List<TransactionModel> transactionModelList=[];
                  transactionModelList=await databaseHelper.getTransactionList();
                  Directory path=await getExternalStorageDirectory() as Directory;
                  String fileName='ExportedCSV${DateTime.now().toString().substring(1,10)}.csv';
                  String strPath='${path.path}$fileName';
                  File csvFile=File(strPath);
                  await csvFile.create();
                  var csvContent=CsvWriter.withHeaders(csvFile.openWrite(),[
                    'ID','Type','Subtype','Funds Type','Amount','From OR To','Date','Description'
                  ]);
                  try{
                    for(int i=0;i<transactionModelList.length;i++){
                      csvContent.writeData(data:{'ID':transactionModelList[i].id,
                        'Type':transactionModelList[i].tType,
                        'Subtype':transactionModelList[i].tSubType,
                        'Funds Type': transactionModelList[i].fType,
                        'Amount':transactionModelList[i].amount,
                        'From OR To': transactionModelList[i].sord,
                        'Date':transactionModelList[i].dTime,
                        'Description':transactionModelList[i].desc});
                    }
                  }finally{
                    csvContent.close();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('CSV File Uploaded to '
                          '/storage/emulated/0/Android/data/com.wave_microsystems.project_23/',
                      style:GoogleFonts.montserrat(color:Colors.white)),
                      backgroundColor: Colors.green,
                    ));
                  }
                }
                else if(Platform.isIOS){
                  List<TransactionModel> transactionModelList=[];
                  transactionModelList=await databaseHelper.getTransactionList();
                  Directory path=await getApplicationDocumentsDirectory();
                  String fileName='ExportedCSV${DateTime.now().toString().substring(1,10)}.csv';
                  String strPath='${path.path}$fileName';
                  File csvFile=File(strPath);
                  await csvFile.create();
                  var csvContent=CsvWriter.withHeaders(csvFile.openWrite(),[
                    'ID','Type','Subtype','Funds Type','Amount','From OR To','Date','Description'
                  ]);
                  try{
                    for(int i=0;i<transactionModelList.length;i++){
                      csvContent.writeData(data:{'ID':transactionModelList[i].id,
                        'Type':transactionModelList[i].tType,
                        'Subtype':transactionModelList[i].tSubType,
                        'Funds Type': transactionModelList[i].fType,
                        'Amount':transactionModelList[i].amount,
                        'From OR To': transactionModelList[i].sord,
                        'Date':transactionModelList[i].dTime,
                        'Description':transactionModelList[i].desc});
                    }
                  }finally{
                    csvContent.close();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('CSV File Uploaded to '
                          'Application Documents Directory',
                          style:GoogleFonts.montserrat(color:Colors.white)),
                      backgroundColor: Colors.green,
                    ));
                  }
                }
              },
            ),
            const Divider(color:Colors.green),
            Align(
              alignment:Alignment.center,
              child: Text(
                  'Clear Data',
                  style:GoogleFonts.montserrat(color:Colors.black,
                      fontSize:20,fontWeight:FontWeight.w500)),
            ),
            ElevatedButton(
              child:Text('Clear Application Data',style:GoogleFonts.montserrat(color:Colors.black)),
              onPressed:()async{
                await databaseHelper.truncateTransactionTable();
                await databaseHelper.truncateBudgetTable();
                await databaseHelper.truncateStatSettingsTable();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('All Data Deleted Successfully Please Restart Application',
                      style:GoogleFonts.montserrat(color:Colors.white)),
                  backgroundColor: Colors.red,
                ));
              }
            ),
            const Divider(color:Colors.green),
            Text('Notification Features Coming Soon',style:GoogleFonts.montserrat(color:Colors.black,
            fontWeight:FontWeight.w500))
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}