import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_login/models/new.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share/share.dart';

class ItemNoticia extends StatelessWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  Future<dynamic> downloadImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(noticia.urlToImage);
      if (imageId == null) {
        return;
      }
      // Below is a method of obtaining saved image information.
      return await ImageDownloader.findPath(imageId);
    } on PlatformException catch (error) {
      print(error);
    }
  }

  Future<void> share() async {
    print("Sharing new");
    Future<dynamic> imagePathFuture = downloadImage();
    String imagePath = await imagePathFuture;
    print("Downloaded image in path $imagePath");
    try {
      Share.shareFiles(['$imagePath'],
          text: '${noticia.title} - ${noticia.description}');
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
// TODO: Cambiar image.network por Extended Image con place holder en caso de error o mientras descarga la imagen
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  "${noticia.urlToImage}",
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${noticia.title}",
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${noticia.publishedAt}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "${noticia.description ?? "Descripcion no disponible"}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${noticia.author ?? "Autor no disponible"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: share,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
