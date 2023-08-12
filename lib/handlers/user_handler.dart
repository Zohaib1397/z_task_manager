import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:z_task_manager/structure/DAO.dart';

class UserHandler implements DAO{

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> create(user) async {
    try{
      
      return true;
    }catch(e){
      print(e.toString());
      return false;
    }
  }

  @override
  Future<bool> delete(user) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  search(String name) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<bool> update(user) {
    // TODO: implement update
    throw UnimplementedError();
  }

}