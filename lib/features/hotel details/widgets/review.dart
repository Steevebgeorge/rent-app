import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rent_app/features/hotel%20details/blocs/review%20fetch%20bloc/hotelreviews_bloc.dart';
import 'package:rent_app/features/hotel%20details/widgets/addreviewsheet.dart';

class ReviewSection extends StatefulWidget {
  final String hotelId;
  const ReviewSection({
    super.key,
    required this.hotelId,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    getCurrentUserName();
  }

  void getCurrentUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('app_Users').doc(uid).get();
    setState(() {
      _userName = doc.data()?['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelreviewsBloc, HotelreviewsState>(
      builder: (context, state) {
        if (state is HotelreviewsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HotelreviewsLoadingError) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is HotelreviewsFetched) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'User Reviews',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: _userName == null
                        ? null
                        : () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => AddReviewModelSheet(
                                hotelId: widget.hotelId,
                                userName: _userName!,
                              ),
                            );
                          },
                    icon: const Icon(Icons.add_circle_outline_sharp),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (state.reviews.isEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Text(
                    'No reviews available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: state.reviews.map((review) {
                      return Container(
                        width: 250,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 5),
                                Text(review.rating.toString()),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(review.comment),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(review.createdAt.toDate().toLocal()),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
