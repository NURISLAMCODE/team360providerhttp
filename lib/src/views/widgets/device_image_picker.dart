import 'package:flutter/material.dart';

Future getImage(BuildContext context,
    {required VoidCallback onTapCamera,
    required VoidCallback onTapGallery}) async {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Upload Image'),
      content: Container(
        height: 130,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: onTapCamera,
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: onTapGallery,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
