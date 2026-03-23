import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/portfolio_data.dart';

class PortfolioRepository {
  static Future<PortfolioData> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/portfolio.json',
    );
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return PortfolioData.fromJson(jsonMap);
  }
}
