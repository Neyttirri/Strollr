import 'package:flutter/material.dart';
import 'FotoAndSteckbrief.dart';

List<ImageDetails> _images = [
  ImageDetails(
    imagePath: 'images/Baum.png',
    title: 'Eiche',
    details:
        'ein schoener Baum',
  ),
  ImageDetails(
    imagePath: 'images/Baum.png',
    title: 'Apfelbaum',
    details:
        'sehr viele in Deutschland.',
  ),
  ImageDetails(
    imagePath: 'images/Baum.png',
    title: 'Tanne',
    details:
    'sieht eig anders aus',
  ),
  ImageDetails(
    imagePath: 'images/Baum.png',
    title: 'Birke',
    details:
    'bin ich Allergisch',
  ),
];

class GalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Color(0xff9e9e9e),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Bäume',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,  // gruene hohe
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20, // abstand ausserhalb bilder
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // hintergrund
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
     // ---------- wie viele Bilder nebeneinander
                    crossAxisCount: 3,
               // ---- abstand zwischen bildern
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
      // ---- CLICK ON FOTO
                    return RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              imagePath: _images[index].imagePath,
                              title: _images[index].title,
                              details: _images[index].details,
                            ),
                          ),
                        );
                      },
  // ---------------------
                      child: Hero(
                        tag: 'logo$index',
                        child: Container(
                          decoration: BoxDecoration(
                            // bild aussehen
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(_images[index].imagePath),
        // ---------------- bild gestrechtet, geschnitten etc
                              fit: BoxFit.fill ,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _images.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageDetails {
  final String imagePath;
  final String title;
  final String details;
  ImageDetails({
    @required this.imagePath,
    @required this.title,
    @required this.details,
  });
}
