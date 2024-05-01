import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:developer';

Future<void> main() async {
  await setup();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  await Stripe.instance.applySettings();

  final  data = """## IPv6 Addressing for LAN/WAN Environments

  IPv6, with its massive address space compared to IPv4, offers a flexible approach to addressing needs in both Local Area Networks (LANs) and Wide Area Networks (WANs). Here's a breakdown of key points:

  **Addressing Requirements:**

  - **Scalability:**  Accommodate a vast number of devices on a network, crucial for the ever-growing number of connected devices (IoT etc.).
  - **Hierarchy:**  Create a hierarchical structure for efficient routing within a LAN and across WAN connections.
  - **Security:**  Facilitate secure communication by potentially integrating security features into the address itself.
  - **Autoconfiguration:**  Enable devices to automatically obtain IP addresses, simplifying network management.


  **IPv6 Addressing Schemes for LAN/WAN:**

  * **Global Unicast Addresses:** Used for public internet access on WAN interfaces. These addresses (starting with 2000::) are routable across the global internet.

  * **Unique Local Addresses (ULA):** Defined for private network use within an organization. ULAs (starting with fc00::) are not routable on the public internet but offer a large pool of addresses for internal use.

  * **Site-Local Addresses:** Another option for private networks (starting with fe80::). Site-local addresses are not routable even on a local WAN and are ideal for isolated LAN segments within a larger network.

  * **Subnet Prefix Delegation:** In a WAN environment, a larger prefix can be delegated to subnets, allowing for further hierarchical addressing within the organization.

  * **Stateless Address Autoconfiguration (SLAAC):**  Devices can automatically configure their IPv6 addresses on a LAN, reducing manual configuration overhead.

  **Benefits of IPv6 Addressing in LAN/WAN:**

  * **Scalability:**  The vast address space allows for future growth and eliminates the limitations of IPv4.
  * **Security:**  IPv6 can potentially integrate security features like privacy extensions into the address itself.
  * **Simplified Management:** Autoconfiguration features can streamline network administration.
  * **Improved Routing:**  Hierarchical addressing structures enable efficient routing within complex networks.

  By choosing the appropriate addressing scheme and leveraging IPv6 features, organizations can build robust and scalable LAN/WAN environments for the ever-evolving digital landscape.
  """;

  log(data.toString());

  await setupFirebase();
  await registerServices();
}

class MyApp extends StatefulWidget {
  late NavigationServices _navigationServices;
  late AuthServices _authServices;

  MyApp({super.key}) {
    final GetIt _getIt = GetIt.instance;

    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme()),
      navigatorKey: widget._navigationServices.getNavigatorKey,
      routes: widget._navigationServices.routes,
      initialRoute: widget._authServices.user != null
          ? "/curvedNavigationBar"
          : "/onBoard",
      // initialRoute: "/adminHome",
      // initialRoute:"/adminLogin",
    );
  }
}
