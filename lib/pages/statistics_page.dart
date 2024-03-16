import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_23/pages/statistics_settings_page.dart';
import 'package:project_23/pages/statistics_pie_page.dart';
import 'package:project_23/pages/statistics_graph_page.dart';
class StatisticsPage extends StatefulWidget{
  final int index;
  const StatisticsPage({this.index=1,super.key});
  @override
  State<StatisticsPage> createState() =>_StatisticsPageState(index:index);
}
class _StatisticsPageState extends State<StatisticsPage>{
  int index=0;
  _StatisticsPageState({this.index=1});
  @override
  initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      initialIndex:index,
      length:3,
      child:Scaffold(
        backgroundColor:Colors.transparent,
        appBar:AppBar(
          title:Text('Statistics',style:GoogleFonts.montserrat(
            fontSize:30.0,
            fontWeight:FontWeight.w500,
          )),
          backgroundColor: Colors.green,
          centerTitle:true,
          bottom:const TabBar(
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.fromLTRB(0,0,0,0),
            labelColor: Colors.white,
            tabs: <Tab>[
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/settings_icon.png')),
                text: 'Stats Settings',
              ),
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/pie_page_icon.png')),
                text: 'Pie Chart',
              ),
              Tab(
                icon:ImageIcon(AssetImage('assets/icons/graph_page_icon.png')),
                text: 'Graph Chart',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [StatisticsSettingsPage(),StatisticsPiePage(),StatisticsGraphPage(),],
        )
      ),
    );
  }
}