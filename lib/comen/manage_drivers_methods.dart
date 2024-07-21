
import 'package:new_app/Models/online_earby_drivers.dart';

class ManageDriversMethods
{
  static List<OnlineNearbyDrivers> nearbyOnlineDriversList = [];

  static void removeDriverFromList(String driverID)
  {
    int index = nearbyOnlineDriversList.indexWhere((driver) => driver.uidDriver == driverID);

    if(nearbyOnlineDriversList.length > 0)
    {
      nearbyOnlineDriversList.removeAt(index);
    }
  }

  static void updateOnlineNearbyDriversLocation(OnlineNearbyDrivers nearbyOnlineDriverInformation)
  {
    int index = nearbyOnlineDriversList.indexWhere((driver) => driver.uidDriver == nearbyOnlineDriverInformation.uidDriver);

    nearbyOnlineDriversList[index].latDriver = nearbyOnlineDriverInformation.latDriver;
    nearbyOnlineDriversList[index].lngDriver = nearbyOnlineDriverInformation.lngDriver;
  }

  static void updateOnlineNearbyDriverPosition(OnlineNearbyDrivers nearbyDriver) {}

  static void addOnlineDriver(OnlineNearbyDrivers onlineNearbyDrivers) {}

  static void removeOnlineDriverFromList(map) {}

  static void updateActiveNearbyAvailableDriverLocation(OnlineNearbyDrivers onlineNearbyDrivers) {}

  static void addDriverToList(OnlineNearbyDrivers onlineNearbyDriver) {}

  static void deleteOfflineDriverFromList(map) {}

  static void updateActiveNearbyDriverLocation(OnlineNearbyDrivers onlineNearbyDriver) {}

  static void addOnlineNearbyDriversIntoList(OnlineNearbyDrivers onlineNearbyDrivers) {}
}