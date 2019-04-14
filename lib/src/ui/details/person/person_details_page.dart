import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/person_details_page/person_details_page_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/ui/widget/movie_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/navigator.dart';
import 'package:movieowski/src/utils/ui_utils.dart';
import 'package:date_format/date_format.dart';

class PersonDetailsPage extends StatefulWidget {
  final Person person;
  final String posterHeroTag;

  PersonDetailsPage({Key key, this.person, this.posterHeroTag})
      : assert(person != null),
        super(key: key);

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  static const int boardingTimerOffsetMills = 600;
  static const int gradientHeightAnimationDurationMills = 300;
  static const int titleAndBackButtonOpacityAnimationDurationMills = 1400;
  static const double defaultGradientHeightAfterBorder = kToolbarHeight + 60;

  PersonDetailsPageBloc _bloc;
  Timer boardingTimer;

  double gradientHeight;
  double titleAndBackButtonOpacity;

  @override
  void initState() {
    _bloc = BlocProvider.of<PersonDetailsPageBloc>(context);
    _bloc.dispatch(FetchPersonDetails());
    gradientHeight = 0.0;
    titleAndBackButtonOpacity = 0.0;

    boardingTimer = Timer(const Duration(milliseconds: boardingTimerOffsetMills), () {
      setState(() {
        gradientHeight = defaultGradientHeightAfterBorder;
        titleAndBackButtonOpacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    boardingTimer?.cancel();
    super.dispose();
  }

  /// Calculate font size for title based on appbar collapse percent 100% => 24.0, 0% => 16.0
  double _calculateAppBarTitleFontSize(double percent) => 16.0 + 8.0 / 100 * percent;

  /// Calculate bottom padding for title based on appbar collapse percent 100% => 8.0, 0% => 18.0
  double _calculateAppBarTitleBottomPadding(double percent) => 18.0 - 8.0 / 100 * percent;

  @override
  Widget build(BuildContext context) {
    var profileImage = Hero(
      tag: widget.posterHeroTag,
      transitionOnUserGestures: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black87,
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        child: (widget.person.profilePath != null && widget.person.profilePath.isNotEmpty)
            ? Image.network(
                '${TmdbApiProvider.BASE_IMAGE_URL_W500}${widget.person.profilePath}',
                fit: BoxFit.fitHeight,
              )
            : Image.asset('assets/person_placeholder.jpg', fit: BoxFit.fitHeight),
      ),
    );

    var backButton = AnimatedOpacity(
      opacity: titleAndBackButtonOpacity,
      duration: Duration(milliseconds: titleAndBackButtonOpacityAnimationDurationMills),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 6.0, top: kStatusBarHeight + 10.0),
          child: Icon(
            Icons.keyboard_arrow_left,
            size: 36.0,
            color: AppColors.primaryWhite,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: MediaQuery.of(context).size.width + kToolbarHeight,
                  floating: false,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                    double collapsePercent =
                        ((constraints.maxHeight - kToolbarHeight) * 100 / (MediaQuery.of(context).size.width));
                    return Stack(
                      children: <Widget>[
                        FlexibleSpaceBar(
                            centerTitle: true,
                            background: Material(
                              color: AppColors.primaryColor,
                              child: profileImage,
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedContainer(
                            height: gradientHeight,
                            duration: Duration(milliseconds: gradientHeightAnimationDurationMills),
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  collapsePercent >= 10 ? Colors.transparent : AppColors.primaryColor,
                                  collapsePercent >= 30
                                      ? AppColors.primaryColorHalfTransparent
                                      : AppColors.primaryColor,
                                  AppColors.primaryColor,
                                ],
                              )),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedOpacity(
                            opacity: titleAndBackButtonOpacity,
                            duration: Duration(milliseconds: titleAndBackButtonOpacityAnimationDurationMills),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: _calculateAppBarTitleBottomPadding(collapsePercent)),
                              child: Text(widget.person.name,
                                  style: Theme.of(context).textTheme.headline.copyWith(
                                      color: AppColors.primaryWhite,
                                      fontSize: _calculateAppBarTitleFontSize(collapsePercent))),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: backButton,
                        ),
                      ],
                    );
                  }),
                ),
              ];
            },
            body: BlocBuilder(
              bloc: _bloc,
              builder: (context, PersonDetailsPageState state) {
                if (state is PersonDetailsIsEmpty || state is PersonDetailsIsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is PersonDetailsIsLoaded) {
                  return ScrollConfiguration(
                    behavior: NoGlowBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          state.details.biography != null
                              ? createBasicTitleSubtitleSection(context, '', state.details.biography)
                              : SizedBox,
                          state.details.birthday != null
                              ? createBasicTitleSubtitleSection(context, 'Birthday',
                                  formatDate(DateTime.parse(state.details.birthday), [d, ' ', M, ', ', yyyy]))
                              : SizedBox(),
                          state.details.placeOfBirth != null
                              ? createBasicTitleSubtitleSection(context, 'Place of Birth', state.details.placeOfBirth)
                              : SizedBox(),
                          widget.person.knownFor != null
                              ? createBasicTitleSubtitleSection(context, 'Known for', '')
                              : SizedBox(),
                          widget.person.knownFor != null
                              ? _createPersonRelatedMoviesSection(widget.person.knownFor)
                              : SizedBox(),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Text(
                    'Error occured while trying to get this person info :(',
                    style: Theme.of(context).textTheme.headline.copyWith(color: AppColors.primaryWhite),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPersonRelatedMoviesSection(List<Movie> movies) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 224.3,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          String cardHeroTag = 'card${this.hashCode}${movies[index].id}';
          String ratingHeroTag = 'rating${this.hashCode}${movies[index].id}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: GestureDetector(
              onTap: () => goToMovieDetails(context, _bloc.moviesRepository, movies[index], cardHeroTag, ratingHeroTag),
              child: (movies[index].posterPath != null && movies[index].posterPath != '')
                  ? MovieCard(
                      withRating: false,
                      withHero: true,
                      imageHeroTag: cardHeroTag,
                      ratingHeroTag: ratingHeroTag,
                      posterPath: movies[index].posterPath,
                    )
                  : SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
