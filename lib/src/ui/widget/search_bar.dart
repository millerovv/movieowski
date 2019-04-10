import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController textFieldController;
  final FocusNode focusNode;
  final bool showClearSearchButton;
  final Function(String text) onChanged;

  SearchBar({
    Key key,
    this.textFieldController,
    this.focusNode,
    this.showClearSearchButton,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(12.0, kStatusBarHeight + 16.0, 12.0, 12.0),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.search,
                      size: 22.0,
                      color: AppColors.hintGrey,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: textFieldController,
                        focusNode: focusNode,
                        style: Theme.of(context).textTheme.subhead,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: Colors.black87,
                        onChanged: onChanged,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            // Set contentPadding to prevent incorrect layout of this TextField (bug?)
                            contentPadding: EdgeInsets.all(0.0),
                            hintText: 'Search for any movie or actor',
                            hintStyle: Theme.of(context).textTheme.body1.copyWith(color: AppColors.hintGrey)),
                      ),
                    ),
                  ),
                  showClearSearchButton
                      ? GestureDetector(
                          onTap: () => textFieldController.text = '',
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.clear,
                              size: 22.0,
                              color: AppColors.hintGrey,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        focusNode.hasFocus
            ? Padding(
                padding: const EdgeInsets.only(top: 22.0, right: 12.0),
                child: GestureDetector(
                  onTap: () {
                    focusNode.unfocus();
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.body1.copyWith(color: AppColors.primaryWhite),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
