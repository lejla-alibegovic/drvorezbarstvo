import 'package:wood_track_admin/widgets/wood_track_drawer.dart';
import 'package:flutter/material.dart';

class MasterScreenWidget extends StatelessWidget {
  final Widget? child;
  final String? title;
  final List<Widget>? actions;
  final Color? appBarColor;
  final Color? textColor;
  final bool showDrawerToggle;

  const MasterScreenWidget({
    this.child,
    this.title,
    this.actions,
    this.appBarColor,
    this.textColor,
    this.showDrawerToggle = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= 1100;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor ?? theme.primaryColor,
        title: Text(title ?? "Wood Track Admin"),
        centerTitle: true,
        automaticallyImplyLeading: showDrawerToggle,
        elevation: 2,
        shape: const RoundedRectangleBorder(),
        actions: actions,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appBarColor?.withOpacity(0.9) ?? Colors.brown.withOpacity(0.9),
                appBarColor?.withOpacity(0.7) ?? Colors.brown.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ),
      drawer:
          !isWideScreen && showDrawerToggle ? const WoodTrackDrawer() : null,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isWideScreen && showDrawerToggle)
              const SizedBox(
                width: 250,
                child: WoodTrackDrawer(),
              ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: child!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
