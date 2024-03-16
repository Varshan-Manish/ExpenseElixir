class TransactionModel{
  int? id;
  String? tType;
  String? tSubType;
  String? fType;
  String? amount;
  String? dTime;
  String? sord; //source or destination
  String? desc;
  String? sAmount;
  String? dateReadable;
  TransactionModel({required this.id,required this.tType,required this.tSubType,required this.fType,
    required this.amount,required this.dTime,required this.sord,required this.desc,});
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map={};
    map['id']=id;
    map['tType']=tType;
    map['tSubType']=tSubType;
    map['amount']=amount;
    map['fType']=fType;
    map['dTime']=dTime;
    map['sord']=sord;
    map['desc']=desc;
    return map;
  }
  TransactionModel.fromMap(Map<String,dynamic> map){
    id=map['id'];
    if(map['tType']!=null){
      tType=map['tType'];
    }
    if(map['tSubType']!=null) {
      tSubType = map['tSubType'];
    }
    if(map['amount']!=null) {
      amount = map['amount'].toString();
    }
    if(map['fType']!=null){
      fType=map['fType'];
    }
    if(map['dTime']!=null) {
      dTime = map['dTime'].toString();
    }
    if(map['sord']!=null){
      sord=map['sord'];
    }
    if(map['desc']!=null){
      desc=map['desc'];
    }
    if(map['SUM(amount)']!=null){
      sAmount=map['SUM(amount)'].toString();
    }
    else{
      sAmount='0';
    }
    if(map['SUBSTR(dTime,1,10)']!=null){
      dateReadable=map['SUBSTR(dTime,1,10)'];
    }
    else{
      dateReadable="";
    }
  }
}