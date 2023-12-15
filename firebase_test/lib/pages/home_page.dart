import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/services/firestore.dart';
import 'package:flutter/material.dart';

//Ultra serisi: Class'lar arası iletişimi sağlıyorlar
String? ultraID;

String ultrabName = '';
String ultrabPublisher = '';
String ultrabAuthor = '';
String ultrabCategory = '';
int? ultrabPage ;
int? ultrabPublication ;

//Kitap sayfası
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homepagestate = const HomePage();
  
  FirestoreService firestoreService = FirestoreService();
  
  //Silme ekranı
  void deletionScreen(String docID){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Silme işlemi!'),
          content: const Text('Bu kitabı silmek istediğine emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'İptal'),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => firestoreService.deleteBook(docID),
              child: const Text('Sil'),
            ),
          ],
        ),
      );
  }

  //2. Ekrana gitme işlemi
  void pureAddPage(){
    MaterialPageRoute  X = MaterialPageRoute(builder: (context) => const AddPage());
    Navigator.push(context, X);
    ultrabName = '';
    ultrabPublisher = '';
    ultrabAuthor = '';
    ultrabCategory = '';
    ultrabPage = 0;
    ultrabPublication = 0;

  }

  void openAddPage({String? docID, String? bName,String? bPublisher,String? bAuthor,String? bCategory,int? bPage, int? bPublication}) {
    MaterialPageRoute  X = MaterialPageRoute(builder: (context) => const AddPage());
    Navigator.push(context, X);
    ultraID = docID;
    ultrabName = bName as String;
    ultrabPublisher = bPublisher as String;
    ultrabAuthor = bAuthor as String;
    ultrabCategory = bCategory as String;
    ultrabPage =  bPage as int;
    ultrabPublication = bPublication as int;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alperen AVCI 02210201052')),
      floatingActionButton: FloatingActionButton(
        onPressed: pureAddPage,
        child: const Icon(Icons.add)
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getBooksStream(),
          builder:(context, snapshot) {
            if (snapshot.hasData) {
              List booksList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: booksList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = booksList[index];
                  String docID = document.id;


                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String bName = data['kitap adi']; //Eklenecek
                  String bPublisher = data['yayinevi'];
                  String bAuthor = data['yazari'];
                  String bCategory = data['kategori'];
                  int bPage = data['sayfa sayisi'];
                  int bPublication = data['basim yili'];
                  bool? bQuestion = data['bQuestion'];

                  return Card(child: ListTile(
                    tileColor: const Color.fromARGB(255, 235, 221, 255),
                    title: Text('Kitap adi: $bName'), //Eklenecek
                    subtitle: Text('Yazar: $bAuthor, Sayfa sayisi: $bPage'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //Güncelleme duşu
                        IconButton(
                          onPressed: () => openAddPage(docID: docID, bName:bName, bPublisher:bPublisher, bAuthor:bAuthor, bCategory:bCategory, bPage:bPage, bPublication:bPublication),
                          icon: const Icon(Icons.settings)

                        ),
                        //Slime tuşu
                        IconButton(
                          onPressed: () => deletionScreen(docID),
                          icon: const Icon(Icons.delete)
                        ),

                    ],)
                  )
                  );
                },
              );
            }
            else {
              return const Text('Kitap yok ...');
            }
          },
        ),
    );
  }
}

///////////////////////////////////////////////////////////////////

const List<String> list = <String>['Roman', 'Tarih', 'Şiir', 'Edebiyat', 'Asiklopedi'];

//Kitap ekleme sayfası
class AddPage extends StatefulWidget {
  const AddPage({super.key});
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String dropdownValue = list.first;
  bool? isChecked = true;
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  final TextEditingController bName = TextEditingController(text: ultrabName);
  final TextEditingController bPublisher = TextEditingController(text: ultrabPublisher);
  final TextEditingController bAuthor = TextEditingController(text: ultrabAuthor);
  final TextEditingController bPage = TextEditingController(text: '$ultrabPage');
  final TextEditingController bPublication = TextEditingController(text: '$ultrabPublication');
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kitap ekle')),
      body: Column(
        children: <Widget>[

          //Sayfadaki elemanlar

          //KITAP ADI
          const Text(''),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kitap adi',
            ),
            controller: bName,
          ),

          //YAYINEVI
          const Text(''),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yayinevi',
            ),
            controller: bPublisher,
          ),
          
          //YAZAR
          const Text(''),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yazarlar',
            ),
            controller: bAuthor,
          ),

          //KITABIN TÜRÜ
          const Text(''),
          DropdownMenu<String>(
            initialSelection: list.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),

          //SAYFA SAYISI
          const Text(''),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Sayfa sayisi',
            ),
            controller: bPage,
          ),

          //TARIHI
          const Text(''),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Basim tarihi',
            ),
            controller: bPublication,
          ),

          //YAYINLANMASI
          Row(
            children: <Widget>[
              const Text('Listede Yayinlanacak mi?'),
              Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value;
                  });
                },
              )
            ],
          ),
          
          //SAYFADAN CIKACAK BUTON
          ElevatedButton(
            style: style,
            onPressed: (){

              //Yeni not ekleme
              if (ultraID == null) {
                firestoreService.addBook(bName.text, bPublisher.text, bAuthor.text, dropdownValue, int.parse(bPage.text), int.parse(bPublication.text), isChecked);
              }

              //güncelleme
              //!!!! GÜNCELLEME İŞLEMMİNDE FARKLI BİR YOL İZLEYECEĞİM
              //docID 'yi tam olarak kullanmayı bilmediğim için sadece kitabın adını değiştirebiliyorum.
              //O yüzden güncelleme yaparken bu kitabı silip tekrar yükleteceğim
              else {
                //firestoreService.updateBooks(ultraID as String, bName.text);

                firestoreService.deleteBook(ultraID as String);
                firestoreService.addBook(bName.text, bPublisher.text, bAuthor.text, dropdownValue, int.parse(bPage.text), int.parse(bPublication.text), isChecked);
                ultraID = null;
              }
              bName.clear();
              bPublisher.clear();
              bAuthor.clear();
              bPage.clear();
              bPublication.clear();
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          )

        ],
      ),
    );
  }
}