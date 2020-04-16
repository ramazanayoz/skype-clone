
import 'package:flutter/material.dart';
import 'package:skype_clone_app/utils/universal_veriables.dart';

class XCustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  //VAR override
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+10);


  //VAR
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  //CONSTRUCTUR
  const XCustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
  }) : super(key : key);


  //DESİGN Header kısmı
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: XUniversalVariables.blackColor,
        border: Border(
          bottom:BorderSide(
            color: XUniversalVariables.separatorColor,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: XUniversalVariables.blackColor,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

}