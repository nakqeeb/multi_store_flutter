import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_store_app/providers/order_provider.dart';
import 'package:multi_store_app/providers/review_provider.dart';
import 'package:provider/provider.dart';

import '../../../components/default_button.dart';
import '../../../models/order.dart';
import '../../../services/utils.dart';

class ReviewWidget extends StatefulWidget {
  final Order order;
  const ReviewWidget({super.key, required this.order});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  double _rate = 3.0;
  String? _comment;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            'Rate this product',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          RatingBar.builder(
            initialRating: _rate,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _rate = rating;
            },
          ),
          TextField(
            onChanged: (value) {
              _comment = value;
            },
            maxLength: 200,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Review',
              hintText: 'Enter your review',
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
              hintStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.5)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          DefaultButton(
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final review = {
                      'productId': widget.order.product!.id,
                      'rating': _rate,
                      'comment': _comment
                    };
                    await reviewProvider.addReview(review);
                    await orderProvider.updateOrderReview(
                        widget.order.id, true);
                    Fluttertoast.showToast(
                      msg: "Thanks! Your review is added.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black.withOpacity(0.8),
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    setState(() {
                      _isLoading = false;
                    });
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context, true);
                    }
                  },
            height: size.height * 0.05,
            width: size.width * 0.8,
            radius: 15,
            color: Theme.of(context).colorScheme.tertiary,
            widget: _isLoading
                ? SpinKitFoldingCube(
                    color: Theme.of(context).colorScheme.secondary,
                    size: 18,
                  )
                : const Text(
                    'Add Review',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1.5),
                  ),
          ),
        ],
      ),
    );
  }
}
