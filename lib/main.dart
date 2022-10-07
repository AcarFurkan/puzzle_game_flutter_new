import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:puzzle_game/sub_trial/demo.dart';
import 'package:puzzle_game/sub_trial/sub_provider.dart';
import 'feature/general/general.dart';
import 'feature/home_page/virewmodel/cubit/home_cubit.dart';

import 'core/helper/file_helper.dart';
import 'feature/game_page/cubit/game_cubit_cubit.dart';
import 'feature/home_page/view/home_page.dart';
import 'feature/repository/app_cache_manager.dart';
import 'feature/repository/repository.dart';
import 'locator.dart';
 /*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await FileHelper.instance.readAllLevels();
  await FileHelper.instance.readLevel();
  await Hive.initFlutter();
  if (General.instance.mod == Mod.development) {
    await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: ["2077ef9a63d2b398840261c8221a0c9b"]));
  }

  await MobileAds.instance.initialize();

  setupLocator();

  AppCacheManager _appCacheManager = locator<AppCacheManager>();
  await _appCacheManager.init();
  runApp(DemoPage());
}*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp3());
}

class MyApp3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DemoPage());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
          ..copyWith(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(primary: Colors.grey))),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeCubit()),
            BlocProvider(create: (context) => GameCubit(context)),
          ],
          child: HomePage(),
        ));
  }
}

class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      //_showPendingUI();
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        // _handleError(purchaseDetails.error!);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // bool valid = await _verifyPurchase(purchaseDetails);
        /* if (valid) {
          _deliverProduct(purchaseDetails);
        } else {
          _handleInvalidPurchase(purchaseDetails);
        }*/
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
      }
    }
  });
}
