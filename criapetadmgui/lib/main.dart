import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app.dart';
import 'providers.dart';

void main() {
  setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: providers,
      child: const App(),
    ),
  );
}
