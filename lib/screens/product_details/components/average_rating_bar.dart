import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_store_app/models/review.dart';
import 'package:provider/provider.dart';

import '../../../providers/review_provider.dart';

class AverageRatingBar extends StatefulWidget {
  final String productId;
  const AverageRatingBar({super.key, required this.productId});

  @override
  State<AverageRatingBar> createState() => _AverageRatingBarState();
}

class _AverageRatingBarState extends State<AverageRatingBar> {
  double averageRating = 0.0;
  List<Review> reviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 5), () {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ReviewProvider>(context, listen: false)
          .fetchReviewsByProductId(widget.productId)
          .then((fetchedReviews) {
        reviews = fetchedReviews;
        for (var review in fetchedReviews) {
          averageRating += (review.rating!) / fetchedReviews.length;
        }

        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? SpinKitDancingSquare(
            color: Theme.of(context).colorScheme.secondary,
            size: 25,
          )
        : Row(
            children: [
              RatingBar.builder(
                initialRating: averageRating,
                minRating: 1,
                direction: Axis.horizontal,
                ignoreGestures: true,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 16,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (double value) {},
              ),
              const SizedBox(
                width: 5,
              ),
              Text('${reviews.length} Ratings')
            ],
          );
  }
}
