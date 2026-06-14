import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';

/// BaseScreenTemplate: World-Class template for all VisionSafe screens.
/// Features AAA immersive layered background, strict SafeArea, and elastic physics.
class BaseScreenTemplate extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool usePadding;
  final bool extendBodyBehindAppBar;
  final ScrollPhysics? physics;
  final List<Widget>? stackLayers;
  final double bottomPadding;
  final double? topPadding;
  final Future<void> Function()? onRefresh;

  const BaseScreenTemplate({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.usePadding = true,
    this.extendBodyBehindAppBar = false, // Changed to false for stability
    this.physics = const BouncingScrollPhysics(),
    this.stackLayers,
    this.bottomPadding = 180.0,
    this.topPadding,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      physics: physics,
      clipBehavior: Clip.none,
      child: SafeArea(
        top: appBar == null, // Safe area only if no app bar
        bottom: false,
        child: Padding(
          padding: (usePadding ? AppDesign.screenPadding : EdgeInsets.zero).copyWith(
            top: topPadding ?? (appBar != null ? AppDesign.space16 : AppDesign.spaceM),
            bottom: bottomPadding,
          ),
          child: child,
        ),
      ),
    );

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        child: content,
      );
    }

    return VImmersiveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: true,
        body: Stack(
          children: [
            content,
            if (stackLayers != null) ...stackLayers!,
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
