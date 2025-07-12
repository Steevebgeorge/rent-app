import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/features/auth/bloc/auth_bloc.dart';
import 'package:rent_app/features/auth/screens/login_screen.dart';
import 'package:rent_app/features/auth/widgets/inputbox.dart';
import 'package:rent_app/features/home/screens/tabcontroller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkScaffold : AppColors.lightScaffoldColor,
      body: SafeArea(child: Builder(builder: (context) {
        return BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: size.height * 0.05),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/images/loginpageimage.png',
                          height: size.height * 0.3,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      CustomTextField(
                        controller: emailController,
                        isDark: isDark,
                        size: size,
                        labelText: 'Email',
                        icon: Icons.email,
                        isPassword: false,
                      ),
                      SizedBox(height: size.height * 0.03),
                      CustomTextField(
                        controller: passwordController,
                        isDark: isDark,
                        size: size,
                        labelText: 'Password',
                        icon: Icons.password,
                        isPassword: true,
                      ),
                      SizedBox(height: size.height * 0.03),
                      CustomTextField(
                          isDark: isDark,
                          size: size,
                          labelText: 'Username',
                          icon: Icons.person,
                          isPassword: false,
                          controller: userNameController),
                      SizedBox(height: size.height * 0.03),
                      CustomTextField(
                          isDark: isDark,
                          size: size,
                          labelText: 'location',
                          icon: Icons.pin_drop,
                          isPassword: false,
                          controller: locationController),
                      SizedBox(height: size.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          final userName = userNameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final location = locationController.text.trim();
                          context.read<AuthBloc>().add(SignUpRequested(
                                userName: userName,
                                email: email,
                                password: password,
                                location: location,
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * .02,
                            horizontal: size.width * 0.2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                isDark ? Colors.grey[500] : Colors.purpleAccent,
                          ),
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
                      GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              )),
                          child: const Text('Already have an account, Login?')),
                    ],
                  ),
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state is Authloading) {
              Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AuthSuccess) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Tabcontroller(),
              ));
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
        );
      })),
    );
  }
}
