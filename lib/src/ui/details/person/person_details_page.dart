import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieowski/src/blocs/person_details_page/bloc_person_details_page.dart';
import 'package:movieowski/src/model/api/response/popular_people_response.dart';
import 'package:movieowski/src/resources/api/tmdp_api_provider.dart';
import 'package:movieowski/src/utils/consts.dart';

// TODO: add hero animation for appbar https://github.com/flutter/flutter/issues/12518
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
  PersonDetailsPageBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<PersonDetailsPageBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width,
              floating: false,
              pinned: true,
              flexibleSpace: Stack(
                children: <Widget>[
                  FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(widget.person.name,
                          style: Theme.of(context).textTheme.headline.copyWith(color: AppColors.primaryWhite)),
                      background: Image.network(
                        '${TmdbApiProvider.BASE_IMAGE_URL_W500}${widget.person.profilePath}',
                        fit: BoxFit.cover,
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      height: 50,
                      duration: Duration(milliseconds: 300),
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.transparent,
                                AppColors.primaryColorHalfTransparent,
                                AppColors.primaryColor,
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Center(child: Text('hello tought world', style: Theme.of(context).textTheme.subtitle)),
      ),
    );
  }
}
