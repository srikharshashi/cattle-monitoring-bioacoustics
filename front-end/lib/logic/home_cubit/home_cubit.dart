import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  String oemail = "";
  Future<void> load_home(String email) async {
    oemail = email;
    emit(HomeLoad());
    try {
      CollectionReference cattle =
          FirebaseFirestore.instance.collection('catteles');
      QuerySnapshot ss = await cattle.where('userId', isEqualTo: email).get();
      List<Map<String, dynamic>> cattle_list = [];
      ss.docs.forEach((doc) {
        Map<String, dynamic> cattleData = doc.data() as Map<String, dynamic>;
        cattleData['documentId'] = doc.id; // Add the document ID to the map
        cattle_list.add(cattleData);
      });
      emit(HomeLoaded(cattle_list: cattle_list));
    } catch (e) {
      emit(HomeError());
    }
  }

  Future<void> refresh_home() async {
    emit(HomeLoad());
    try {
      CollectionReference cattle =
          FirebaseFirestore.instance.collection('catteles');
      QuerySnapshot ss = await cattle.where('userId', isEqualTo: oemail).get();
      List<Map<String, dynamic>> cattle_list =
          ss.docs.map((e) => e.data() as Map<String, dynamic>).toList();

      emit(HomeLoaded(cattle_list: cattle_list));
    } catch (e) {
      emit(HomeError());
    }
  }
}
