import 'package:flutter/material.dart';
import 'package:movieowski/src/utils/consts.dart';

class MovieListCard extends StatelessWidget {
	final String posterPath;
	final double rating;

	MovieListCard({Key key, this.posterPath, this.rating}) : super(key: key);

	@override
  Widget build(BuildContext context) {
    return Container(
	    height: 108,
	    decoration: BoxDecoration(
		    color: AppColors.lighterPrimary,
		    boxShadow: <BoxShadow>[
			    BoxShadow(
				    color: Colors.black87,
				    offset: Offset(1.0, 1.0),
				    blurRadius: 2.0,
			    ),
		    ],
	    ),
//	    child: ,
    );
  }
}
