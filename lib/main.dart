import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Supabase.initialize(
  //   url: 'https://placeholder-url.supabase.co',
  //   anonKey: 'placeholder-key',
  // );

  await Supabase.initialize(
    url: 'https://tkieavufntoupiszttre.supabase.co',
    anonKey: 'sb_publishable_x_c-jK9v_APne3cGEVUJRQ_2zLtVXkp',
  );

  await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
