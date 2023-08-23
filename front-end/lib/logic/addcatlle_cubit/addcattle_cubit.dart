import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'addcattle_state.dart';

class AddcattleCubit extends Cubit<AddcattleState> {
  AddcattleCubit() : super(AddcattleInitial());

  void addCattle(String email, String name, String type) async {
    emit(AddCattleLoad());
    try {
      var db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {
        'name': name,
        'type': type,
        "userId": email,
        "createdAt": Timestamp.now(),
        "history": [],
        "lastState":"unknown"
      };
      await db.collection('catteles').add(data);
      emit(AddCattleSuccess());
    } catch (e) {
      emit(AddCattleError());
    }
  }
}
