import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/constants/constants.dart';
import 'package:rent_app/features/auth/bloc/auth_bloc.dart';
import 'package:rent_app/features/auth/screens/signin_screen.dart';
import 'package:rent_app/features/auth/widgets/inputbox.dart';
import 'package:rent_app/features/home/screens/tabcontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
      body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
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
                    SizedBox(height: size.height * 0.04),
                    GestureDetector(
                      onTap: () {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        context.read<AuthBloc>().add(
                            LoginRequested(email: email, password: password));
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
                          'Login',
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
                    const Text('I forgot my password'),
                    SizedBox(height: size.height * 0.13),
                    GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<AuthBloc>(),
                                child: const SignInScreen(),
                              ),
                            )),
                        child: const Text('Dont have an account? Register')),
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
      )),
    );
  }
}
