import 'package:app_devfest/api/get%20policy/getpolicy_id_api.dart';
import 'package:app_devfest/api/get%20vehicle%20by%20user/get_vehicle_byuser.dart';
import 'package:app_devfest/api/payment/payment_api_service.dart';
import 'package:app_devfest/cubit/Login%20Cubit/login_cubit.dart';
import 'package:app_devfest/cubit/Registre%20Cubit/registre_cubit.dart';
import 'package:app_devfest/cubit/claim%20cubit/claim_cubit.dart';
import 'package:app_devfest/cubit/get%20policy%20id%20cubit/get_policy_id_cubit.dart';
import 'package:app_devfest/cubit/get%20vehicle%20id/get_vehicle_id_cubit.dart';
import 'package:app_devfest/cubit/notification%20cubit/notifictation_cubit.dart';
import 'package:app_devfest/cubit/payment%20cubit/payment_cubit.dart';
import 'package:app_devfest/cubit/plans%20cubit/plansCubit.dart';
import 'package:app_devfest/cubit/vehicle%20cubit/vehicleCubit.dart';
import 'package:app_devfest/cubit/confirmation%20cubit/confirmationCubit.dart';
import 'package:app_devfest/login/loginScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Global variable to hold the list of cameras
late List<CameraDescription> cameras;

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the cameras
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error initializing cameras: $e');
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => IdentityConfirmationCubit()),
        BlocProvider(create: (_) => VehicleCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => InsuranceCubit()),
        BlocProvider(create: (_) => GetVehicleIdCubit(GetVehicleByUser())),
        BlocProvider(create: (_) => PaymentCubit(PaymentApiService())),
        BlocProvider(
          create: (_) => ClaimCubit(),
        ),
        BlocProvider(create: (_) => NotificationCubit()),
        BlocProvider<GetVehicleIdCubit>(
          create: (context) => GetVehicleIdCubit(GetVehicleByUser()),
        ),
        BlocProvider<GetPolicyCubit>(
          create: (context) => GetPolicyCubit(GetPolicyById()),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginScreen(),
      ),
    );
  }
}
