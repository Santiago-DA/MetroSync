// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart'
    show Db, DbCollection, where, modify;
import 'MongoManager/MongoDB.dart';
import 'GUI/GUI.dart';
import 'ViewModel/ViewModel.dart';
import 'lost_item/lost_item.dart';

int n = 0;
Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  VM vm = VM();
  // vm.crearItem('title', 'tag', 'imageURL');
  // vm.crearItem('title2', 'tag', 'imageURL');
  // vm.crearItem('title3', 'tag', 'imageURL');
  // vm.crearItem('title4', 'tag', 'imageURL');
  // vm.crearItem('title5', 'tag', 'imageURL');
  n=n+1;
  print('Main ejecutado $n veces'); 
  n = n + 1;
  print('Main ejecutado $n veces');
  await vm.loaditemfromBD();
  // await vm.eliminarItem(vm.itemxnombre('title2').id);
  // bool b = await vm.reclamarItem(vm.itemxnombre('title3').id);
  print(vm.getlostitems());
  runApp(MyApp());
}
