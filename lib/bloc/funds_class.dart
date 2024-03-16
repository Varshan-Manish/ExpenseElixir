abstract class Income{
  String tType='Income';
  late String fundsType;
  late String dateTime;
  late num amount;
}
class Inflow extends Income{
    String? source;
    String? description;
    late String tSubtype;
    Inflow({required String fundsType,required String dateTime,required amount,this.source,this.description}){
      tSubtype=runtimeType.toString();
      this.fundsType=fundsType;
      this.dateTime=dateTime;
      this.amount=amount;
    }
}
class PrizeMoney extends Income{
  String? source;
  String? description;
  late String tSubtype;
  PrizeMoney({required String fundsType,required String dateTime,required amount,this.source,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class LoanReturns extends Income{
  String? source;
  String? description;
  late String tSubtype;
  LoanReturns({required String fundsType,required String dateTime,required amount,this.source,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class LoanTaken extends Income{
  String? source;
  String? description;
  late String tSubtype;
  LoanTaken({required String fundsType,required String dateTime,required amount,this.source,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class InvestmentReturns extends Income{
  String? source;
  String? description;
  late String tSubtype;
  InvestmentReturns({required String fundsType,required String dateTime,required amount,this.source,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Salary extends Income{
  String? source;
  String? description;
  late String tSubtype;
  Salary({required String fundsType,required String dateTime,required amount,this.source,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
abstract class Expense{
  String tType='Expense';
  late String fundsType;
  late String dateTime;
  late num amount;
}
class FoodAndBeverage extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  FoodAndBeverage({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class StationarySupplies extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  StationarySupplies({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class EntertainmentAndLeisure extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  EntertainmentAndLeisure({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Subscription extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Subscription({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class LoanReturned extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  LoanReturned({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class LoanGiven extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  LoanGiven({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Medical extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Medical({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Clothing extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Clothing({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class GeneralSupply extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  GeneralSupply({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Partner extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Partner({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Celebration extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Celebration({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class EventRegistration extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  EventRegistration({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Travel extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Travel({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
class Misc extends Expense{
  String? destination;
  String? description;
  late String tSubtype;
  Misc({required String fundsType,required String dateTime,required amount,this.destination,this.description}){
    tSubtype=runtimeType.toString();
    this.fundsType=fundsType;
    this.dateTime=dateTime;
    this.amount=amount;
  }
}
