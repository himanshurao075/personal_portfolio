import 'package:flutter/material.dart';

import 'data/portfolio_repository.dart';
import 'theme/app_theme.dart';
import 'ui/portfolio_page.dart';

class HimanshuPortfolioApp extends StatelessWidget {
  const HimanshuPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Himanshu Rav Portfolio',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const PortfolioBootstrap(),
    );
  }
}

class PortfolioBootstrap extends StatelessWidget {
  const PortfolioBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PortfolioRepository.load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load portfolio data.\n${snapshot.error ?? 'Unknown error'}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return PortfolioPage(data: snapshot.requireData);
      },
    );
  }
}
