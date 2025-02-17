import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_login/home/noticias_firebase/bloc/my_news_bloc.dart';
import 'package:google_login/models/new.dart';
import 'package:image_picker/image_picker.dart';

part 'create_news_event.dart';
part 'create_news_state.dart';

class CreateNewsBloc extends Bloc<CreateNewsEvent, CreateNewsState> {
  final _cFirestore = FirebaseFirestore.instance;
  File _selectedPicture;

  CreateNewsBloc() : super(CreateNewsInitial());

  @override
  Stream<CreateNewsState> mapEventToState(
    CreateNewsEvent event,
  ) async* {
    if (event is PickImageEvent) {
      yield LoadingState();
      _selectedPicture = await _getImage();
      yield PickedImageState(image: _selectedPicture);
    } else if (event is SaveNewElementEvent) {
      // 1) subir archivo a bucket
      // 2) extraer url del archivo
      // 3) agregar url al elemento de firebase
      // 4) guardar elemento en firebase
      // 5) actualizar lista con RequestAllNewsEvent
      String imageUrl = await _uploadFile();
      if (imageUrl != null) {
        yield LoadingState();
        await _saveNoticias(event.noticia.copyWith(urlToImage: imageUrl));
        // yield LoadedNewsState(noticiasList: await _getNoticias() ?? []);
        yield SavedNewState();
        MyNewsBloc().add(RequestAllNewsEvent());
      } else {
        yield ErrorMessageState(errorMsg: "No se pudo guardar la imagen");
      }
    }
  }

  Future<String> _uploadFile() async {
    try {
      var stamp = DateTime.now();
      if (_selectedPicture == null) return null;
      // define upload task
      UploadTask task = FirebaseStorage.instance
          .ref("noticias/imagen_$stamp.png")
          .putFile(_selectedPicture);
      // execute task
      await task;
      // recuperar url del documento subido
      return await task.storage
          .ref("noticias/imagen_$stamp.png")
          .getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Error al subir la imagen: $e");
      return null;
    } catch (e) {
      // error
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  Future<bool> _saveNoticias(New noticia) async {
    try {
      await _cFirestore.collection("noticias").add(noticia.toJson());
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // pick image
  Future<File> _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }
}
