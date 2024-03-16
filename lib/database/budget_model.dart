class BudgetModel{
  late double budget;
  late String bDTime;
  late String mode;
  BudgetModel({required this.budget,required this.bDTime,required this.mode});
  Map<String,dynamic> toMap(){
    Map<String,String> map={};
    map['budget']=budget.toString();
    map['bDTime']=bDTime;
    map['mode']=mode;
    return map;
  }
  BudgetModel.fromMap(Map<String,dynamic> map){
    budget=map['budget'];
    bDTime=map['bDTime'];
    mode=map['mode'];
  }
}