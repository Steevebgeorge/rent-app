import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/auth/bloc/auth_bloc.dart';
import 'package:rent_app/features/booking%20checkout/bloc/stripe_payment_bloc.dart';
import 'package:rent_app/features/bookings/blocs/fetchbookings/bloc/fetchbookings_bloc.dart';
import 'package:rent_app/features/confirmbooking/bloc/confirm_booking_bloc.dart';
import 'package:rent_app/features/home/blocs/hotels/bloc/hotels_bloc.dart';
import 'package:rent_app/common/blocs/user/bloc/user_bloc.dart';
import 'package:rent_app/features/hotel%20details/blocs/review%20fetch%20bloc/hotelreviews_bloc.dart';
import 'package:rent_app/features/hotel%20details/blocs/review%20save%20bloc/bloc/savereview_bloc.dart';

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
        BlocProvider(create: (_) => HotelreviewsBloc()),
        BlocProvider(create: (_) => SavereviewBloc()),
        BlocProvider(create: (_) => StripePaymentBloc()),
        BlocProvider(create: (_) => ConfirmBookingBloc()),
        BlocProvider(create: (_) => FetchbookingsBloc())
      ],
      child: const MyApp(),
    );
  }
}
