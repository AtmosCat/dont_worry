import 'package:cloud_firestore/cloud_firestore.dart';

class TestRepository {
  const TestRepository();
  Future<void> getAll() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 컬렉션 레퍼런스 타입의 이름이 기억이 안나요! 혹은 매번 타입 치기 번거로워요! 할땐 final or var!!!
    final collectionRef = firestore.collection('posts');
    final snapshot = await collectionRef.get();
    final documentSnaphots = snapshot.docs;
    for (var docSnapshot in documentSnaphots) {
      // Document Snapshot에는 id필드가 있는데 우리는 객체안에 ID넣어야
      // 나중에 수정, 삭제, 상세보기할 때 Post를 대상으로 할건지 알 수 있으니까 출력!
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
  }
}
