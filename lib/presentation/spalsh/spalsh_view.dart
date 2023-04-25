import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu_proj/data/data_source/remote_data_source.dart';
import 'package:flu_proj/domain/models/models.dart';
import 'package:flu_proj/presentation/resourses/assets_manager.dart';
import 'package:flu_proj/presentation/resourses/color_manager.dart';
import 'package:flu_proj/presentation/resourses/constant_manager.dart';
import 'package:flutter/material.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resourses/router_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final RemoteDataSource _remoteDataSource = instance<RemoteDataSource>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.SplashDelay), _goNext);
  }

  _goNext() async {
    _appPreferences.isLoggedIn().then((isUserLoggedIn) async {//isUserLoggedIn=false;
      if (isUserLoggedIn) {
        //TODO call get data
        String id = await _appPreferences.getUserID();
      UserDataModel userDataModel=  await _remoteDataSource.getUserData(id);
      print(FirebaseAuth.instance.currentUser!.emailVerified);
        if(FirebaseAuth.instance.currentUser!.emailVerified)
          {
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
          }
        else
          {
            print("not verified");
            Navigator.pushReplacementNamed(context, Routes.verificationRoute);

          }

      } else {
        _appPreferences
            .isOnBoardingScreenViewed()
            .then((isOnBoardingScreenViewed) => {
                  if (isOnBoardingScreenViewed)
                    {Navigator.pushReplacementNamed(context, Routes.loginRoute)}
                  else
                    {
                      Navigator.pushReplacementNamed(
                          context, Routes.onBoardingRoute)
                    }
                });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
          child: Image(
        image: AssetImage(ImageAssets.splashLogo),
      )),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
