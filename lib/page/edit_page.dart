// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../model/weather_model.dart';

// class TextInput extends ChangeNotifier {
//   String _input1 = '';
//   String _input2 = '';
//   String _input3 = '';
//   String _input4 = '';
//   String _input5 = '';

//   String get input1 => _input1;
//   String get input2 => _input2;
//   String get input3 => _input3;
//   String get input4 => _input4;
//   String get input5 => _input5;

//   void setInput1(String input) {
//     _input1 = input;
//     notifyListeners();
//   }
//   void setInput2(String input) {
//     _input2 = input;
//     notifyListeners();
//   }
//   void setInput3(String input) {
//     _input3 = input;
//     notifyListeners();
//   }
//   void setInput4(String input) {
//     _input4 = input;
//     notifyListeners();
//   }
//   void setInput5(String input) {
//     _input5 = input;
//     notifyListeners();
//   }
// }

// class EditPage extends StatelessWidget {
//   const EditPage({Key? key}) : super(key: key);

//   // Mock data (This part is copied from the weather page) 
//   static WeatherToday todayWeather = WeatherToday(
//     condition: Icons.thunderstorm,
//     temperature: 25,
//     feelLike: 44,
//     pressure: 1013,
//     humidity: 60,
//     precip: 0,
//     wind: WeatherWind(
//       windSpeed: 10,
//       windDirection: 45,
//     ),
//   );

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     final textInput = Provider.of<TextInput>(context);

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text('Edit',
//         style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {Navigator.pushNamed(context, '/second');}, 
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 onChanged: (value) {
//                   textInput.setInput1(value);
//                 },
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   textInput.setInput2(value);
//                 },
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.calendar_today),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   textInput.setInput3(value);
//                 },
//                 maxLines: null, // Allow multiline input
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.playlist_add),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   textInput.setInput4(value);
//                 },
//                 maxLines: null, // Allow multiline input
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.playlist_add_check),
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   textInput.setInput5(value);
//                 },
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.location_on_outlined),
//                   border: OutlineInputBorder(),
//                 ),
//               ),

//               // The weather banner 
//               weatherBanner(context),
//               Container(
//                 color: const Color.fromARGB(255, 161, 255, 210),
//                 width: screenWidth,
//                 height: 40,
//                 child: Container(
//                   margin: const EdgeInsets.all(8.0),
//                   // Dynamic text and color to be add later
//                   child: const Text(
//                     "Safe, low chance of raining: 26%",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               FittedBox(
//                 fit: BoxFit.fitWidth,
//                 child: Image.asset("assets/appimages/Map.png"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // (This part is copied from the weather page) 
//   Widget weatherBanner(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return SizedBox(
//       width: screenWidth - 48,
//       height: 100,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           _weatherBox(
//             screenWidth / 3 - 16,
//             100,
//             customChild: Icon(
//               todayWeather.condition,
//               size: 52,
//             ),
//           ),
//           _weatherBox(
//             screenWidth / 3 - 16,
//             100,
//             title: 'BangKok',
//             subtitle1: '25°C',
//           ),
//           _weatherBox(
//             screenWidth / 3 - 16,
//             100,
//             title: "Sunny",
//             subtitle1: "Humidity: ${todayWeather.humidity.toString()}%",
//             subtitle2: "Precip: ${todayWeather.precip.toString()}%",
//           ),
//         ],
//       ),
//     );
//   }

//   // Roundy box component with title and subtitle
//   // Would display second subtitle or customWidget if provided
//   // Also optionaly take color as parameter
//   // (This part is copied from the weather page) 
//   Widget _weatherBox(
//     double width,
//     double height, {
//     Color? color,
//     double borderRadius = 0,
//     String title = '',
//     String subtitle1 = '',
//     String? subtitle2,
//     Widget? customChild,
//   }) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 161, 255, 210),
//         borderRadius: BorderRadius.circular(borderRadius),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (customChild != null) customChild,
//           if (customChild == null)
//             Column(
//               children: [
//                 if (title.isNotEmpty)
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 if (subtitle1.isNotEmpty)
//                   Text(
//                     subtitle1,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 if (subtitle2 != null && subtitle2.isNotEmpty)
//                   Container(
//                     margin: const EdgeInsets.only(top: 0),
//                     child: Text(
//                       subtitle2,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
// }
