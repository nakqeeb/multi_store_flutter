import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/review.dart';
import 'package:multi_store_app/providers/review_provider.dart';
import 'package:multi_store_app/screens/product_details/components/collapsed_reviews.dart';
import 'package:multi_store_app/screens/product_details/components/expanded_reviews.dart';
import 'package:provider/provider.dart';

import '../../error/error_screen.dart';

class ShowReviews extends StatefulWidget {
  final String productId;
  const ShowReviews({super.key, required this.productId});

  @override
  State<ShowReviews> createState() => _ShowReviewsState();
}

class _ShowReviewsState extends State<ShowReviews> {
  Future<List<Review>>? _futureReviews;

  @override
  void initState() {
    _futureReviews = Provider.of<ReviewProvider>(context, listen: false)
        .fetchReviewsByProductId(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureReviews,
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitDoubleBounce(
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const ErrorScreen(
                  title: 'Opps! Something went wrong',
                  subTitle: 'Please try to reload the application!');
            } else if (snapshot.data!.isNotEmpty) {
              double averageRating = 0.0;
              for (var review in snapshot.data!) {
                averageRating += (review.rating!) / snapshot.data!.length;
              }
              return ExpandablePanel(
                header: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                collapsed: CollapsedReviews(
                    reviews: snapshot.data!
                        .where((element) => element.comment != null)
                        .take(3)
                        .toList()),
                expanded: ExpandedReviews(
                    reviews: snapshot.data!
                        .where((element) => element.comment != null)
                        .toList()),
              );
            } else if (snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Center(
                  child: Text(
                    'This product has not been reviewed yet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme',
                        letterSpacing: 1.5),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No ratings loaded!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Acme',
                      letterSpacing: 1.5),
                ),
              );
            }
          } else {
            return Center(child: Text('State: ${snapshot.connectionState}'));
          }
        });
  }
}
