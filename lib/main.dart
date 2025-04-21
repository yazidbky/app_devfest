import 'package:app_devfest/cubit/Registre%20Cubit/registre_cubit.dart';
import 'package:app_devfest/cubit/addFiles%20cubit/addFilesCubit.dart';
import 'package:app_devfest/cubit/confirmation%20cubit/confirmationCubit.dart';
import 'package:app_devfest/login/loginScreen.dart';
import 'package:app_devfest/registration_of_assurance/plans/selectedOptionsCubit.dart';
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
        BlocProvider(create: (_) => AddFilesCubit()),
        BlocProvider(create: (_) => SelectedOptionsCubit()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginScreen(),
      ),
    );
  }
}
