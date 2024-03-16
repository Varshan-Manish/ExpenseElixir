import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/transaction_model.dart';
class IncomePage extends StatefulWidget{
  const IncomePage({super.key});
  @override
  State<IncomePage> createState() =>_IncomePageState();
}
class _IncomePageState extends State<IncomePage> {
  _IncomePageState();
  int formExitFlag=0;
  DatabaseHelper databaseHelper=DatabaseHelper();
  TextEditingController incomeAmountController=TextEditingController();
  TextEditingController incomeSourceController=TextEditingController();
  TextEditingController incomeDescriptionController=TextEditingController();
  SnackBar snackBar(Color colors,String text){
    return SnackBar(
      content:Text(text,style:GoogleFonts.montserrat(color:Colors.white)),
      backgroundColor:colors,
    );
  }
  void incomeDBInsert(String? encodedMap){
    try {
      if (encodedMap != null) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.green,
            'Income Added Successfully'));
        final Map<String, dynamic>decodedMap = jsonDecode(encodedMap);
        TransactionModel transaction=TransactionModel.fromMap(decodedMap);
        databaseHelper.insertTransactionTable(transaction);
      }
      else if (encodedMap == null && formExitFlag == 1) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.red,
            'Invalid Entry'));
      }
      else if(encodedMap==null && formExitFlag==2){
        ScaffoldMessenger.of(context).showSnackBar(snackBar(Colors.red,
            'Cancelled Operation'));
      }
    }catch(e){null;}
    finally {
      incomeSourceController.clear();
      incomeAmountController.clear();
      incomeDescriptionController.clear();
      formExitFlag = 0;
    }
  }
  Future<String?> incomeDialog(String header,String incomeSubType){
    List<String>radioOptions=['Cash','Electronic'];
    String selectedRadioOption=radioOptions[0];
    return showDialog<String>(
      barrierDismissible: true,
      context:context,
      builder:(context)=>SingleChildScrollView(
        child: AlertDialog(
          title:Align(alignment: Alignment.center,
              child:Text(header,style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,color:Colors.white))),
          backgroundColor: Colors.black,
          content:Column(
            children: <Widget>[
              TextField(decoration:const InputDecoration(hintText:'*Income Amount',fillColor:Colors.white,filled:true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                    LengthLimitingTextInputFormatter(8)],
                  controller:incomeAmountController,
                  cursorColor:Colors.green,
                  autofocus:true,
                  keyboardType:TextInputType.number),
              const SizedBox(height:10.0),
              TextField(decoration:const InputDecoration(hintText:'*From',fillColor: Colors.white,filled:true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                  LengthLimitingTextInputFormatter(20)],
                  controller:incomeSourceController,
                  cursorColor:Colors.green,
                  autofocus:true,
                  keyboardType: TextInputType.text,),
              const SizedBox(height:10.0),
              TextField(decoration: const InputDecoration(hintText:'Description',fillColor: Colors.white,filled: true,
                  enabledBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),
                  focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:Colors.green)),),
                  inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ]")),
                  LengthLimitingTextInputFormatter(40)],
                  controller:incomeDescriptionController,
                  autofocus:true,
                  cursorColor:Colors.green,
                  keyboardType: TextInputType.text,),
              const SizedBox(height:5.0),
              Text('Income Type',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold,
              color:Colors.white,)),
              const Divider(thickness: 2.5,),
              const SizedBox(height:10.0),
              StatefulBuilder(
                builder:(context,setState){
                return Column(
                  children: [
                    RadioListTile(value:'Cash', groupValue: selectedRadioOption,
                      onChanged: (value){setState(()=>selectedRadioOption=value as String);},
                      title: Text('Cash',style:GoogleFonts.montserrat(color:Colors.white)),
                      autofocus: true,
                      activeColor: Colors.green),
                    RadioListTile(value:'Electronic', groupValue:selectedRadioOption,
                    enableFeedback: true,
                    onChanged: (value){setState(()=>selectedRadioOption=value as String);},
                    title: Text('Electronic',style:GoogleFonts.montserrat(color:Colors.white)),
                    autofocus: true,
                    activeColor: Colors.green),
                  ],
                );}
              ),
              ],
            ),
          actions:[TextButton(
            child:Text('CANCEL',style:GoogleFonts.montserrat(color:Colors.green)),
            onPressed: (){
              Navigator.of(context).pop(null);
              formExitFlag=2;
            },
          )
            ,TextButton(
              child:Text('SUBMIT',style:GoogleFonts.montserrat(color:Colors.green)),
              onPressed:(){
                formExitFlag=1;
                int snackBarFlag=0;
                if(incomeAmountController.text==''||incomeSourceController.text==''){snackBarFlag=1;}
                Map<String,dynamic> map={
                  'tType':'Income','tSubType':incomeSubType,
                  'fType':selectedRadioOption,'amount':incomeAmountController.text,
                  'dTime':DateTime.now().toString(),'sord':incomeSourceController.text,
                  'desc':incomeDescriptionController.value.text,
                };
                String? encodedMap;
                if(snackBarFlag==0){encodedMap=json.encode(map);}
                Navigator.of(context).pop(encodedMap);}),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
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
        body:ListView(
          children:<Widget>[
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/inflow_icon.png')),
                title: Text('Funds Inflow',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: Money from parents,relatives etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Funds Inflow','Funds Inflow');
                incomeDBInsert(encodedMap);
                },
              ),
            ),
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/prize_money_icon.png')),
                title: Text('Prize Money',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: Money you got by winning events etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Prize Money','Prize Money');
                  incomeDBInsert(encodedMap);
                },
              ),
            ),
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/loan_returns_icon.png')),
                title: Text('Loan Returns',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: You got back the money you gave your friend etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Loan Returns','Loan Returns');
                incomeDBInsert(encodedMap);
                },
              ),
            ),
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/loan_taken_icon.png')),
                title: Text('Loan Taken',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: Your borrowed some money from your friend etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Loan Taken','Loan Taken');
                incomeDBInsert(encodedMap);
                },
              ),
            ),
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/investment_returns_icon.png')),
                title: Text('Investment Returns',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: Money you gained from stock market etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Investment Returns','Investment Returns');
                incomeDBInsert(encodedMap);
                },
              ),
            ),
            Card(
              shape:const BeveledRectangleBorder(),
              child: ListTile(
                leading:const Image(image:AssetImage('assets/icons/salary_icon.png')),
                title: Text('Salary',style:GoogleFonts.montserrat(fontWeight:FontWeight.bold)),
                subtitle:Text('Ex: Internship salaries etc.',style:GoogleFonts.montserrat()),
                onTap:()async{final String? encodedMap=await incomeDialog('Salary','Salary');
                incomeDBInsert(encodedMap);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
