import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'View/ProductScreen.dart';
import 'ViewModel/ProductViewModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ürün Yönetimi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductScreen(),
      ),
    );
  }
}
