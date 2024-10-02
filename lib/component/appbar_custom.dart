import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{
  const AppBarCustom({super.key,
    this.leading,
    this.actions,
    this.iconColor = ColorConstants.appBarIconColor
  });
  final Widget? leading;
  final List<Widget>? actions;
  final Color iconColor;

  // AppBarのサイズを指定、kToolbarHeightはデフォ値
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: leading,
      iconTheme: IconThemeData(
        color: iconColor
      ),
      actions: actions,
      actionsIconTheme: IconThemeData(
        color: iconColor
      ),
    );
  }
}