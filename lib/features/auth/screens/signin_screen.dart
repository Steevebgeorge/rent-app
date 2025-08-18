import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/features/auth/bloc/auth_bloc.dart';
import 'package:rent_app/features/auth/screens/login_screen.dart';
import 'package:rent_app/features/auth/widgets/inputbox.dart';
import 'package:rent_app/features/home/screens/tabcontroller.dart';
import 'package:rent_app/keys.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final String token = '1234567890';

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  List<dynamic> suggestions = [];
  bool suggestionSelected = false; // ✅ to prevent reopening suggestions

  @override
  void initState() {
    super.initState();
    locationController.addListener(() {
      _onchange();
    });
  }

  _onchange() {
    if (locationController.text.isNotEmpty && !suggestionSelected) {
      placeSuggestion(locationController.text);
    } else {
      setState(() => suggestions.clear());
    }
  }

  Future<void> placeSuggestion(String input) async {
    String apiKey = mapsApi; // replace with your API key
    final String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    final String request =
        "$baseUrl?input=$input&key=$apiKey&sessiontoken=$token";

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        setState(() {
          suggestions = data['predictions'] ?? [];
        });
      } else {
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching suggestions: $e");
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    userNameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _onRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              userName: userNameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              location: locationController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkScaffold : AppColors.lightScaffoldColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Tabcontroller()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is Authloading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),

                    /// Top image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/loginpageimage.png',
                        height: size.height * 0.3,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),

                    /// Email
                    CustomTextField(
                      controller: emailController,
                      isDark: isDark,
                      size: size,
                      labelText: 'Email',
                      icon: Icons.email,
                      isPassword: false,
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// Password
                    CustomTextField(
                      controller: passwordController,
                      isDark: isDark,
                      size: size,
                      labelText: 'Password',
                      icon: Icons.password,
                      isPassword: true,
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// Username
                    CustomTextField(
                      controller: userNameController,
                      isDark: isDark,
                      size: size,
                      labelText: 'Username',
                      icon: Icons.person,
                      isPassword: false,
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// Location
                    CustomTextField(
                      controller: locationController,
                      isDark: isDark,
                      size: size,
                      labelText: 'Location',
                      icon: Icons.pin_drop,
                      isPassword: false,
                    ),

                    /// Location suggestions
                    if (suggestions.isNotEmpty)
                      SizedBox(
                        height: size.height * 0.25,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: suggestions.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  locationController.text =
                                      suggestions[index]["description"];
                                  suggestions.clear(); // ✅ hide suggestions
                                  suggestionSelected =
                                      true; // ✅ stop fetching again
                                });
                                FocusScope.of(context)
                                    .unfocus(); // ✅ close keyboard
                              },
                              title: Text(suggestions[index]["description"]),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: size.height * 0.03),

                    /// Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * .02,
                          ),
                          backgroundColor:
                              isDark ? Colors.grey[600] : Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _onRegister(context),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextColor
                                : AppColors.lightTextColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),

                    /// Go to login
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      ),
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
