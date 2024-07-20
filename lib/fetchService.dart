import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

class FetchService {
  FetchService._();

  static Future<List<Map<String, dynamic>>> fetchAndParseData(String url) async {
    try {
      final uniqueUrl = '$url?timestamp=${DateTime.now().millisecondsSinceEpoch}';
      final response = await http.get(
        Uri.parse(uniqueUrl),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
          'Cache-Control': 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );

      if (response.statusCode == 200) {
        print('Data fetched successfully at ${DateTime.now()}');
        return parseData(response.body);
      } else {
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('FetchService fetchAndParseData error: $e');
      return [];
    }
  }

  static List<Map<String, dynamic>> parseData(String html) {
    try {
      final soup = BeautifulSoup(html);

      final tables = soup.findAll('table', class_: 'data-table market-table');
      final list = <Map<String, dynamic>>[];
      for (var table in tables) {
        final items = table.find('tbody')?.findAll('tr');
        if (items == null) continue;
        for (var element in items) {
          final name = element.find('th')?.text;
          final country = element.find('th')?.find('span')?.classes.last.split('-').last;
          final tds = element.findAll('td');
          final price = tds[0].text;
          final changeElement = tds[1].find('span');
          var change = tds[1].text;

          if (changeElement != null && changeElement.classes.contains('low')) {
            change = '-' + change;
          }

          final date = tds[4].text;

          if (name == null || country == null) continue;
          final map = {
            'name': name,
            'country': country,
            'price': price,
            'change': change,
            'date': date,
          };
          list.add(map);
        }
      }
      return list;
    } catch (e) {
      print('FetchService parseData error: $e');
    }
    return [];
  }
}
