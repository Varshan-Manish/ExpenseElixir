import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:project_23/database/database_helper.dart';
import 'package:project_23/database/budget_model.dart';
import 'package:just_audio/just_audio.dart';
class LoadingPage extends StatefulWidget{
  const LoadingPage({super.key});
  @override
  State<LoadingPage> createState()=> _LoadingPageState();
}
class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin{
  _LoadingPageState();
  SpinKitWave? wave;
  AnimationController? animationControlObject;
  void proceedToHome()async{
    Navigator.pushReplacementNamed(context,'/primary_page',);
  }
  initializeDB()async{
    AudioPlayer player = AudioPlayer();
    await player.setAsset('assets/sounds/startup_music.mp3');
    player.play();
    DatabaseHelper databaseHelper=DatabaseHelper();
    await databaseHelper.initializeDB();
    int budgetCount=await databaseHelper.getCountBudgetTable();
    List<BudgetModel> budgetModelList=[];
    int statSettingCount=await databaseHelper.getCountStatSettingsTable();
    if(statSettingCount==0){
      databaseHelper.initializeStatSettingsTable();
    }
    if(budgetCount==0){
      await databaseHelper.initializeBudgetTable();
    }
    else{
      budgetModelList=await databaseHelper.getBudgetList();
      if(budgetModelList[0].mode=='weekly'){
        if (budgetModelList[0].bDTime.compareTo(
            (DateTime.now().subtract(const Duration(days: 7))).toString()) <
            0) {
          await databaseHelper.updateBudgetTable('weekly');
        }
      }
      if(budgetModelList[0].mode=='monthly'){
        if (budgetModelList[0].bDTime.compareTo(
            (DateTime.now().subtract(const Duration(days: 30))).toString()) <
            0) {
          await databaseHelper.updateBudgetTable('monthly');
        }
      }
    }
    proceedToHome();
  }
  @override
  void initState() {
    animationControlObject =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    wave = SpinKitWave(
        color: Colors.green,
        size: 75.0,
        controller: animationControlObject);
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    initializeDB();
    return Container(
      decoration:const BoxDecoration(
        image: DecorationImage(image:AssetImage('assets/images/loading_screen_image.png'),
        opacity: 0.35,
        fit:BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        body: Center(
          child:wave,
          ),
        ),
    );
  }
  @override
  void dispose(){
    animationControlObject!.dispose();
    super.dispose();
  }
}
