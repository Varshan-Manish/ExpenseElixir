import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class ExpensePage extends StatefulWidget{
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() =>_ExpensePageState();
}
class _ExpensePageState extends State<ExpensePage> {
  _ExpensePageState();
  DatabaseHelper databaseHelper=DatabaseHelper();
  int formExitFlag=0;
  TextEditingController expenseAmountController=TextEditingController();
  TextEditingController expenseReasonController=TextEditingController();
  TextEditingController expenseDescriptionController=TextEditingController();
  SnackBar snackBar(Color colors,String text){
    return SnackBar(
      content:Text(text,style:GoogleFonts.montserrat(color:Colors.white)),
      backgroundColor:colors,
    );
  }
  void expenseDBInsert(String? encodedMap){
    try {
      if (encodedMap != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.green,
            'Expense Added Successfully'));
        final Map<String,dynamic>decodedMap=jsonDecode(encodedMap);
        TransactionModel transaction=TransactionModel.fromMap(decodedMap);
        databaseHelper.insertTransactionTable(transaction);
      }
      else if (encodedMap == null && formExitFlag == 1) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.red,
            'Invalid Entry'));
      }
      else if (encodedMap == null && formExitFlag == 2) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.red,
            'Cancelled Operation'));
      }
    }catch(e){null;}
    finally {
      expenseReasonController.clear();
      expenseAmountController.clear();
      expenseDescriptionController.clear();
      formExitFlag = 0;
    }
  }
  Future<String?>expenseDialog(String header,String expenseSubType){
    List<String>radioOptions=['Cash','Electronic'];
    String selectedRadioOption=radioOptions[0];
    return showDialog(
      barrierDismissible: true,
      context:context,
    builder:(context){
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: AlertDialog(
          title: Align(
            alignment:Alignment.center,
            child: Text(header,style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
            color:Colors.white,),),
          ),
          backgroundColor: Colors.black,
          content:Column(
            children:<Widget>[
              TextField(decoration:const InputDecoration(hintText:'*Expense Amount',fillColor:Colors.white,
                  filled:true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green,)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green))),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    LengthLimitingTextInputFormatter(8)],
                cursorColor:Colors.green,
                autofocus:true,
                keyboardType:TextInputType.number,
                controller:expenseAmountController),
              const SizedBox(height:5.0),
              TextField(decoration:const InputDecoration(hintText:'Receiver',fillColor:Colors.white,
                  filled:true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green,)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green))),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                  LengthLimitingTextInputFormatter(20)],
                  cursorColor:Colors.green,
                  autofocus:true,
                  keyboardType:TextInputType.text,
                  controller:expenseReasonController),
              const SizedBox(height:5.0),
              TextField(decoration:const InputDecoration(hintText:'Description',fillColor:Colors.white,
                  filled:true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green,)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green))),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                  LengthLimitingTextInputFormatter(40)],
                  cursorColor:Colors.green,
                  autofocus:true,
                  keyboardType:TextInputType.text,
                  controller:expenseDescriptionController),
              const SizedBox(height:5.0),
              Text('Expense Type',style:GoogleFonts.montserrat(color:Colors.white)),
              const Divider(thickness:2.5,color:Colors.white),
              const SizedBox(height:5.0),
              StatefulBuilder(
                builder:(context,setState){
                  return Column(
                    children:[
                      RadioListTile(
                        value:'Cash',groupValue:selectedRadioOption,
                        onChanged:(value){
                          setState(()=>selectedRadioOption=value as String);
                        },
                        title:Text('Cash',style:GoogleFonts.montserrat(color:Colors.white)),
                        autofocus: true,
                        activeColor: Colors.green,
                      ),
                      RadioListTile(
                        value:'Electronic',groupValue:selectedRadioOption,
                        onChanged:(value){
                          setState(()=>selectedRadioOption=value as String);
                        },
                        title:Text('Electronic',style:GoogleFonts.montserrat(color:Colors.white)),
                        autofocus: true,
                        activeColor: Colors.green,
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
          actions:[TextButton(
            child:Text('CANCEL',style:GoogleFonts.montserrat(color:Colors.green)),
            onPressed: (){
              Navigator.of(context).pop(null);
              formExitFlag=2;
          }
          ),
            TextButton(child:Text('SUBMIT',style:GoogleFonts.montserrat(color:Colors.green)),
            onPressed:(){
              formExitFlag=1;
              int snackBarFlag=0;
              if(expenseAmountController.text==''){snackBarFlag=1;}
              Map<String,dynamic> map={
                'tType':'Expense','tSubType':expenseSubType,
                'fType':selectedRadioOption,'amount':expenseAmountController.text,
                'dTime':DateTime.now().toString(),'sord':expenseReasonController.text,
                'desc':expenseDescriptionController.value.text,
              };
              String? encodedMap;
              if(snackBarFlag==0){encodedMap=json.encode(map);}
              Navigator.of(context).pop(encodedMap);
            }),
          ],
        ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        gradient:LinearGradient(
          begin:Alignment.bottomLeft,
          end:Alignment.topRight,
          colors:[Colors.greenAccent,Colors.white],
        ),
      ),
        child: Scaffold(
          backgroundColor:Colors.transparent,
          body: ListView(
            children: <Widget>[
              Card(
                shape:const BeveledRectangleBorder(),
                child:ListTile(
                  leading:const Image(image:AssetImage('assets/icons/food_and_beverage_icon.png')),
                  title: Text('Food And Beverage',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                  subtitle:const Text('Ex: Money Spent on food and drinks etc.'),
                  onTap:()async{
                    final String? encodedMap=await expenseDialog('Food And Beverage','Food And Beverage');
                    expenseDBInsert(encodedMap);}
                )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/stationary_supply_icon.png')),
                    title: Text('Stationary Supplies',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Money Spent on pens,notebooks etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Stationary Supplies','Stationary Supplies');
                        expenseDBInsert(encodedMap);
                      }
                  ),
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/entertainment_leisure_icon.png')),
                    title: Text('Entertainment And Leisure',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Money Spent for going to cinema theatres,buying video games etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Entertainment And Leisure','Entertainment And Leisure');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/subscription_icon.png')),
                    title: Text('Subscriptions',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Money spent on subscribed services like Netflix, Crunchyroll etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Subscriptions','Subscriptions');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/loan_returned_icon.png')),
                    title: Text('Loan Returned',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: You gave back the money you borrowed from a friend etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Loan Returned','Loan Returned');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/loan_given_icon.png')),
                    title: Text('Loan Given',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: You gave some money to your friend etc.'),
                      onTap:()async {
                        final String? encodedMap = await expenseDialog(
                            'Loan Given', 'Loan Given');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/medical_icon.png')),
                    title: Text('Medical',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Medical expenses you incurred etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Medical','Medical');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/clothing_icon.png')),
                    title: Text('Clothing',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Money spent on clothes etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Clothing','Clothing');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/general_supply_icon.png')),
                    title: Text('General Supply',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Money spent on soaps,toothbrush.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('General Supply','General Supply');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/partner_icon.png')),
                    title: Text('Partner',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: For those annoying couples in campus'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Partner','Partner');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/celebration_icon.png')),
                    title: Text('Celebration',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Birthday parties etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Celebration','Celebration');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/event_registration_icon.png')),
                    title: Text('Event Registration',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Registering for college events etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Event Registration','Event Registration');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/travel_icon.png')),
                    title: Text('Travel',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: Travel expenses etc.'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Travel','Travel');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
              Card(
                  shape:const BeveledRectangleBorder(),
                  child:ListTile(
                    leading:const Image(image:AssetImage('assets/icons/misc_icon.png')),
                    title: Text('Miscellaneous',style: GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                    subtitle:const Text('Ex: If expense does not come under any of the above category'),
                      onTap:()async{
                        final String? encodedMap=await expenseDialog('Miscellaneous','Miscellaneous');
                        expenseDBInsert(encodedMap);
                      }
                  )
              ),
            ],
          ),
            ),
      );
  }
}