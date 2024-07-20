import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fetchService.dart';

class CurrencyScreen extends StatefulWidget {
  @override
  _CurrencyScreenState createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  List<Currency> allCurrencies = [];
  List<int> pinnedIndexes = [];
  List<int> unpinnedIndexes = [];
  String lastUpdated = '';
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    loadPreferences();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isFirstLoad = true;
    });
    try {
      var data =
          await FetchService.fetchAndParseData('https://www.tgju.org/currency');

      setState(() {
        allCurrencies = [];
        for (int i = 0; i < data.length; i++) {
          var currencyData = data[i];
          var price = currencyData['price'];
          var change = currencyData['change'];
          var changeValue = parseChangeValue(change);
          var currency = Currency(
            i,
            currencyData['country'],
            currencyData['name'],
            price,
            changeValue,
            getCurrencyEmoji(currencyData['name']),
          );
          allCurrencies.add(currency);
        }
        updateCurrencyLists();
      });

      updateLastUpdatedTime();
      savePreferences();
    } catch (e) {
      print('Error fetching data: $e');
      showErrorDialog('لطفا دوباره امتحان کنید');
    } finally {
      setState(() {
        isFirstLoad = false;
      });
    }
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> pinnedCurrenciesJson = pinnedIndexes
        .map((index) => jsonEncode(allCurrencies[index].toJson()))
        .toList();
    prefs.setStringList('pinnedCurrencies', pinnedCurrenciesJson);
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? pinnedCurrenciesJson =
        prefs.getStringList('pinnedCurrencies');

    if (pinnedCurrenciesJson != null) {
      setState(() {
        pinnedIndexes = [];
        for (var jsonStr in pinnedCurrenciesJson) {
          Currency currency = Currency.fromJson(jsonDecode(jsonStr));
          pinnedIndexes.add(currency.index);
        }
      });
    }
  }

  double parseChangeValue(String change) {
    String sanitizedChange = change.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(sanitizedChange) ?? 0.0;
  }

  void updateCurrencyLists() {
    unpinnedIndexes = List.generate(allCurrencies.length, (index) => index);
    unpinnedIndexes.removeWhere((index) => pinnedIndexes.contains(index));
  }

  void updateLastUpdatedTime() {
    var now = DateTime.now();
    setState(() {
      lastUpdated = '${now.hour}:${now.minute}:${now.second}';
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ارور'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('اوکی'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void togglePinCurrency(int index) {
    setState(() {
      if (pinnedIndexes.contains(index)) {
        pinnedIndexes.remove(index);
      } else {
        pinnedIndexes.add(index);
      }
      updateCurrencyLists();
      savePreferences();
    });
  }

  String _toPersian(String input) {
    String result = "";

    for (var char in input.split('')) {
      switch (char) {
        case '0':
          result += '۰';
          break;
        case '1':
          result += '۱';
          break;
        case '2':
          result += '۲';
          break;
        case '3':
          result += '۳';
          break;
        case '4':
          result += '۴';
          break;
        case '5':
          result += '۵';
          break;
        case '6':
          result += '۶';
          break;
        case '7':
          result += '۷';
          break;
        case '8':
          result += '۸';
          break;
        case '9':
          result += '۹';
          break;
        default:
          result += char;
      }
    }

    return result;
  }

  String _formatPrice(String price) {
    String sanitizedPrice = price.replaceAll(RegExp(r'[^\d.-]'), '');
    double numericPrice = double.tryParse(sanitizedPrice) ?? 0.0;
    double formattedPrice = numericPrice / 10;
    final formatter = NumberFormat('#,###');
    return formatter.format(formattedPrice);
  }

  String getCurrencyEmoji(String name) {
    switch (name.trim()) {
      case 'دلار':
        return '🇺🇸';
      case 'یورو':
        return '🇪🇺';
      case 'درهم امارات':
        return '🇦🇪';
      case 'پوند انگلیس':
        return '🇬🇧';
      case 'لیر ترکیه':
        return '🇹🇷';
      case 'فرانک سوئیس':
        return '🇨🇭';
      case 'یوان چین':
        return '🇨🇳';
      case 'ین ژاپن (100 ین)':
        return '🇯🇵';
      case 'وون کره جنوبی':
        return '🇰🇷';
      case 'دلار کانادا':
        return '🇨🇦';
      case 'دلار استرالیا':
        return '🇦🇺';
      case 'دلار نیوزیلند':
        return '🇳🇿';
      case 'دلار سنگاپور':
        return '🇸🇬';
      case 'روپیه هند':
        return '🇮🇳';
      case 'روپیه پاکستان':
        return '🇵🇰';
      case 'دینار عراق':
        return '🇮🇶';
      case 'پوند سوریه':
        return '🇸🇾';
      case 'افغانی':
        return '🇦🇫';
      case 'کرون دانمارک':
        return '🇩🇰';
      case 'کرون سوئد':
        return '🇸🇪';
      case 'کرون نروژ':
        return '🇳🇴';
      case 'ریال عربستان':
        return '🇸🇦';
      case 'ریال قطر':
        return '🇶🇦';
      case 'ریال عمان':
        return '🇴🇲';
      case 'دینار کویت':
        return '🇰🇼';
      case 'دینار بحرین':
        return '🇧🇭';
      case 'رینگیت مالزی':
        return '🇲🇾';
      case 'بات تایلند':
        return '🇹🇭';
      case 'دلار هنگ کنگ':
        return '🇭🇰';
      case 'روبل روسیه':
        return '🇷🇺';
      case 'منات آذربایجان':
        return '🇦🇿';
      case 'درام ارمنستان':
        return '🇦🇲';
      case 'لاری گرجستان':
        return '🇬🇪';
      case 'سوم قرقیزستان':
        return '🇰🇬';
      case 'سامانی تاجیکستان':
        return '🇹🇯';
      case 'منات ترکمنستان':
        return '🇹🇲';
      default:
        return '🏳️';
    }
  }

  @override
  Widget build(BuildContext context) {
    var now = Jalali.now();
    var formatter = now.formatter;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تومانءء',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                isFirstLoad = false;
              });
              await fetchData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'تاریخ',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          _toPersian(
                              '${formatter.yyyy}/${formatter.mm}/${formatter.dd}'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'آخرین آپدیت',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          _toPersian(lastUpdated),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isFirstLoad
                  ? const SkeletonLoader()
                  : ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        for (var index in pinnedIndexes)
                          CurrencyCard(
                            currency: allCurrencies[index],
                            onPin: () => togglePinCurrency(index),
                            pinned: true,
                            toPersian: _toPersian,
                            formatPrice: _formatPrice,
                          ),
                        for (var index in unpinnedIndexes)
                          CurrencyCard(
                            currency: allCurrencies[index],
                            onPin: () => togglePinCurrency(index),
                            pinned: false,
                            toPersian: _toPersian,
                            formatPrice: _formatPrice,
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) => const Card(
        elevation: 5,
        shadowColor: Colors.black54,
        color: Color(0xFF1C1C1E),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SpinKitThreeBounce(
                color: Colors.grey,
                size: 30.0,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(),
                    SizedBox(height: 8),
                    SkeletonBox(width: 150),
                  ],
                ),
              ),
              Icon(
                Icons.push_pin,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonBox({Key? key, this.width, this.height = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class CurrencyCard extends StatelessWidget {
  final Currency currency;
  final VoidCallback onPin;
  final bool pinned;
  final String Function(String) toPersian;
  final String Function(String) formatPrice;

  const CurrencyCard({
    required this.currency,
    required this.onPin,
    required this.pinned,
    required this.toPersian,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.black54,
      color: const Color(0xFF1C1C1E),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currency.symbol,
                  style: const TextStyle(fontSize: 40),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          currency.name,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: onPin,
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.push_pin,
                              color: pinned ? Colors.yellowAccent : Colors.white,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      currency.code,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${toPersian(formatPrice(currency.price))}',
                  style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: currency.change >= 0 ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${currency.change >= 0 ? '+' : ''}${toPersian(currency.change.toStringAsFixed(1))}%',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Currency {
  final int index;
  final String code;
  final String name;
  String price;
  double change;
  String symbol;

  Currency(
      this.index, this.code, this.name, this.price, this.change, this.symbol);

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'code': code,
      'name': name,
      'price': price,
      'change': change,
      'symbol': symbol,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      json['index'],
      json['code'],
      json['name'],
      json['price'],
      json['change'],
      json['symbol'],
    );
  }
}
