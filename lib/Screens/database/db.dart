import 'package:flutter/material.dart';
import 'package:nominal_roll/Screens/auth/supbaseinit.dart';
import 'package:nominal_roll/Screens/models/profileModel.dart';

class db {
  // Get the session or user object

  getUserProfile() async {
    var data = supabase.auth.currentUser;
    var user = data?.id;
    // debugPrint(user);
// Fetch data of the particular user
    var profileData = await supabase.from('profiles').select('*').eq('id', user);
    return profileData[0];

// // Map the data to a user model
    // var userModel = ProfileModel.fromJson((datak) => ({
    //       : data.id,
    //       name: data.name,
    //       email: data.email,
    //       // Add more properties as needed
    //     }));

    // var userprofile = ProfileModel.fromMap();
  }
}
