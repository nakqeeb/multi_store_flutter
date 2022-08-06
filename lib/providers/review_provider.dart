import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_store_app/models/review.dart';

import '../models/http_exception.dart';
import '../utilities/global_variables.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  final String? authToken;

  ReviewProvider(
    this.authToken,
    this._reviews,
  );

  List<Review> get reviews {
    return [..._reviews];
  }

  Future<void> addReview(Map review) async {
    final url = Uri.http(API_URL, '/reviews');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${authToken!}',
        },
        body: json.encode(review),
      );
      if (response.statusCode >= 400) {
        notifyListeners();
        throw HttpException('Could not place Order.');
      }
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<List<Review>> fetchReviewsByProductId(String productId) async {
    final url = Uri.http(API_URL, '/reviews/$productId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-type': 'application/json',
        },
      );
      var responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      final List<Review> loadedReviews = [];
      responseData['reviews'].forEach((reviewData) {
        loadedReviews.add(Review.fromJson(reviewData));
      });
      _reviews = loadedReviews;
      notifyListeners();
      return loadedReviews; // return it to use this method in Future.builder()
    } catch (err) {
      throw err;
    }
  }
}
