import 'package:flutter/material.dart';

class Utils {
  static Color colorType(String type) {
    var color = Colors.white;
    switch (type.toLowerCase()) {
      case 'normal':
        color = Color(0xFFAA895F);
        break;
      case 'fighting':
        color = Color(0xFFFF5F65);
        break;
      case 'flying':
        color = Color(0xFF808DC7);
        break;
      case 'poison':
        color = Color(0xFFB265A1);
        break;
      case 'ground':
        color = Color(0xFFE5B15E);
        break;
      case 'rock':
        color = Color(0xFFA99F64);
        break;
      case 'bug':
        color = Color(0xFF97AA44);
        break;
      case 'ghost':
        color = Color(0xFF836C97);
        break;
      case 'steel':
        color = Color(0xFF8CB4BE);
        break;
      case 'fire':
        color = Color(0xFFF67B53);
        break;
      case 'water':
        color = Color(0xFF51C6DA);
        break;
      case 'grass':
        color = Color(0xFF7AC85B);
        break;
      case 'electric':
        color = Color(0xFFF4C912);
        break;
      case 'psychic':
        color = Color(0xFFF96289);
        break;
      case 'ice':
        color = Color(0xFF6BDDD2);
        break;
      case 'dragon':
        color = Color(0xFF5A63B0);
        break;
      case 'dark':
        color = Color(0xFF5A5050);
        break;
      case 'fairy':
        color = Color(0xFFFF78AC);
        break;
    }
    return color;
  }
}