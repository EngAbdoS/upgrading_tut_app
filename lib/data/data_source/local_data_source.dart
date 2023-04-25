import 'package:flu_proj/app/app_prefs.dart';
import 'package:flu_proj/data/data_source/remote_data_source.dart';
import 'package:flu_proj/data/network/error_handler.dart';
import 'package:flu_proj/domain/models/models.dart';

import '../../app/di.dart';
import '../response/responses.dart';

const CACHE_HOME_KEY = "CACHE_HOME_KEY";
const CACHE_USER_KEY = "CACHE_USER_KEY";
const CACHE_HOME_INTRVAL = 60 * 1000;
const CACHE_STORE_DETAILS_KEY = "CACHE_STORE_DETAILS_KEY";
const CACHE_STORE_DETAILS_INTERVAL = 60 * 1000; // 30s in millis

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();

  Future<UserDataModel> getUserData();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  Future<void> saveUserToCache();

  Future<StoreDetailsResponse> getStoreDetails();

  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response);

  void clearCache();

  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final RemoteDataSource _remoteDataSource = instance<RemoteDataSource>();

  // run time cache
  Map<String, CachedItem> cacheMap = Map();
  UserDataModel? userDataModel;

  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[CACHE_HOME_KEY];
    if (cachedItem != null && cachedItem.isValid(CACHE_HOME_INTRVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    CachedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];

    if (cachedItem != null &&
        cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response) async {
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(response);
  }

  @override
  void clearCache() {
    cacheMap.clear();
    userDataModel = null;
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<UserDataModel> getUserData() async {
    if (userDataModel != null) {
      print("herr");
      print(userDataModel!.name);
      print(userDataModel!.profilePicture);
      return userDataModel!;
    } else {
      return await saveUserToCache().then((_) => userDataModel!);
    }
  }

  @override
  Future<void> saveUserToCache() async {
    userDataModel =
        await _remoteDataSource.getUserData(await _appPreferences.getUserID());
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    bool isValid = currentTime - cacheTime <= expirationTime;
    return isValid;
  }
}
