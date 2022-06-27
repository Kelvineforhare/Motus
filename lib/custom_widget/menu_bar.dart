import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:game_demo/custom_widget/menu_items.dart';
import "package:game_demo/models/firebase_collection.dart";

class MenuBar extends StatelessWidget {
  final FirebaseCollection firebaseCollection;

  MenuBar({required this.firebaseCollection});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.list,
          size: 46,
          color: Colors.blue,
        ),
        customItemsIndexes: const [3],
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
            (e) => DropdownMenuItem<MenuItem>(
              value: e,
              child: MenuItems.buildItem(e),
            ),
          )
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem, firebaseCollection);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 160,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.blueAccent,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }
}
