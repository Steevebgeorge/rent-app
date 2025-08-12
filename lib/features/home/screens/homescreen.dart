import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/home/blocs/hotels/bloc/hotels_bloc.dart';
import 'package:rent_app/common/blocs/user/bloc/user_bloc.dart';
import 'package:rent_app/features/hotel%20details/screens/detailsscreen.dart';
import 'package:rent_app/features/maps/screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> _filteredHotels = [];

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUserData());
    context.read<HotelsBloc>().add(FetchHotels());

    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {},
      builder: (context, state) {
        String username = 'Guest';
        String location = 'Unknown';

        if (state is UserLoaded) {
          username = state.user.username;
          location = state.user.location;
        } else if (state is UserLoading) {
          username = 'Loading...';
          location = 'Loading..';
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 3,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    username,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.pin_drop, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ));
                },
                icon: const Icon(Icons.search),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_active),
              ),
              const SizedBox(width: 15),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: bannerCarousel(size),
              ),
              SizedBox(height: size.height * 0.02),
              searchTextField(context),
              SizedBox(height: size.height * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular Places',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              BlocBuilder<HotelsBloc, HotelsState>(
                builder: (context, state) {
                  if (state is HotelLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HotelLoaded) {
                    final query = _searchController.text.toLowerCase();
                    final hotels = state.loadedHotelData;

                    _filteredHotels = query.isEmpty
                        ? hotels
                        : hotels.where((hotel) {
                            return hotel.name.toLowerCase().contains(query) ||
                                hotel.location.toLowerCase().contains(query);
                          }).toList();

                    return Column(
                      children: _filteredHotels.map((hotel) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  HotelDetailsScreen(snap: hotel),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: AnotherCarousel(
                                      images: hotel.images.map<Widget>((url) {
                                        return CachedNetworkImage(
                                            imageUrl: url,
                                            fit: BoxFit.cover,
                                            width: double.infinity);
                                      }).toList(),
                                      dotSize: 6.0,
                                      dotSpacing: 15.0,
                                      dotColor: Colors.grey.shade400,
                                      indicatorBgPadding: 5.0,
                                      autoplay: false,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 22, top: 10),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Theme.of(context).cardColor
                                        : Colors.grey[100],
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            hotel.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.pin_drop_rounded,
                                              size: 18,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              hotel.location,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                            ),
                                            const Spacer(),
                                            RichText(
                                              text: TextSpan(
                                                text: '₹${hotel.price.toInt()}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                        color: Colors.lightBlue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                    text: '\nPer Night',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 17,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              hotel.rating.toString(),
                                              style:
                                                  const TextStyle(fontSize: 17),
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
                      }).toList(),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget searchTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
          hintText: 'Search by name or location',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  CarouselSlider bannerCarousel(Size size) {
    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.2,
        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction: 1,
        autoPlayInterval: const Duration(seconds: 3),
      ),
      items: [
        'https://img.freepik.com/free-vector/gradient-hotel-banner-template-with-photo_23-2148923637.jpg',
        'https://img.freepik.com/premium-psd/digital-market…-design-cover-post-template_572938-105.jpg?w=1380',
        'https://theincentivist.com/wp-content/uploads/2025/06/June2025-Melia-972x321-1.gif',
        'https://milelion.com/wp-content/uploads/2024/01/multi-stay-promo-20-2.jpg',
      ].map((url) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: size.height * 0.2,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
