import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  
  //Kütüphaneden veri al
  final CollectionReference books = FirebaseFirestore.instance.collection('books');

  //CREATE: Kitap ekle
  Future<void> addBook(String bName,String bPublisher ,String bAuthor ,String bCategory ,int bPage ,int bPublication, bool? bQuestion){
    return books.add({
      'kitap adi': bName,
      'yayinevi' : bPublisher,
      'yazari' : bAuthor,
      'kategori': bCategory,
      'sayfa sayisi': bPage,
      'basim yili':  bPublication,
      'yayinlanacak mi': bQuestion,
      'timestamp' : Timestamp.now()
    });

  }
  //READ: kitabı oku
  Stream<QuerySnapshot> getBooksStream() {
      final booksStream = books.orderBy('timestamp', descending: true).snapshots();
      return booksStream;
  }

  //UPDATE: kitabı güncelle
  Future<void> updateBooks(String docID, String newName) {
    return books.doc(docID).update({
      'kitap adi': newName,
      'timestamp' : Timestamp.now()
    });
  }

  //DELETE: kitabı sil
  Future<void> deleteBook(String docID) {
    return books.doc(docID).delete();
  }



}