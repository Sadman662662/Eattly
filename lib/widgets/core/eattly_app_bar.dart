import 'package:flutter/material.dart';

class EattlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final String title;
  final List<Widget> actions;

  const EattlyAppBar({
    Key key,
    this.leading,
    this.actions,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      toolbarHeight: 80,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
