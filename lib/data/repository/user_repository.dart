import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_worry/utils/snackbar_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRepository {

  final auth = FirebaseAuth.instance;

  // 1. Create: 회원가입 후 유저 정보 추가
  Future<bool> signup({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      // firebaseAuth 활용 유저 정보 생성
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      // firestore에 별도로 유저 정보 저장
      final firestore = FirebaseFirestore.instance;
      final userRef = firestore.collection('users').doc(user!.uid);
      await userRef.set(
        {
          'name': name,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        SnackbarUtil.showSnackBar(context, "비밀번호는 8자 이상으로 입력해주세요.");
      } else if (e.code == 'email-already-in-use') {
        SnackbarUtil.showSnackBar(context, "이미 존재하는 이메일입니다.");
      } else if (e.code == 'invalid-email') {
        SnackbarUtil.showSnackBar(context, "올바른 이메일 형식을 입력해주세요.");
      } else if (e.code == 'network-request-failed') {
        SnackbarUtil.showSnackBar(context, '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.');
      }else {
        SnackbarUtil.showSnackBar(context, '로그인 실패: ${e.message}');
      }
      return false;
    } catch (e) {
      SnackbarUtil.showSnackBar(context, "알 수 없는 오류 발생: $e");
      print("회원가입 오류: $e");
      return false;
    }
  }

Future<bool> signin({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = '사용자를 찾을 수 없습니다.';
      } else if (e.code == 'invalid-email') {
        errorMessage = '이메일 형식이 잘못되었습니다.';
      }else if (e.code == 'wrong-password') {
        errorMessage = '비밀번호가 잘못되었습니다.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = '인증 정보가 잘못되었습니다.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = '로그인 시도가 너무 많습니다. 나중에 다시 시도해주세요.';
      } else {
        errorMessage = '로그인 실패: ${e.message}';
      }
      SnackbarUtil.showSnackBar(context, errorMessage);
      return false;
    } catch (e) {
      SnackbarUtil.showSnackBar(context, "알 수 없는 오류 발생: $e");
      print("로그인 오류: $e");
      return false;
    }
  }
}



// class PostRepository {
//   Future<List<Post>?> getAll() async {
//     try {
//       // 1. Firebase Firestore 인스턴스 생성
//       final firestore = FirebaseFirestore.instance;
//       // 2. 컬렉션 참조 만들기
//       final collectionRef = firestore.collection('posts');
//       // 3. 값 불러오기
//       final result = await collectionRef.get();

//       final docs = result.docs;
//       return docs.map((doc) {
//         final map = doc.data();
//         doc.id;
//         final newMap = {
//           'id': doc.id,
//           ...map, // 스프레드 연산자: 원래 맵을 새로운 맵에 풀어서 쓸 때 사용
//         };

//         return Post.fromJson(newMap);
//       }).toList();
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // 1. Create: 데이터 쓰기
//   Future<bool> insert({
//     required String title,
//     required String content,
//     required String writer,
//     required String imageUrl,
//   }) async {
//     try {
//       // 1. firebase 인스턴스 가져오기
//       final firestore = FirebaseFirestore.instance;
//       // 2. 컬렉션 참조 만들기
//       final collectionRef = firestore.collection('posts');
//       // 3. 문서 참조 만들기
//       final docRef = collectionRef.doc();
//       // 4. 값 쓰기
//       await docRef.set({
//         'title': title,
//         'content': content,
//         'writer': writer,
//         'imageUrl': imageUrl,
//         'createdAt': DateTime.now().toIso8601String(),
//       });
//       return true;
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }

//   // 2. Read: 데이터 읽기(특정 ID로 하나의 document 가져오기)

//   Future<Post?> getOne(String id) async {
//     try {
//       // 1. Firebase Firestore 인스턴스 생성
//       final firestore = FirebaseFirestore.instance;
//       // 2. 컬렉션 참조 만들기
//       final collectionRef = firestore.collection('posts');
//       // 3. 문서 참조 만들기
//       final docRef = collectionRef.doc(id);
//       // 4. 데이터 가져오기
//       final doc = await docRef.get();
//       return Post.fromJson( {
//         'id': doc.id,
//         ...doc.data()!,
//     });
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   // 3. Update: 데이터 갱신
//   Future<bool> update({
//     required String id,
//     required String title,
//     required String content,
//     required String writer,
//     required String imageUrl,
//     }) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final collectionRef = firestore.collection('posts');
//       final docRef = collectionRef.doc(id);

//       // 값을 업데이트
//       // 업데이트할 값을 Map 형태로 넣어주기
//       // set(): 전달받은 id에 해당하는 문서가 없으면 새 문서 생성
//       // update(): 전달받은 id에 해당하는 문서가 없으면 에러 
//       await docRef.update({
//         'writer': writer,
//         'title': title,
//         'content':content,
//         'imageUrl':imageUrl
//     });
//     return true;
//     } catch(e) {
//       print(e);
//       return false;
//     }
//   }

//   // 4. Delete: 데이터 삭제
//   Future<bool> delete (String id) async {
//     try {
//        final firestore = FirebaseFirestore.instance;
//        final collectionRef = firestore.collection('posts');
//        final docRef = collectionRef.doc(id);
//        await docRef.delete();
//        return true;
//     } catch(e) {
//       print(e);
//       return false;
//     }
//   }

//   Stream<List<Post>> postListStream() {
//     final firestore = FirebaseFirestore.instance;
//     final collectionRef = firestore.collection('posts').orderBy('createdAt',descending: true);
//     final stream = collectionRef.snapshots();
//     final newStream = stream.map(
//       (event) {
//         return event.docs.map((e){
//           return Post.fromJson({
//             'id': e.id,
//             ...e.data(),
//           });
//         }).toList();  
//       },
//     );

//     return newStream;
//   }

//   Stream<Post?> postStream(String id) {
//     final firestore = FirebaseFirestore.instance;
//     final collectionRef = firestore.collection('posts');
//     final docRef = collectionRef.doc(id);
//     final stream = docRef.snapshots();
//     final newStream = stream.map((e){
//       if (e.data() == null) {
//         return null;
//       } else {
//         return Post.fromJson({
//           'id': e.id,
//           ...e.data()!,
//         });
//       }
//     });
//     return newStream;

//   }

// }
