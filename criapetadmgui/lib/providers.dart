import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

final providers = [
  ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
  ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
];
