import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// 🔔 Notification plugin
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final String url =
      "https://novel-ml-based-healthcare-system-for.onrender.com/data";

  int activeIndex = -1;
  String message = "Connecting...";
  String lastAction = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    await Permission.notification.request();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await notificationsPlugin.initialize(settings);

    startFetching();
  }

  void startFetching() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      fetchData();
    });
  }

  // 🚀 FIXED FETCH
  Future<void> fetchData() async {
    try {
      final res = await http.get(Uri.parse(url));

      if (res.statusCode != 200) return;

      final data = json.decode(res.body);

      if (data == null || data["value"] == null) return;

      String raw = data["value"].toString();

      // Example: "2,LEFT-FOOD"
      List parts = raw.split(",");

      if (parts.length < 2) return;

      int movement = int.tryParse(parts[0].trim()) ?? -1;
      String action = parts[1].trim().toLowerCase();

      int index = mapActionToIndex(action, movement);

      print("RAW: $raw");
      print("ACTION: $action → INDEX: $index");

      // 🔔 Notification
      if (action.isNotEmpty && action != lastAction) {
        lastAction = action;

        bool emergency = action.contains("emergency");

        final androidDetails = AndroidNotificationDetails(
          emergency ? 'emergency' : 'normal',
          emergency ? 'Emergency Alerts' : 'Normal Alerts',
          importance: Importance.max,
          priority: Priority.high,
        );

        await notificationsPlugin.show(
          0,
          "Patient Alert",
          action.toUpperCase(),
          NotificationDetails(android: androidDetails),
        );
      }

      if (!mounted) return;

      setState(() {
        activeIndex = index;
        message = getMessage(index);
      });

    } catch (e) {
      if (!mounted) return;
      setState(() => message = "Connection Failed");
    }
  }

  // 🔥 FIXED MAPPING
  int mapActionToIndex(String action, int movement) {

    if (action.contains("emergency")) return 3;
    if (action.contains("restroom")) return 2;
    if (action.contains("food")) return 1;
    if (action.contains("electrical")) return 4;
    if (action.contains("none")) return 0;

    // fallback
    if (movement >= 0 && movement <= 4) return movement;

    return 0;
  }

  // 🔥 MESSAGE
  String getMessage(int m) {
    switch (m) {
      case 0:
        return "Patient Resting 💤";
      case 1:
        return "Food Request 🍽";
      case 2:
        return "Restroom Needed 🚻";
      case 3:
        return "🚨 EMERGENCY ALERT!";
      case 4:
        return "Electrical Assistance 🔌";
      default:
        return "Monitoring...";
    }
  }

  // 🎨 FIXED CARD (SOLID COLOR)
  Widget card(int i, String t, IconData ic, Color c) {
    bool active = i == activeIndex;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: active ? c : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: active ? c.withOpacity(0.6) : Colors.black12,
            blurRadius: active ? 15 : 5,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ic,
            size: 40,
            color: active ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 10),
          Text(
            t,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // 🎨 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      appBar: AppBar(
        title: const Text("Healthcare Monitor"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [

          const SizedBox(height: 20),

          // STATUS
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.monitor_heart,
                    color: Colors.white, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // GRID
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                card(0, "REST", Icons.hotel, Colors.grey),
                card(1, "FOOD", Icons.restaurant, Colors.green),
                card(2, "RESTROOM", Icons.wc, Colors.blue),
                card(3, "EMERGENCY", Icons.warning, Colors.red),
                card(4, "ELECTRICAL", Icons.electrical_services, Colors.orange),
              ],
            ),
          )
        ],
      ),
    );
  }
}