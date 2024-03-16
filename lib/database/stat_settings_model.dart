class StatSettingsModel{
  String? tQuery;
  String? tTime;
  StatSettingsModel(this.tQuery,this.tTime);
  Map<String,dynamic> toMap(){
      Map<String,dynamic> map={};
      map['typeQuery']=tQuery;
      map['tTime']=tTime;
      return map;
  }
  StatSettingsModel.fromMap(Map<String,dynamic>map){
    tQuery=map['tQuery'];
    tTime=map['tTime'];
  }
}