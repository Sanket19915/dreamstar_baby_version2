// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class _FourQuotientsState extends State<FourQuotients> {
//   Map<String, bool> quotientStatuses = {};
//
//   @override
//   void initState() {
//     super.initState();
//     fetchQuotientStatuses();
//   }
//
//   Future<void> fetchQuotientStatuses() async {
//     var headers = {'Authorization': '••••••'};
//     var request = http.Request(
//         'GET', Uri.parse('http://dreambaby.pro/api/user-question-status'));
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       final responseData = await response.stream.bytesToString();
//       final data = json.decode(responseData);
//       final statuses = data['statuses'] as Map<String, dynamic>;
//
//       setState(() {
//         quotientStatuses =
//             statuses.map((key, value) => MapEntry(key, value as bool));
//       });
//     } else {
//       print(response.reasonPhrase);
//     }
//   }
// }
