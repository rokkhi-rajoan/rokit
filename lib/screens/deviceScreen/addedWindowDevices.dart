import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rokit/base/route.dart';
import 'package:rokit/providers_class/provider_device.dart';
import 'package:rokit/providers_class/provider_sensor_data.dart';
import 'package:rokit/utils/all_widgetClass.dart';
import 'package:rokit/utils/styles.dart';
import 'package:rokit/widget/loader_widget.dart';
import 'package:rokit/widget/no_data_found.dart';

import 'addDevice.dart';
import 'deviceLog.dart';

class AddedWindowDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderSensorData()),
        ChangeNotifierProvider(create: (_) => ProviderDevice()),
      ],
      child: AddedDevice(),
    );
  }
}

class AddedDevice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var providerDevice = Provider.of<ProviderDevice>(context, listen: false);
    providerDevice.getAddedDevices(deviceType: "WINDOW");

    return Scaffold(
      backgroundColor: appBack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: backColor2),
            title: Text(
              "Device List",
              style: text_StyleRoboto(backColor2, 18.0, FontWeight.w500),
            ),
            backgroundColor: appBack,
            actions: [
              Container(
                height: 25.0,
                width: 25.0,
                margin: EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
                child: Center(
                    child: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            "Show  ",
                            style: text_StyleRoboto(backColor2, 14.0, FontWeight.bold),
                          ),
                          Consumer<ProviderDevice>(
                            builder: (_, data, child) => Container(
                              width: 100.0,
                              height: 30.0,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: backColor2, width: 2.0)),
                              child: Center(
                                child: DropdownButton<String>(
                                  value: data.selected,
                                  hint: Text(
                                    "WINDOW",
                                    style: text_StyleRoboto(backColor2, 14.0, FontWeight.w500),
                                  ),
                                  style: text_StyleRoboto(backColor2, 14.0, FontWeight.bold),
                                  underline: SizedBox(),
                                  onChanged: (String newValue) {
                                    data.setSelectedItem(newValue);

                                    data.getAddedDevices(deviceType: newValue);

                                    print("Drop down value $newValue");
                                  },
                                  items: data.items.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      RouteGenerator.navigatePush(context, AddDeviceScreen());
                    },
                    child: Container(
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepOrange, boxShadow: [
                        BoxShadow(
                          color: Colors.deepOrange.withOpacity(0.1),
                          spreadRadius: 8,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                      child: Center(
                          child: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Expanded(
              child: Consumer<ProviderDevice>(
                builder: (_, data, child) => data.deviceDataModel == null
                    ? showShimmerDesign(context)
                    : data.deviceDataModel.data.length == 0
                        ? NoDataFoundWidget()
                        : Container(
                            child: ListView.builder(
                              itemCount: data.deviceDataModel.data.length,
                              itemBuilder: (_, index) {
                                return Dismissible(
                                  background: stackBehindDismiss(),
                                  key: ObjectKey(data.deviceDataModel.data[index]),
                                  onDismissed: (direction)async{
                                    await data.deleteDevice(data.deviceDataModel.data[index].id, context);
                                    await data.getAddedDevices(deviceType: "WINDOW");

                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                                      height: 95.0,
                                      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0), boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ]),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                              onTap: (){

                                                print( "Status ${data.deviceDataModel.data[index].status} battery Status ${data.deviceDataModel.data[index].batteryStatus} " );

                                                showAlertDialog(context,
                                                    deviceName: data.deviceDataModel.data[index].deviceName,
                                                    deviceNetwork: "Tp Link 20201",
                                                    deviceMac: data.deviceDataModel.data[index].deviceMacAddress,
                                                    status: data.deviceDataModel.data[index].status,
                                                    batteryStatus: data.deviceDataModel.data[index].batteryStatus);
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context).size.height,
                                                padding: EdgeInsets.only(top: 13, left: 12.0),
                                                decoration: BoxDecoration(color: appBack, borderRadius: BorderRadius.circular(5.0)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        data.deviceDataModel.data[index].deviceType == "WINDOW"
                                                            ? Image.asset(
                                                                "assets/window2.png",
                                                                height: 14.0,
                                                                width: 14.0,
                                                              )
                                                            : Image.asset(
                                                                "assets/door2.png",
                                                                height: 14.0,
                                                                width: 14.0,
                                                              ),
                                                        Text(
                                                          " ${data.deviceDataModel.data[index].deviceMacAddress}",
                                                          style: text_StyleRoboto(backColor2, 14.0, FontWeight.bold),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        data.deviceDataModel.data[index].status == "open"
                                                            ? Image.asset(
                                                                "assets/openDoor.png",
                                                                height: 50.0,
                                                                width: 50.0,
                                                              )
                                                            : Image.asset(
                                                                "assets/closeDoor.png",
                                                                height: 50.0,
                                                                width: 50.0,
                                                              ),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.battery_charging_full_sharp,
                                                              color: backColor2,
                                                              size: 16.0,
                                                            ),
                                                            Text(
                                                              "${data.deviceDataModel.data[index].batteryStatus} v",
                                                              style: text_StyleRoboto(backColor2, 14.0, FontWeight.bold),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      RouteGenerator.navigatePush(
                                                          context,
                                                          DoorDevicesLogScreen(
                                                            deviceMacAddress: data.deviceDataModel.data[index].deviceMacAddress,
                                                            deviceName: data.deviceDataModel.data[index].deviceName,
                                                          ));
                                                    },
                                                    child: Container(
                                                      height: 30.0,
                                                      decoration: BoxDecoration(color: appBack, borderRadius: BorderRadius.circular(5.0)),
                                                      child: Center(
                                                        child: Text(
                                                          "Log",
                                                          style: text_StyleRoboto(backColor2, 14.0, FontWeight.w500),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Container(
                                                    height: 30.0,
                                                    decoration: BoxDecoration(color: appBack, borderRadius: BorderRadius.circular(5.0)),
                                                    child: Center(
                                                      child: Text(
                                                        "Setting",
                                                        style: text_StyleRoboto(backColor2, 14.0, FontWeight.w500),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                );
                              },
                            ),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget stackBehindDismiss() {
    return Container(
      height: 90,
      color: Colors.red,
      margin: EdgeInsets.only(right: 10.0),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
