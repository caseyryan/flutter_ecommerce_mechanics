import 'package:flutter/material.dart';
import 'card_data.dart';

class Data {

  Color pink = const Color.fromRGBO(255, 118, 162, 1.0);


  List<CardData> slideDatas = [
    CardData(title: 'Michael Kors Hamilton', discountText: '割り引き ¥23.00', price: 2188.00, imagePath: 'assets/img/purse1.jpg', pageColor: Color.fromRGBO(255, 187, 137, 1.0)),
    CardData(title: 'Saint Laurent', discountText: '割り引き ¥15.00', price: 1455.00, imagePath: 'assets/img/purse2.jpg', pageColor: Color.fromRGBO(255, 179, 186, 1.0)),
    CardData(title: 'ZATCHELS', discountText: '割り引き ¥28.00', price: 2398.00, imagePath: 'assets/img/purse3.jpg', pageColor: Color.fromRGBO(163, 164, 221, 1.0)),
    CardData(title: 'Hermes', discountText: '割り引き ¥13.50', price: 1345.00, imagePath: 'assets/img/purse5.jpg', pageColor: Color.fromRGBO(121, 200, 204, 1.0)),
    CardData(title: 'DOONEY & BOURKE', discountText: '割り引き ¥17.00', price: 1695.00, imagePath: 'assets/img/purse6.jpg', pageColor: Color.fromRGBO(114, 176, 218, 1.0)),
  ];


  static final Data _instance = Data._internal();
  factory Data() {
    return _instance;
  }
  Data._internal();
}
