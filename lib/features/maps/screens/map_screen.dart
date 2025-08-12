import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rent_app/features/home/blocs/hotels/bloc/hotels_bloc.dart';
import 'package:rent_app/features/home/models/hotelmodel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _locationController = Location();
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  List<HotelModel> _hotels = [];
  LatLng? _currentPosition;
  HotelModel? _selectedHotel; // Store the tapped hotel

  @override
  void initState() {
    super.initState();
    getLocation();
    context.read<HotelsBloc>().add(FetchHotels());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HotelsBloc, HotelsState>(
        builder: (context, state) {
          if (state is HotelLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  _moveToCurrentLocation();
                },
                markers: _markers,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition ?? const LatLng(15.2993, 74.124),
                  zoom: _currentPosition != null ? 14 : 5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (_) {
                  setState(() {
                    _selectedHotel = null; // Hide the card
                  });
                },
              ),

              // Overlay Carousel when a hotel is selected
              if (_selectedHotel != null)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _buildHotelCard(_selectedHotel!),
                  ),
                ),
            ],
          );
        },
        listener: (context, state) async {
          if (state is HotelLoaded) {
            _hotels = state.loadedHotelData;

            final hotelMarkers = _hotels.map((hotel) {
              return Marker(
                markerId: MarkerId(hotel.uid),
                position: LatLng(hotel.latitude, hotel.longitude),
                onTap: () {
                  setState(() {
                    _selectedHotel = hotel;
                  });
                },
              );
            }).toSet();

            setState(() => _markers = hotelMarkers);
          }
        },
      ),
    );
  }

  Widget _buildHotelCard(HotelModel hotel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Carousel
          if (hotel.images.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 180,
                viewportFraction: 1.0,
                autoPlay: true,
              ),
              items: hotel.images.map((imgUrl) {
                return ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),

          // Hotel Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hotel.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(hotel.location,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star),
                    Text(hotel.rating.toString(),
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final locationData = await _locationController.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
      setState(() {});
    }

    _locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        _currentPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        setState(() {});
      }
    });
  }

  void _moveToCurrentLocation() {
    if (_currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition!, 14),
      );
    }
  }
}
