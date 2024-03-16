import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'stat_settings_model.dart';
import 'budget_model.dart';
import 'transaction_model.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper{
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  String transactionTable='transaction_table';
  String colId='id';
  String colTType='tType';
  String colTSubtype='tSubType';
  String colFType='fType';
  String colAmount='amount';
  String coldTime='dTime';
  String colSord='sord';
  String colDesc='desc';
  String budgetTable='budget_table';
  String colBudget='budget';
  String colBDTime='bDTime';
  String colMode='mode';
  String statSettingsTable='statSettings_table';
  String colStatType='tQuery';
  String colStatTime='tTime';
  DatabaseHelper.createInstance();
  factory DatabaseHelper(){
    _databaseHelper ??= DatabaseHelper.createInstance();
    return _databaseHelper as DatabaseHelper;
  }
  void createDB(Database db,int newVersion)async{
    await db.execute('CREATE TABLE $transactionTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colTType STRING,$colTSubtype STRING,$colFType STRING,$colAmount REAL,$coldTime STRING,$colSord STRING,'
        '$colDesc STRING)');
    String colBudgetDefault='0';
    String colBDTimeDefault=DateTime.now().toString();
    String colModeDefault='weekly';
    await db.execute('CREATE TABLE $budgetTable($colBudget REAL DEFAULT "$colBudgetDefault",$colBDTime STRING'
        ' DEFAULT "$colBDTimeDefault",$colMode STRING DEFAULT "$colModeDefault")');
    await db.execute('CREATE TABLE $statSettingsTable($colStatType STRING,$colStatTime STRING)');
  }
  Future<Database> initializeDB()async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path='${directory.path}expenseElixir.db';
    var expenseElixirDB=await openDatabase(path,version:1,onCreate:createDB);
    return expenseElixirDB;
  }
  Future<Database> get database async{
    _database ??= await initializeDB();
    return _database as Database;
  }
  Future<List<Map<String,dynamic>>>getTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable);
    return result;
  }
  Future<List<Map<String,dynamic>>>getStatSettingsMapList()async{
    Database db=await database;
    var result=await db.query(statSettingsTable);
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllIncomeTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns: ['SUM($colAmount)'],where:'$colTType="Income"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllExpenseTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns: ['SUM($colAmount)'],where:'$colTType="Expense"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyIncomeTransactionMapList()async{
    Database db=await database;
    String dateWeekAgo=DateTime.now().subtract(const Duration(days:7)).toString();
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTType="Income" AND '
        ' $coldTime >= "$dateWeekAgo"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyExpenseTransactionMapList()async{
    Database db=await database;
    String dateWeekAgo=DateTime.now().subtract(const Duration(days:7)).toString();
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTType="Expense" AND'
        ' $coldTime >= "$dateWeekAgo"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyIncomeTransactionMapList()async{
    Database db=await database;
    String dateWeekAgo=DateTime.now().subtract(const Duration(days: 30)).toString();
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTType="Income" AND '
        ' $coldTime >= "$dateWeekAgo"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyExpenseTransactionMapList()async{
    Database db=await database;
    String dateWeekAgo=DateTime.now().subtract(const Duration(days: 30)).toString();
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTType="Expense" AND'
        ' $coldTime >= "$dateWeekAgo"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getLoansTakenTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTSubtype="Loan Taken"');
    return result;
  }
 Future<List<Map<String,dynamic>>>getLoansTakenReturnedTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,where:'$colTSubtype="Loan Taken" OR $colTSubtype="Loan Returned"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getLoansReturnedTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTSubtype="Loan Returned"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getLoansGivenTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTSubtype="Loan Given"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getLoansGivenReturnsTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,where:'$colTSubtype="Loan Returns" OR $colTSubtype="Loan Given"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getLoansReturnsTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUM($colAmount)'],where:'$colTSubtype="Loan Returns"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekBeforeDate=(DateTime.now().subtract(const Duration(days:7))).toString();
    var result=await db.query(transactionTable,where:'$coldTime <= "$currentDate" AND $coldTime >="$weekBeforeDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekBeforeDate=(DateTime.now().subtract(const Duration(days:30))).toString();
    var result=await db.query(transactionTable,where:'$coldTime <= "$currentDate" AND $coldTime >="$weekBeforeDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getCustomTransactionMapList(String fromDate,String toDate)async{
    Database db=await database;
    List<Map<String,dynamic>> result;
    if(fromDate.compareTo(toDate)<0){
      result=await db.query(transactionTable,where:'$coldTime >= "$fromDate" AND $coldTime <="$toDate"');
    }
    else if(fromDate.compareTo(toDate)>0) {
      result=await db.query(transactionTable,where: '$coldTime <= "$fromDate" AND $coldTime >="$toDate"');
    }
    else{
      result=await db.query(transactionTable,where: '$coldTime >="$toDate"');
    }
    return result;
  }
  Future<List<Map<String,dynamic>>>getBudgetMapList()async{
    Database db=await database;
    var result=await db.query(budgetTable);
    return result;
  }
  Future<int> insertTransactionTable(TransactionModel transaction)async{
    Database db=await database;
    var result=await db.insert(transactionTable,transaction.toMap());
    return result;
  }
  Future<void> initializeBudgetTable()async{
    Database db=await database;
    String defaultColBudget='"0"';
    String currentTime=DateTime.now().toString();
    String defaultColBDTime='"$currentTime"';
    String defaultColMode='"weekly"';
    await db.execute('INSERT INTO $budgetTable VALUES($defaultColBudget,$defaultColBDTime,$defaultColMode)');
  }
  Future<void> initializeStatSettingsTable()async{
    Database db=await database;
    await db.execute('INSERT INTO $statSettingsTable VALUES("Income","Weekly")');
  }
  Future<void> updateBudgetBudgetTable(double budget)async{
    Database db=await database;
    String nowTime=DateTime.now().toString();
    await db.execute('UPDATE $budgetTable SET $colBudget=$budget,$colBDTime="$nowTime"');
  }
  Future<void> updateQueryStatSettingsTable(String query)async{
    Database db=await database;
    await db.execute('UPDATE $statSettingsTable SET $colStatType="$query"');
  }
  Future<void> updateTimeStatSettingsTable(String time)async{
    Database db=await database;
    await db.execute('UPDATE $statSettingsTable SET $colStatTime="$time"');
  }
  Future<void> updateModeBudgetTable(String mode)async{
    Database db=await database;
    await db.execute('UPDATE $budgetTable SET $colMode="$mode"');
  }
  Future<int> deleteTransactionTable(int id)async{
    Database db=await database;
    var result=await db.delete(transactionTable,where: '$colId=?',whereArgs:[id]);
    return result;
  }
  Future<int> getCountTransactionTable()async{
    Database db=await database;
    List<Map<String,dynamic>> x=await db.rawQuery('SELECT COUNT(*) FROM $transactionTable');
    int? result=Sqflite.firstIntValue(x);
    return result!;
  }
  Future<int> getCountBudgetTable()async{
    Database db=await database;
    List<Map<String,dynamic>> x=await db.rawQuery('SELECT COUNT(*) FROM $budgetTable');
    int? result=Sqflite.firstIntValue(x);
    return result!;
  }
  Future<int> getCountStatSettingsTable()async{
    Database db=await database;
    List<Map<String,dynamic>> x=await db.rawQuery('SELECT COUNT(*) FROM $statSettingsTable');
    int? result=Sqflite.firstIntValue(x);
    return result!;
  }
  Future<int> getCountWeeklyTransactionTable()async{
    List<Map<String,dynamic>> mapList=await getWeeklyTransactionMapList();
    int result=mapList.length;
    return result;
  }
  Future<int> getCountMonthlyTransactionTable()async{
    List<Map<String,dynamic>> mapList=await getMonthlyTransactionMapList();
    int result=mapList.length;
    return result;
  }
  Future<List<TransactionModel>> getTransactionList()async{
    List<Map<String,dynamic>> mapList=await getTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<StatSettingsModel>> getStatSettingsList()async{
    List<Map<String,dynamic>> mapList=await getStatSettingsMapList();
    int count=mapList.length;
    List<StatSettingsModel> statSettingsList=[];
    for(int i=count-1;i>-1;i--){
      statSettingsList.add(StatSettingsModel.fromMap(mapList[i]));
    }
    return statSettingsList;
  }
  Future<List<TransactionModel>> getAllIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<BudgetModel>> getBudgetList()async{
    List<Map<String,dynamic>> mapList=await getBudgetMapList();
    int count=mapList.length;
    List<BudgetModel> budgetList=[];
    for(int i=count-1;i>-1;i--){
      budgetList.add(BudgetModel.fromMap(mapList[i]));
    }
    return budgetList;
  }
  Future<List<TransactionModel>> getLoansTakenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansTakenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getLoansReturnedTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansReturnedTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getLoansGivenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansGivenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getLoansReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getLoansTakenReturnedTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansTakenReturnedTransactionMapList();
    int count=mapList.length;
    int endCount=-1;
    double sum=0;
    for(int i=0;i<count;i++){
      TransactionModel transaction=TransactionModel.fromMap(mapList[i]);
      if(transaction.tSubType=='Loan Taken') {
        sum=sum+double.parse(transaction.amount as String);
      }
      else{
        sum=sum-double.parse(transaction.amount as String);
      }
      if(i!=0 && sum==0){
        endCount=i;
      }
    }
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>endCount;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getLoansGivenReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getLoansGivenReturnsTransactionMapList();
    int count=mapList.length;
    int endCount=-1;
    double sum=0;
    for(int i=0;i<count;i++){
      TransactionModel transaction=TransactionModel.fromMap(mapList[i]);
      if(transaction.tSubType=='Loan Returns') {
        sum=sum+double.parse(transaction.amount as String);
      }
      else{
        sum=sum-double.parse(transaction.amount as String);
      }
      if(i!=0 && sum==0){
        endCount=i;
      }
    }
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>endCount;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getCustomTransactionList(String fromDate,String toDate)async{
    List<Map<String,dynamic>> mapList=await getCustomTransactionMapList(fromDate,toDate);
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<void>updateBudgetTable(String mode)async{
    Database db=await database;
    Map<String,String>updateMap={'budget':"0",'bDTime':'${DateTime.now()}','mode':mode};
    db.update(budgetTable,updateMap);
  }
  Future<void> truncateTransactionTable()async{
    Database db=await database;
    db.execute('DELETE FROM TRANSACTION_TABLE');
  }
  Future<void> truncateBudgetTable()async{
    Database db=await database;
    db.execute('DELETE FROM BUDGET_TABLE');
  }
  Future<void> truncateStatSettingsTable()async{
    Database db=await database;
    db.execute('DELETE FROM STATSETTINGS_TABLE');
  }
  Future<List<Map<String,dynamic>>>getWeeklyFundsInflowTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Funds Inflow" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyPrizeMoneyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Prize Money" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyLoanReturnsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returns" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyLoanTakenTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Taken" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyInvestmentReturnsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Investment Returns" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklySalaryTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Salary" AND $coldTime>='
        '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<TransactionModel>> getWeeklyFundsInflowTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyFundsInflowTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyPrizeMoneyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyPrizeMoneyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyLoanReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyLoanReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyLoanTakenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyLoanTakenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyInvestmentReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyInvestmentReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklySalaryTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklySalaryTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getMonthlyFundsInflowTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Funds Inflow" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyPrizeMoneyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Prize Money" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyLoanReturnsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returns" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyLoanTakenTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Taken" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyInvestmentReturnsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Investment Returns" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlySalaryTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Salary" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<TransactionModel>> getMonthlyFundsInflowTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyFundsInflowTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyPrizeMoneyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyPrizeMoneyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyLoanReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyLoanReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyLoanTakenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyLoanTakenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyInvestmentReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyInvestmentReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlySalaryTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlySalaryTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getAllFundsInflowTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Funds Inflow" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllPrizeMoneyTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Prize Money" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllLoanReturnsTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returns" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllLoanTakenTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Taken" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllInvestmentReturnsTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Investment Returns" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllSalaryTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Salary" ');
    return result;
  }
  Future<List<TransactionModel>> getAllFundsInflowTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllFundsInflowTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllPrizeMoneyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllPrizeMoneyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllLoanReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllLoanReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllLoanTakenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllLoanTakenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllInvestmentReturnsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllInvestmentReturnsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllSalaryTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllSalaryTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getWeeklyFoodAndBeverageTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Food And Beverage" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyStationarySuppliesTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Stationary Supplies" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyEntertainmentAndLeisureTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Entertainment And Leisure" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklySubscriptionsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Subscriptions" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyLoanReturnedTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returned" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyLoanGivenTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Given" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyMedicalTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Medical" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyClothingTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Clothing" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyGeneralSupplyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="General Supply" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyPartnerTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Partner" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyCelebrationTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Celebration" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyEventRegistrationTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Event Registration" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyTravelTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Travel" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyMiscellaneousTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Miscellaneous" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<TransactionModel>> getWeeklyFoodAndBeverageTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyFoodAndBeverageTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyStationarySuppliesTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyStationarySuppliesTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyEntertainmentAndLeisureTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyEntertainmentAndLeisureTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklySubscriptionsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklySubscriptionsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyLoanReturnedTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyLoanReturnedTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyLoanGivenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyLoanGivenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyMedicalTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyMedicalTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyClothingTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyClothingTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyGeneralSupplyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyGeneralSupplyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyPartnerTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyPartnerTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyCelebrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyCelebrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyEventRegistrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyEventRegistrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyTravelTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyTravelTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyMiscellaneousTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyMiscellaneousTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getMonthlyFoodAndBeverageTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Food And Beverage" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyStationarySuppliesTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Stationary Supplies" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyEntertainmentAndLeisureTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Entertainment And Leisure" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlySubscriptionsTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Subscriptions" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyLoanReturnedTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returned" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyLoanGivenTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Given" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyMedicalTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Medical" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyClothingTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Clothing" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyGeneralSupplyTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="General Supply" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyPartnerTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Partner" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyCelebrationTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Celebration" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyEventRegistrationTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Event Registration" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyTravelTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Travel" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyMiscellaneousTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Miscellaneous" AND $coldTime>='
            '"$weekAgoDate" AND $coldTime <="$currentDate"');
    return result;
  }
  Future<List<TransactionModel>> getMonthlyFoodAndBeverageTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyFoodAndBeverageTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyStationarySuppliesTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyStationarySuppliesTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyEntertainmentAndLeisureTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyEntertainmentAndLeisureTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlySubscriptionsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlySubscriptionsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyLoanReturnedTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyLoanReturnedTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyLoanGivenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyLoanGivenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyMedicalTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyMedicalTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyClothingTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyClothingTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyGeneralSupplyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyGeneralSupplyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyPartnerTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyPartnerTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyCelebrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyCelebrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyEventRegistrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyEventRegistrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyTravelTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyTravelTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyMiscellaneousTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyMiscellaneousTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getAllFoodAndBeverageTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Food And Beverage" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllStationarySuppliesTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Stationary Supplies" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllEntertainmentAndLeisureTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Entertainment And Leisure" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllSubscriptionsTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Subscriptions" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllLoanReturnedTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Returned" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllLoanGivenTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Loan Given" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllMedicalTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Medical" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllClothingTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Clothing" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllGeneralSupplyTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="General Supply" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllPartnerTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Partner" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllCelebrationTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Celebration" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllEventRegistrationTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Event Registration" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllTravelTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Travel" ');
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllMiscellaneousTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['$colTSubtype,SUM($colAmount)'],
        where:'$colTSubtype="Miscellaneous" ');
    return result;
  }
  Future<List<TransactionModel>> getAllFoodAndBeverageTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllFoodAndBeverageTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllStationarySuppliesTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllStationarySuppliesTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllEntertainmentAndLeisureTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllEntertainmentAndLeisureTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllSubscriptionsTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllSubscriptionsTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllLoanReturnedTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllLoanReturnedTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllLoanGivenTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllLoanGivenTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllMedicalTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllMedicalTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllClothingTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllClothingTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllGeneralSupplyTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllGeneralSupplyTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllPartnerTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllPartnerTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllCelebrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllCelebrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllEventRegistrationTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllEventRegistrationTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllTravelTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllTravelTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllMiscellaneousTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllMiscellaneousTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<Map<String,dynamic>>>getWeeklyDailyIncomeTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Income"',
        groupBy: 'SUBSTR($coldTime,1,10)',having:'$coldTime<="$currentDate" AND $coldTime>="$weekAgoDate"' );
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyDailyIncomeTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Income"',
        groupBy: 'SUBSTR($coldTime,1,10)',having:'$coldTime<="$currentDate" AND $coldTime>="$weekAgoDate"' );
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllDailyIncomeTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Income"',
        groupBy: 'SUBSTR($coldTime,1,10)');
    return result;
  }
  Future<List<Map<String,dynamic>>>getWeeklyDailyExpenseTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 7))).toString();
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Expense"',
        groupBy: 'SUBSTR($coldTime,1,10)',having:'$coldTime<="$currentDate" AND $coldTime>="$weekAgoDate"' );
    return result;
  }
  Future<List<Map<String,dynamic>>>getMonthlyDailyExpenseTransactionMapList()async{
    Database db=await database;
    String currentDate=DateTime.now().toString();
    String weekAgoDate=(DateTime.now().subtract(const Duration(days: 30))).toString();
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Expense"',
        groupBy: 'SUBSTR($coldTime,1,10)',having:'$coldTime<="$currentDate" AND $coldTime>="$weekAgoDate"' );
    return result;
  }
  Future<List<Map<String,dynamic>>>getAllDailyExpenseTransactionMapList()async{
    Database db=await database;
    var result=await db.query(transactionTable,columns:['SUBSTR($coldTime,1,10),SUM($colAmount)'],where:'$colTType="Expense"',
        groupBy: 'SUBSTR($coldTime,1,10)');
    return result;
  }
  Future<List<TransactionModel>> getWeeklyDailyIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyDailyIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyDailyIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyDailyIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllDailyIncomeTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllDailyIncomeTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getAllDailyExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getAllDailyExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getWeeklyDailyExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getWeeklyDailyExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }
  Future<List<TransactionModel>> getMonthlyDailyExpenseTransactionList()async{
    List<Map<String,dynamic>> mapList=await getMonthlyDailyExpenseTransactionMapList();
    int count=mapList.length;
    List<TransactionModel> transactionList=[];
    for(int i=count-1;i>-1;i--){
      transactionList.add(TransactionModel.fromMap(mapList[i]));
    }
    return transactionList;
  }

}
