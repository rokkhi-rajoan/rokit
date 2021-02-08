import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rokit/base/all_api.dart';
import 'package:rokit/data_model/user_profile_model.dart';
import 'package:rokit/utils/styles.dart';
import 'package:rokit/widget/custom_progress.dart';
import 'package:rokit/widget/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProviderUser extends ChangeNotifier{

  UserProfileModel userProfileModel;


  int itemLength;


  getUserDetails()async{

    final prefs = await SharedPreferences.getInstance();

    print("USER ID : ${prefs.getString(KEY_USER_ID)}  TOKEN ID: ${prefs.getString(KEY_TOKEN_ID)}");


    var res = await http.post(getUserAPI,
        headers: <String, String>{
          'firebaseToken': "",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "requesterFirebaseId": "x3nUrfG9Yee6DQa2vqmA43gGVsx1",
          "deviceToken": "",

        }));

    print("response user " + res.statusCode.toString());
    print("response user " + res.body);

    if(res.statusCode==200 || res.statusCode==201){
      //print("User Details Response-----------------:"+res.body);

      var dataMap = jsonDecode(res.body);

      userProfileModel = UserProfileModel.fromJson(dataMap);
      notifyListeners();
      return userProfileModel;
    }else{
      print("Error Response:"+res.body);
      showErrorToast("Something went wrong");
    }
  }


  createUserProfile(context)async{
    final prefs = await SharedPreferences.getInstance();

    ProgressDialog pasdr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    setProgressDialog(context, pasdr, "load data...");

    pasdr.show();


  }


}