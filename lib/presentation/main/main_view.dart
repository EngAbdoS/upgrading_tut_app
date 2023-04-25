import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flu_proj/data/data_source/local_data_source.dart';
import 'package:flu_proj/domain/models/models.dart';
import 'package:flu_proj/presentation/main/pages/home/view/home_page.dart';
import 'package:flu_proj/presentation/main/pages/notifications/view/notifications_page.dart';
import 'package:flu_proj/presentation/main/pages/search/view/search_page.dart';
import 'package:flu_proj/presentation/main/pages/settings/view/settings_page.dart';
import 'package:flu_proj/presentation/resourses/color_manager.dart';
import 'package:flu_proj/presentation/resourses/strings_manager.dart';
import 'package:flu_proj/presentation/resourses/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/di.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  final StreamController _profilePicStreamController =
      BehaviorSubject<String>();
  List<Widget> pages = [
    const HomePage(),
    const SearchPage(),
    const NotificationPage(),
    const SettingsPage()
  ];
  List<String> titles = [
    AppStrings.home,
    AppStrings.search,
    AppStrings.notifications,
    AppStrings.settings,
  ];
  var _title = AppStrings.home;
  var _currentIndex = 0;

  UserDataModel? userDataModel;

  _getUserData() async {
    userDataModel = await _localDataSource.getUserData();
    _profilePicStreamController.sink.add(userDataModel!.profilePicture);
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  _getUserData();
    //print(userDataModel!.mobileNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ).tr(),
        leading: GestureDetector(
          onTap: (){
            //TODO
          },
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p8 * .7),
            child: StreamBuilder(
              stream: _profilePicStreamController.stream,
              builder: (context, snapshot) {
                return CircleAvatar(
                  radius: AppSize.s40 * 1.3,
                  backgroundImage: NetworkImage(snapshot.data ?? ""),
                );
              },
            ),
            // CachedNetworkImage(
            //       fit: BoxFit.fill,
            //       placeholder: (context, url) => const Center(
            //         child: CircularProgressIndicator(
            //           color: Colors.white,
            //         ),
            //       ),
            //       imageUrl:  _localDataSource.getUserData().then((value) => value.profilePicture).toString() ??"",
            //       errorWidget: (context, url, error) {
            //         //print(imgUrl);
            //
            //         return const Icon(Icons.error_outline);
            //       }),
            //NetworkImage((userDataModel!.profilePicture) ??
            // "https://www.pngitem.com/pimgs/m/504-5040528_empty-profile-picture-png-transparent-png.png"),
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: ColorManager.lightGray, spreadRadius: AppSize.s1_5 * .5)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.gray,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: AppStrings.home.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), label: AppStrings.search.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_none_outlined),
                label: AppStrings.notifications.tr()),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppStrings.settings.tr()),
          ],
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
