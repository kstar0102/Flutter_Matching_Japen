import 'package:flutter/material.dart';

class CommunityWidget extends StatelessWidget {
  final String image;
  final bool? isChecked;
  final String label;

  const CommunityWidget(
      {Key? key, this.isChecked, required this.image, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width /1.8,
              height: MediaQuery.of(context).size.height / 11.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Replace 10 with your desired radius value
                child: Image.network(
                  image,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Error loading image');
                  },
                  fit: BoxFit.cover, // Resize the image to fit the specified dimensions
                ),
              ),
            ),
            isChecked == true
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Replace 10 with your desired radius value
                    child: Image.asset("assets/images/community/selected.png"),
                  
                ):Container(),
          ],
        ),
        Center(
          child: Text(label),
        )
      ],
    );
  }
}
