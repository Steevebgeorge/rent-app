import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rent_app/common/blocs/user/bloc/user_bloc.dart';
import 'package:rent_app/features/profile%20updating/bloc/bloc/update_profile_bloc.dart';
import 'package:rent_app/keys.dart'; // contains mapsApi

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String sessionToken = ""; // ✅ unique token for API session
  List<dynamic> suggestions = [];
  bool suggestionSelected = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    generateNewSessionToken();

    _locationController.addListener(() {
      // ✅ if user edits after selecting, reset flag
      if (suggestionSelected &&
          _locationController.text.isNotEmpty &&
          suggestions.isEmpty) {
        suggestionSelected = false;
      }

      if (!suggestionSelected && _locationController.text.isNotEmpty) {
        placeSuggestion(_locationController.text);
      } else if (_locationController.text.isEmpty) {
        setState(() => suggestions.clear());
      } else {
        setState(() => suggestions.clear());
      }
    });
  }

  void generateNewSessionToken() {
    // ✅ create random session token for Google API
    sessionToken = Random().nextInt(100000).toString();
  }

  Future<void> placeSuggestion(String input) async {
    final String apiKey = mapsApi; 
    final String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    final String request =
        "$baseUrl?input=$input&key=$apiKey&sessiontoken=$sessionToken";

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print("API Response: $data");
        }
        setState(() {
          suggestions = data['predictions'] ?? [];
        });
      } else {
        if (kDebugMode) {
          print("Google API failed: ${response.body}");
        }
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching suggestions: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<UpdateProfileBloc>().add(OnUpdatePress(
                  email: _emailController.text.trim(),
                  userName: _usernameController.text.trim(),
                  location: _locationController.text.trim()));
              Navigator.of(context).pop();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              width: size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final user = state.user;

              // ✅ only prefill once
              if (_usernameController.text.isEmpty &&
                  _emailController.text.isEmpty &&
                  _locationController.text.isEmpty) {
                _usernameController.text = user.username;
                _emailController.text = user.email;
                _locationController.text = user.location;
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Username",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Enter your username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Email",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Location",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: "Enter your location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (suggestions.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestions.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _locationController.text =
                                    suggestions[index]["description"];
                                suggestions.clear();
                                suggestionSelected = true; // ✅ mark selected
                                FocusScope.of(context).unfocus();
                              });
                            },
                            title: Text(suggestions[index]["description"]),
                          );
                        },
                      ),
                  ],
                ),
              );
            } else if (state is UserLoadError) {
              return Center(child: Text(state.error));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
