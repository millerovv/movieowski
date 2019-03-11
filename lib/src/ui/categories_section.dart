import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_event.dart';
import 'package:movieowski/src/blocs/home_page/genres/bloc_movie_genres_section_state.dart';
import 'package:movieowski/src/utils/consts.dart';

class CategoriesSection extends StatefulWidget {
  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  MovieGenresSectionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MovieGenresSectionBloc>(context);
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0),
          child: Text('Categories', style: Theme.of(context).textTheme.headline),
        ),
        BlocBuilder<MovieGenresSectionEvent, MovieGenresSectionState>(
          bloc: _bloc,
          builder: (BuildContext context, MovieGenresSectionState state) {
            if (state is MovieGenresIsEmpty) {
              return SizedBox();
            } else if (state is MovieGenresError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            } else if (state is MovieGenresIsLoaded) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              width: 700.0,
                              child: Wrap(
                                spacing: 8.0,
                                children: state.genres
                                    .map((genre) => Chip(
                                          backgroundColor: AppColors.accentColor,
                                          padding: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 2.0),
                                          label: Text(
                                            '${GenresEmojis.ge[genre.name.toLowerCase()] ?? '📼'}  ${genre.name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
