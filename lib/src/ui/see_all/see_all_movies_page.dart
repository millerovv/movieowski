import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/genres/movie_genres_section_bloc_export.dart';
import 'package:movieowski/src/blocs/see_all_page/movie_list_bloc_export.dart';
import 'package:movieowski/src/model/api/response/base_movies_response.dart';
import 'package:movieowski/src/model/api/response/movie_genres_response.dart';
import 'package:movieowski/src/ui/widget/movie_list_card.dart';
import 'package:movieowski/src/utils/consts.dart';
import 'package:movieowski/src/utils/ui_utils.dart';

class _GenreListItem {
  _GenreListItem(this.genre, this.selected);

  final Genre genre;

  bool selected;
}

class GenresView extends StatefulWidget {
  GenresView({this.selectedGenreIds, this.onChosenGenresUpdate});

  final Set<int> selectedGenreIds;
  final Function(Set<Genre>) onChosenGenresUpdate;

  @override
  _GenresViewState createState() => _GenresViewState();
}

class _GenresViewState extends State<GenresView> {
  MovieGenresSectionBloc _bloc;
  Set<int> selectedItemsIds;
  Set<Genre> selectedGenres;

  @override
  void initState() {
    _bloc = BlocProvider.of<MovieGenresSectionBloc>(context);
    selectedItemsIds = widget.selectedGenreIds ?? Set();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkerPrimary,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, MovieGenresSectionState state) {
          if (state is MovieGenresIsLoaded) {
            List<_GenreListItem> listItems = state.genres
                .map((genre) => _GenreListItem(genre, selectedItemsIds.contains(genre.id) ? true : false))
                .toList();
            selectedGenres ??= listItems.where((item) => item.selected).map((item) => item.genre).toSet();
            return ListView.builder(
              itemCount: state.genres.length,
              itemBuilder: (context, index) {
                _GenreListItem item = listItems[index];
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 16.0 : 0.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (item.selected) {
                          selectedItemsIds.remove(item.genre.id);
                          selectedGenres.remove(item.genre);
                        } else {
                          selectedItemsIds.add(item.genre.id);
                          selectedGenres.add(item.genre);
                        }
                        widget.onChosenGenresUpdate(selectedGenres);
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: item.selected ? AppColors.accentColor : AppColors.lighterPrimary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Center(
                          child: Text(item.genre.name,
                              style: Theme.of(context).textTheme.subhead.copyWith(color: AppColors.primaryWhite)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

/// View on the front with long list of movies that fit requested genres
class MovieListView extends StatefulWidget {
  MovieListView({Key key, this.genres = const []}) : super(key: key);

  final List<Genre> genres;

  @override
  MovieListViewState createState() => MovieListViewState();
}

class MovieListViewState extends State<MovieListView> {
  MovieListBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<MovieListBloc>(context);
    _bloc.dispatch(FetchMovies(genres: widget.genres));
    super.initState();
  }

  void reloadMovies({List<Genre> newGenres = const []}) {
    _bloc.dispatch(FetchMoviesWithReset(genres: newGenres));
  }

  Widget _buildMovieCard(List<Movie> movies, List<Genre> genres, int index, bool canLoadMoreMovies) {
    if (index >= movies.length) {
      if (canLoadMoreMovies) {
        _bloc.dispatch(FetchMovies(genres: widget.genres));
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        return SizedBox();
      }
    }

    Movie movie = movies[index];
    if (movie == null) {
      return SizedBox();
    }

    String matchingGenres = genres
        .where((genre) => movie.genreIds.contains(genre.id))
        .map((genre) => genre.name)
        .toList()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');

    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: (index == 0) ? 0.0 : 8.0,
        bottom: (index == movies.length - 1) ? 16.0 : 0,
      ),
      child: GestureDetector(
        child: MovieListCard(
          posterPath: movie.posterPath,
          rating: movie.voteAverage,
          title: movie.title,
          releaseYear: movie.releaseDate.split('-')[0],
          genres: matchingGenres,
          withHero: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: BlocBuilder(
        bloc: _bloc,
        builder: (context, MovieListState state) {
          if (state is MoviesEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PagesLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Couldn\'t find any movies matching chosen genres',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title.copyWith(color: AppColors.primaryWhite),
                  ),
                ),
              );
            }
            return ListView.builder(
                itemCount: (state.movies == null) ? 0 : state.movies.length + (state.allPagesLoaded ? 0 : 1),
                itemBuilder: (context, index) {
                  return _buildMovieCard(state.movies, state.movieGenres, index, state.allPagesLoaded);
                });
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Error occured while trying to fetch movies from server :(',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline.copyWith(color: AppColors.primaryWhite),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class BackdropPanel extends StatelessWidget {
  BackdropPanel({
    Key key,
    this.title,
    this.subTitle,
    this.onMenuButtonClick,
    this.menuButtonAnimation,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.chosenGenres = const [],
    this.movieListKey,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final Listenable menuButtonAnimation;
  final VoidCallback onMenuButtonClick;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final List<Genre> chosenGenres;
  final GlobalKey<MovieListViewState> movieListKey;

  Widget _createAppBar(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 32.0,
                    color: AppColors.primaryWhite,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                  ),
                  subTitle != null && subTitle.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            subTitle,
                            style: Theme.of(context).textTheme.caption.copyWith(color: AppColors.primaryWhite),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              GestureDetector(
                onTap: onMenuButtonClick,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    semanticLabel: 'close',
                    progress: menuButtonAnimation,
                    size: 24.0,
                    color: AppColors.primaryWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  height: kToolbarHeight,
                  child: GestureDetector(
                    onVerticalDragUpdate: onVerticalDragUpdate,
                    onVerticalDragEnd: onVerticalDragEnd,
                    child: _createAppBar(context),
                  ),
                ),
              ),
            ];
          },
          body: MovieListView(
            key: movieListKey,
            genres: chosenGenres,
          ),
        ),
      ),
    );
  }
}

enum SeeAllMoviesType { IN_THEATRES, UPCOMING, POPULAR, SEARCH_RESULTS }

class SeeAllMoviesPage extends StatefulWidget {
  SeeAllMoviesPage({Key key, @required this.moviesType, this.chosenGenre, this.firstPageMovies, this.maxPages})
      : assert(moviesType != null),
        super(key: key);

  final SeeAllMoviesType moviesType;
  final Genre chosenGenre;
  final List<Movie> firstPageMovies;
  final int maxPages;

  @override
  _SeeAllMoviesPageState createState() => _SeeAllMoviesPageState();
}

class _SeeAllMoviesPageState extends State<SeeAllMoviesPage> with SingleTickerProviderStateMixin {
  static const int animationDuration = 300;
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  final GlobalKey<MovieListViewState> _movieListViewKey = GlobalKey<MovieListViewState>();
  AnimationController _controller;
  MovieListBloc _movieListBloc;
  Set<Genre> chosenGenres;

  @override
  void initState() {
    _controller = AnimationController(duration: const Duration(milliseconds: animationDuration), vsync: this);
    chosenGenres = widget.chosenGenre == null ? Set() : {widget.chosenGenre};
    _movieListBloc = BlocProvider.of<MovieListBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _movieListBloc.dispose();
    super.dispose();
  }

  bool get _backdropPanelFolded {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed;
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _toggleBackdropPanelFolding() {
    _backdropPanelFolded ? _controller.reverse() : _controller.forward();
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.dismissed) return;

    _controller.value += details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.dismissed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity > 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity < 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  String _createBackdropTitle() {
    switch (widget.moviesType) {
      case SeeAllMoviesType.IN_THEATRES:
        return 'In theatres';
        break;
      case SeeAllMoviesType.UPCOMING:
        return 'Upcoming';
        break;
      case SeeAllMoviesType.POPULAR:
        return 'Popular in';
        break;
      case SeeAllMoviesType.SEARCH_RESULTS:
        return 'Search results for';
        break;
      default:
        return '';
        break;
    }
  }

  String _createBackdropSubtitle() {
    switch (widget.moviesType) {
      case SeeAllMoviesType.IN_THEATRES:
      case SeeAllMoviesType.UPCOMING:
      case SeeAllMoviesType.POPULAR:
        String subTitle =
            chosenGenres.map((genre) => genre.name).take(4).toList().toString().replaceAll('[', '').replaceAll(']', '');
        if (chosenGenres.length > 4) {
          subTitle += ' and ${chosenGenres.length - 4} others';
        }
        return subTitle;
        break;
      case SeeAllMoviesType.SEARCH_RESULTS:
        return '_QUERY_';
        break;
      default:
        return '';
        break;
    }
  }

  void _handleChosenGenresUpdate(Set<Genre> genres) {
    setState(() {
      chosenGenres = genres;
    });
    _movieListViewKey.currentState?.reloadMovies(newGenres: chosenGenres.toList());
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final Animation<double> scaffoldPositionOffsetFromTop = Tween<double>(
      begin: kStatusBarHeight,
      end: MediaQuery.of(context).size.height - kToolbarHeight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Stack(
              key: _backdropKey,
              children: <Widget>[
                Container(
                  child: GenresView(
                    selectedGenreIds: {widget.chosenGenre?.id},
                    onChosenGenresUpdate: _handleChosenGenresUpdate,
                  ),
                ),
                AnimatedContainer(
                  height: kStatusBarHeight,
                  duration: Duration(milliseconds: animationDuration),
                  color: _controller.status != AnimationStatus.dismissed
                      ? AppColors.darkerPrimary
                      : AppColors.primaryColor,
                ),
                Positioned(
                  top: scaffoldPositionOffsetFromTop.value,
                  child: Container(
                    height: MediaQuery.of(context).size.height - kStatusBarHeight,
                    width: MediaQuery.of(context).size.width,
                    child: BackdropPanel(
                      title: _createBackdropTitle(),
                      subTitle: _createBackdropSubtitle(),
                      onMenuButtonClick: _toggleBackdropPanelFolding,
                      menuButtonAnimation: _controller.view,
                      onVerticalDragUpdate: _handleDragUpdate,
                      onVerticalDragEnd: _handleDragEnd,
                      chosenGenres: chosenGenres.toList(),
                      movieListKey: _movieListViewKey,
                    ),
                  ),
                ),
              ],
            ));
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}
