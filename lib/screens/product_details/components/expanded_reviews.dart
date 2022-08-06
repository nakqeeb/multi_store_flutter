import 'package:flutter/material.dart';
import 'package:multi_store_app/models/review.dart';

class ExpandedReviews extends StatelessWidget {
  final List<Review> reviews;
  const ExpandedReviews({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      shrinkWrap:
          true, // very important to avoid error [Vertical viewport was given unbounded height]
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: ListTile(
            leading: SizedBox(
              height: 43,
              width: 43,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: reviews[index].customer?.profileImageUrl == null
                      ? Image.asset(
                          'images/inapp/guest.gif',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: 'images/inapp/guest.gif',
                          placeholderFit: BoxFit.cover,
                          image: reviews[index].customer!.profileImageUrl!,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                ),
              ),
            ),
            title: Text(reviews[index].customer!.name!),
            subtitle: Text(reviews[index].comment!),
            trailing: SizedBox(
              width: 50,
              child: Row(
                children: [
                  const Spacer(),
                  Text(reviews[index].rating.toString()),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
