import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/pages/splash_screen.dart';
import 'core/api/api.dart';
import 'core/bloc/provider.dart';
import 'core/theme/theme.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(url: Api.baseUrl, anonKey: Api.anonKey);
  await initializeServiceLocator();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID');
    return MultiBlocProvider(
      providers: Provider.providers(),
      child: MaterialApp(
        title: 'LaporMin!',
        debugShowCheckedModeBanner: false,
        theme: MaterialTheme(const TextTheme()).light(),
        home: const FieldOfficerMainLayout(),
      ),
    );
  }
}

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text("Appbar")),
      body: Column(
        children: [
          Text(
            "Hello World",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color.primary,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur.",
          ),
        ],
      ),
    );
  }
}
