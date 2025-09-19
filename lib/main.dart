import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:questa/modules/c_store.dart';
import 'package:questa/view/app_setup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CStore.inst.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppSetup().animate().fadeIn());
}
