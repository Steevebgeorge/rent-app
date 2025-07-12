import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/auth/bloc/auth_bloc.dart';
import 'package:rent_app/features/home/blocs/hotels/bloc/hotels_bloc.dart';
import 'package:rent_app/features/home/blocs/user/bloc/user_bloc.dart';

import 'main.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => HotelsBloc()),
      ],
      child: const MyApp(),
    );
  }
}
