import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
class IndividualTransactionPage extends StatefulWidget{
  const IndividualTransactionPage({super.key});
  @override
  State<IndividualTransactionPage> createState()=>_IndividualTransactionPageState();
}
class _IndividualTransactionPageState extends State<IndividualTransactionPage>{
  _IndividualTransactionPageState();
  Map<String,String> data={};
  DatabaseHelper databaseHelper=DatabaseHelper();
  Future<String?> confirmDelete(){
    return showDialog(
      context: context,
      builder:(context)=>AlertDialog(
        backgroundColor: Colors.black,
        title:Align(
            alignment:Alignment.center,
            child: Text('Confirm Delete?',style:GoogleFonts.montserrat(
                color:Colors.white,fontWeight:FontWeight.bold))),
        content: Text('Are you sure you want to delete transaction? This action is irreversible',
        style:GoogleFonts.montserrat(color:Colors.white,fontWeight:FontWeight.w400)),
        actions: [
          TextButton(
              onPressed:(){Navigator.of(context).pop('no');},
              child:Text('CANCEL',style:GoogleFonts.montserrat(color:Colors.green,))),
          TextButton(
              onPressed:(){Navigator.of(context).pop('yes');},
              child:Text('SUBMIT',style:GoogleFonts.montserrat(color:Colors.green,))),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    data=ModalRoute.of(context)?.settings.arguments as Map<String,String>;
    String sordPlaceHolder='';
    if(data['tType']=='Income'){
      sordPlaceHolder='Source';
    }
    else{
      sordPlaceHolder='Reason';
    }
    return Container(
      decoration: const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.bottomLeft,
          end:Alignment.topRight,
          colors: [Colors.greenAccent,Colors.white],
        ),
      ),
      child:Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(
          backgroundColor: Colors.green,
          title: Text('Transaction Details',style:GoogleFonts.montserrat(color:Colors.black,
              fontWeight:FontWeight.bold)),
          centerTitle: true,
        ),
        body:Container(
          padding:const EdgeInsets.fromLTRB(10,10,0,0),
          width:400,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: <Widget> [
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('ID: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['id']}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),
                      ),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Type: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Text('${data['tType']}',style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Sub Class: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['tSubType']}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),
                      ),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Funds Type: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Text('${data['fType']}',style:GoogleFonts.montserrat(
                        color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Amount: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['amount']}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),
                      ),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Date And Time: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['dTime']?.substring(0,19)}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:17,)),
                      ),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('$sordPlaceHolder: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['sord']}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),
                      ),]
                ),
              ),
              Align(
                alignment:Alignment.centerLeft,
                child: Row(
                    children:[Text('Description: ',style:GoogleFonts.montserrat(
                      color:Colors.black,fontWeight:FontWeight.bold,fontSize:20,)),
                      Flexible(
                        child: Text('${data['desc']}',style:GoogleFonts.montserrat(
                          color:Colors.black,fontWeight:FontWeight.w400,fontSize:18,)),
                      ),]
                ),
              ),
              const SizedBox(height:20),
              Align(
                alignment:Alignment.center,
                child:Container(
                  decoration:const BoxDecoration(
                    color: Colors.green,
                    border:Border(
                        top:BorderSide(color:Colors.black),
                        bottom: BorderSide(color:Colors.black),
                        left:BorderSide(color:Colors.black),
                        right:BorderSide(color:Colors.black)),
                  ),
                  child: TextButton.icon(
                    icon:const ImageIcon(AssetImage('assets/icons/bin_icon.png'),color:Colors.black),
                    label:Text('Delete Transaction',style:GoogleFonts.montserrat(color:Colors.black)),
                    onPressed:()async{
                      String? choice=await confirmDelete();
                      if(choice=='yes'){
                        await databaseHelper.deleteTransactionTable(int.parse(data['id'] as String));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Transaction Deleted Please Go Back And Refresh',
                                style:GoogleFonts.montserrat(color:Colors.white)),
                            backgroundColor: Colors.red,
                          )
                        );
                        Navigator.pop(context);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('No Deletion Took Place',
                                  style:GoogleFonts.montserrat(color:Colors.white)),
                              backgroundColor: Colors.green,
                            )
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
