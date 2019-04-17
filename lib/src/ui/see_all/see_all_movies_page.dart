import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class CategoriesPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SeeAllMoviesPage extends StatefulWidget {
  @override
  _SeeAllMoviesPageState createState() => _SeeAllMoviesPageState();
}

class _SeeAllMoviesPageState extends State<SeeAllMoviesPage> with SingleTickerProviderStateMixin {
  static const int animationDuration = 400;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: animationDuration), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _createAppBar() {
    return Container(
      color: Colors.lightBlue,
      child: Material(
        elevation: 3.0,
        child: Container(
          height: kToolbarHeight,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 32.0,
                  color: AppColors.primaryWhite,
                ),
              ),
              Text(
                'In theatres',
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  Icons.menu,
                  size: 24.0,
                  color: AppColors.primaryWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.pink,
        ),
        Container(
          height: kStatusBarHeight,
          color: AppColors.primaryColor,
        ),
        Positioned(
          top: 50,
          left: 0,
          child: Container(
            height: 700,
            width: MediaQuery.of(context).size.width,
            child: Scaffold(
              body: ScrollConfiguration(
                behavior: NoGlowBehavior(),
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          height: kToolbarHeight,
                          child: _createAppBar(),
                        ),
                      ),
                    ];
                  },
                  body: Container(color: Colors.blue,)
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.height,
    @required this.child,
  });
  final double height;
  final Widget child;
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}