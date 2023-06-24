import 'dart:developer';

import 'package:crud_mongodb/dbHelper/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase{
  static var db , userCollection;
  static connect() async{
    db = await Db.create(Mongo_db_url);
    await db.open();
    inspect(db);
    userCollection = db.collection(User_collection);
  }
}