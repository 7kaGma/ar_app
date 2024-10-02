import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom(
      {super.key,
      this.leading,
      this.actions,
      this.iconColor = ColorConstants.appBarIconColor});
  final Widget? leading;
  final List<Widget>? actions;
  final Color iconColor;

  // AppBarのサイズを指定、kToolbarHeightはデフォ値
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConstants.appBarColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: Padding(padding: const EdgeInsets.only(left:16), child: leading),
      iconTheme: IconThemeData(color: iconColor),
      actions: actions?.map((action){
        return Padding(
        padding: const EdgeInsets.only(right:16),
        child: action
        );
      }).toList(),
      actionsIconTheme: IconThemeData(color: iconColor),
      );
  }
}