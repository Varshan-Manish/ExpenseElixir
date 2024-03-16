import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AboutApplication extends StatefulWidget{
  const AboutApplication({super.key});
  @override
  State<AboutApplication> createState() => _AboutApplicationState();
}
class _AboutApplicationState extends State<AboutApplication> with TickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<Alignment> bottomAnimation;
  late Animation<Alignment> topAnimation;
  @override
  void initState(){
    animationController=AnimationController(vsync:this,duration:const Duration(seconds:30));
    bottomAnimation=TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomLeft,end:Alignment.centerLeft), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.centerLeft,end:Alignment.topLeft), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.topLeft,end:Alignment.topCenter), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.topCenter,end:Alignment.centerRight), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.centerRight,end:Alignment.bottomRight), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomRight,end:Alignment.bottomCenter), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomCenter,end:Alignment.bottomRight), weight:1),
      ],
    ).animate(animationController);
    topAnimation=TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.topRight,end:Alignment.centerRight), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.centerRight,end:Alignment.bottomLeft), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomLeft,end:Alignment.bottomCenter), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomCenter,end:Alignment.bottomRight), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.bottomRight,end:Alignment.centerLeft), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.centerLeft,end:Alignment.topLeft), weight:1),
        TweenSequenceItem<Alignment>(
            tween: Tween<Alignment>(begin:Alignment.topLeft,end:Alignment.topRight), weight:1),
      ],
    ).animate(animationController);
    animationController.repeat();
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: animationController,
      builder:(context,_){return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:bottomAnimation.value,
            end:topAnimation.value,
            colors: const<Color>[Colors.green,Colors.greenAccent,Colors.white]
          ),
        ),
        child: Scaffold(
            appBar:AppBar(
              title:Text('About App',style:
              GoogleFonts.montserrat(
                fontSize:30.0,
                fontWeight:FontWeight.w500,
                color:Colors.black,
              ),),
              backgroundColor: Colors.green,
              centerTitle:true,
            ),
            body:Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment:Alignment.center,
                      child: Text('Application Created And Deployed By Wave Microsystems© 2024',
                  style:GoogleFonts.montserrat(color:Colors.black,fontSize:15,fontWeight:FontWeight.w500))),
                  Align(
                      alignment:Alignment.center,
                      child: Text('In Association With Cow Come Studios',
                          style:GoogleFonts.montserrat(color:Colors.black,fontSize:15,fontWeight:FontWeight.w500))),
                  Align(
                      alignment:Alignment.center,
                      child: Text(
                          '00110010 00110010 01001101 01001001 01000011 00110000 00110001 00110000 00110001',
                          style:GoogleFonts.montserrat(color:Colors.black,fontSize:15,fontWeight:FontWeight.w500))),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
        ),
      );}
    );
  }
  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }
}