import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';
import 'package:rent_app/features/hotel%20details/blocs/save%20favourite/bloc/save_favourite_bloc.dart';
import 'package:rent_app/features/hotel%20details/screens/detailsscreen.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        centerTitle: true,
      ),
      body: BlocBuilder<SaveFavouriteBloc, SaveFavouriteState>(
        builder: (context, state) {
          if (state is SaveFavouriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SaveFavouriteSuccess) {
            if (state.favourites.isEmpty) {
              return const Center(child: Text('No favourites yet.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.favourites.length,
              itemBuilder: (context, index) {
                final hotelId = state.favourites[index];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Hotels')
                      .doc(hotelId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const SizedBox(
                        height: 120,
                        child: Center(child: Text('Hotel not found')),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final hotel = HotelModel.fromJson(data);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetailsScreen(snap: hotel),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.network(
                                hotel.images.first,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      hotel.location,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${hotel.price}/night',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            context
                                                .read<SaveFavouriteBloc>()
                                                .add(
                                                  RemoveFavouriteEvent(
                                                      hotel.uid),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is SaveFavouriteFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          context.read<SaveFavouriteBloc>().add(LoadFavouritesEvent());
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
