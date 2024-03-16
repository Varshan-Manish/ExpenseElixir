import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/pages/home_page.dart';
import 'package:project_23/pages/balance_sheet_page.dart';
import 'package:project_23/pages/individual_transaction_page.dart';
import 'package:project_23/pages/loans_given_page.dart';
import 'package:project_23/pages/loans_taken_page.dart';
import 'package:project_23/pages/statistics_page.dart';
import 'package:project_23/pages/transactions_history_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Primary());
}
class Primary extends StatefulWidget{
  const Primary({super.key});
  @override
  State<Primary> createState() => _PrimaryState();
}
class _PrimaryState extends State<Primary> {
  final GlobalKey<ScaffoldState> _scaffoldKey=GlobalKey<ScaffoldState>();
  _PrimaryState();
  int pageIndex=1;
  List<StatefulWidget> pages=const [BalanceSheetPage(),HomePage(),StatisticsPage()];
  PageController pageController=PageController(initialPage:1);
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Container(
        color:Colors.green,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child:Container(
              padding:const EdgeInsets.fromLTRB(2.0,10.0,0.0,0.0),
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/loading_screen_image.png'),
                      fit: BoxFit.fill,opacity: 0.35)
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Expense Elixir',
                            style:GoogleFonts.montserrat(
                              fontSize:30.0,
                              fontWeight:FontWeight.w300,
                              color:Colors.black,
                            )),
                          const SizedBox(height:5.0),
                          Text('Elixir For Your Expense Enigma',
                              style:GoogleFonts.montserrat(
                                fontSize:15.0,
                                fontWeight:FontWeight.w300,
                                color:Colors.black,
                              )),
                        ],
                      ),

                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/income_icon.png')),
                      title:const Text('Income'),
                      onTap:()=>Navigator.pushNamed(context,'/income_page'),
                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/balance_sheet_page_icon.png')),
                      title:const Text('Funds Flow'),
                      onTap:()=>Navigator.pushNamed(context,'/balance_sheet_funds_flow_page'),
                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/expense_icon.png')),
                      title:const Text('Expense'),
                      onTap:()=>Navigator.pushNamed(context,'/expense_page'),
                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/settings_icon.png')),
                      title:const Text('Stats Settings'),
                      onTap:()=>Navigator.pushNamed(context,'/stats_settings_page'),
                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/pie_page_icon.png')),
                      title:const Text('Pie Chart'),
                      onTap:()=>Navigator.pushNamed(context,'/statistics_pie_page'),
                  ),
                  ListTile(
                      leading:const ImageIcon(AssetImage('assets/icons/graph_page_icon.png')),
                      title:const Text('Graph Chart'),
                      onTap:()=>Navigator.pushNamed(context,'/statistics_graph_page'),
                  ),
                  ListTile(
                    leading: const ImageIcon(AssetImage('assets/icons/transaction_history_icon.png')),
                    title: const Text('Transaction History'),
                    onTap:()=>Navigator.pushNamed(context,'/transaction_history_page')
                  ),
                  const Divider(
                    thickness: 2.5,
                    color: Colors.black38,
                  ),
                  ListTile(
                    leading:const ImageIcon(AssetImage('assets/icons/info_icon.png')),
                    title:const Text('About App'),
                    onTap:()=>Navigator.pushNamed(context,'/app_information_page')
                  ),
                  ListTile(
                    leading:const ImageIcon(AssetImage('assets/icons/settings_icon.png')),
                    title:const Text('App Settings'),
                    onTap:()=>Navigator.pushNamed(context,'/app_settings_page'),
                  )
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body:Stack(
            children: <Widget>[PageView(
              scrollDirection:Axis.vertical,
              onPageChanged: (index){
                setState(()=>pageIndex=index);
              },
              controller:pageController,
              children: pages,
            ),
              Positioned(
                left: 10,
                top: 41,
                child: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState!.openDrawer()
                )
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding:const EdgeInsets.fromLTRB(0.0, 0.0, 0.0,0.0),
            decoration:const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black38),),
            ),
            child: BottomNavigationBar(
              elevation: 0,
              items: const<BottomNavigationBarItem>[BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/balance_sheet_page_icon.png')),
                label:'Balance Sheet',
              ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/home_page_icon.png')),
                  label:'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/icons/statistics_page_icon.png')),
                  label:'Statistics',
                ),
              ],
              currentIndex:pageIndex,
              selectedItemColor: Colors.white,
              backgroundColor: Colors.green,
              onTap: (index){
                setState(()=>pageIndex=index);
                pageController.animateToPage(pageIndex,duration:
                const Duration(milliseconds:200,),curve:Curves.linear);
              },
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes:{
        '/expense_page':(context)=>const BalanceSheetPage(index:2),
        '/transactions_history_page':(context)=>const TransactionsHistory(),
        '/individual_transaction_page':(context)=>const IndividualTransactionPage(),
        '/loans_taken_page':(context)=>const LoansTakenPage(),
        '/loans_given_page':(context)=>const LoansGivenPage(),
      }
    );
  }
}