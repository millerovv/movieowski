import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  SearchBarDelegate({
    @required this.child,
    this.height = appBarHeight,
    this.backgroundColor,
  }) : assert(child != null);

  static const double appBarHeight = 52.0;

  final Widget child;
  final double height;
  final Color backgroundColor;

  DecorationTween containerDecoration;

  double _calculateShadowAnimationValue(double shrinkOffset) {
    return 1 - (maxExtent - shrinkOffset) / maxExtent;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    containerDecoration = DecorationTween(
        begin: BoxDecoration(color: backgroundColor, boxShadow: const []),
        end: BoxDecoration(color: backgroundColor, boxShadow: [
          BoxShadow(
            color: Color(0x1A231F51),
            offset: Offset(0.0, 2.0),
            blurRadius: 30.0,
          )
        ]));

    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: containerDecoration.transform(_calculateShadowAnimationValue(shrinkOffset)),
      child: child,
    );
  }

  @override
  bool shouldRebuild(SearchBarDelegate oldDelegate) => true;

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;
}

class SearchBar extends StatelessWidget {
  final TextEditingController textFieldController;
  final FocusNode focusNode;
  final bool showClearSearchButton;
  final bool showCancelButton;
  final Function(String text) onChanged;
  final Function() onClearButtonClick;
  final Function() onCancelButtonClick;

  SearchBar({
    Key key,
    this.textFieldController,
    this.focusNode,
    this.showClearSearchButton,
    this.showCancelButton,
    this.onChanged,
    this.onClearButtonClick,
    this.onCancelButtonClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: showCancelButton ? 72 : 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: TextField(
                controller: textFieldController,
                focusNode: focusNode,
                style: Theme.of(context).textTheme.subhead,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.black87,
                onChanged: onChanged,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Search for any movie or actor',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 22.0,
                      color: AppColors.hintGrey,
                    ),
                    suffixIcon: showClearSearchButton
                        ? IconButton(
                            onPressed: onClearButtonClick,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.clear, size: 22, color: AppColors.hintGrey),
                          )
                        : null,
                    hintStyle: Theme.of(context).textTheme.body1.copyWith(color: AppColors.hintGrey)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: showCancelButton
              ? GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                    onCancelButtonClick();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
                    ),
                  ),
                )
              : SizedBox(),
        ),
      ],
    );
  }
}
