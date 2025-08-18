import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rent_app/features/book%20hotels/screens/bookingscreen.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';
import 'package:rent_app/features/hotel%20details/blocs/review%20fetch%20bloc/hotelreviews_bloc.dart';
import 'package:rent_app/features/hotel%20details/blocs/save%20favourite/bloc/save_favourite_bloc.dart';
import 'package:rent_app/features/hotel%20details/widgets/review.dart';

class HotelDetailsScreen extends StatefulWidget {
  final HotelModel snap;
  const HotelDetailsScreen({super.key, required this.snap});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    context
        .read<HotelreviewsBloc>()
        .add(FetchHotelreviews(hotelId: widget.snap.uid));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailPageImageCarousel(snap: widget.snap),
            SizedBox(height: 30),
            nameAndDescription(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: const Color.fromARGB(87, 158, 158, 158),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Facilities',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  FacilitiesContainer(widget: widget, isDark: isDark),
                  SizedBox(height: 10),
                  Divider(),
                  CancelationPolicies(widget: widget),
                  Divider(),
                  SizedBox(height: 10),
                  HouseRulesWidget(widget: widget),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  ReviewSection(
                    hotelId: widget.snap.uid,
                  ), // 👈 Add this line
                  SizedBox(height: 15),

                  SizedBox(
                    width: size.width,
                    height: size.width * 0.5,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.snap.latitude,
                          widget.snap.longitude,
                        ),
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("hotel_location"),
                          position: LatLng(
                            widget.snap.latitude,
                            widget.snap.longitude,
                          ),
                          infoWindow: InfoWindow(title: widget.snap.name),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      gestureRecognizers: <Factory<
                          OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  HostSection(widget: widget),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(widget: widget, size: size),
    );
  }

  Padding nameAndDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.snap.name,
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(widget.snap.location,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 10),
              Text(widget.snap.rating.toString(),
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(width: 30),
              Text('${widget.snap.reviewCount.toString()} Reviews',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              Icon(Icons.info),
              Text('Best Price Guarentee'),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: const Color.fromARGB(88, 158, 158, 158),
          ),
          SizedBox(height: 10),
          Text(
            'Description',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            widget.snap.description,
            maxLines: expanded ? null : 5,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Text(
              expanded ? 'Read less' : 'Read more',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HostSection extends StatelessWidget {
  const HostSection({
    super.key,
    required this.widget,
  });

  final HotelDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Host',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border(
                left:
                    BorderSide(color: const Color.fromARGB(117, 158, 158, 158)),
                right:
                    BorderSide(color: const Color.fromARGB(117, 158, 158, 158)),
                top:
                    BorderSide(color: const Color.fromARGB(117, 158, 158, 158)),
                bottom: BorderSide(
                    color: const Color.fromARGB(117, 158, 158, 158))),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            title: Text(widget.snap.hostName),
            trailing: SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  imageUrl: widget.snap.hostProfileImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HouseRulesWidget extends StatelessWidget {
  const HouseRulesWidget({
    super.key,
    required this.widget,
  });

  final HotelDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'House Rules',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.snap.houseRules.map((rule) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 16)),
                  Expanded(
                    child: Text(
                      rule,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class CancelationPolicies extends StatelessWidget {
  const CancelationPolicies({
    super.key,
    required this.widget,
  });

  final HotelDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cancelation Policies',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            widget.snap.cancellationPolicy,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
          )
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.widget,
    required this.size,
  });

  final HotelDetailsScreen widget;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Price',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹ ${widget.snap.price.round().toString()}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BookingScreen(
                    snap: widget.snap,
                  ),
                ));
              },
              child: Container(
                width: size.width * 0.35,
                height: size.height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text(
                  'Book Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FacilitiesContainer extends StatelessWidget {
  const FacilitiesContainer({
    super.key,
    required this.widget,
    required this.isDark,
  });

  final HotelDetailsScreen widget;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      children: widget.snap.amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 18, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                amenity,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class DetailPageImageCarousel extends StatelessWidget {
  const DetailPageImageCarousel({
    super.key,
    required this.snap,
  });

  final HotelModel snap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 390,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)), // rounded corners
          ),
          clipBehavior: Clip.antiAlias, // ensure child is clipped
          child: ClipRRect(
            child: AnotherCarousel(
              images: snap.images.map((imageUrl) {
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              }).toList(),
              dotSize: 8.0,
              dotSpacing: 12.0,
              dotColor: Colors.grey.shade500,
              dotBgColor: Colors.transparent,
              indicatorBgPadding: 5.0,
              autoplay: false,
            ),
          ),
        ),
        Positioned(
            top: 20,
            left: 25,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(73, 0, 0, 0)),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  )),
            )),
        Positioned(
          top: 20,
          right: 25,
          child: BlocBuilder<SaveFavouriteBloc, SaveFavouriteState>(
            builder: (context, state) {
              bool isFavourite = false;

              if (state is SaveFavouriteSuccess) {
                isFavourite = state.favourites.contains(snap.uid);
              }

              return Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(73, 0, 0, 0),
                ),
                child: IconButton(
                  onPressed: () {
                    if (isFavourite) {
                      context
                          .read<SaveFavouriteBloc>()
                          .add(RemoveFavouriteEvent(snap.uid));
                    } else {
                      context
                          .read<SaveFavouriteBloc>()
                          .add(AddFavouriteEvent(snap.uid));
                    }
                  },
                  icon: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    size: 30,
                    color: isFavourite ? Colors.red : Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(118, 66, 64, 64),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                snap.available ? 'Available' : 'Not Available',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold),
              )),
        )
      ],
    );
  }
}
