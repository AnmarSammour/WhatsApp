import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/controller/cubit/get_numbers/get_numbers_state.dart';
import 'package:whatsapp/model/contact_model.dart';

class GetNumbersCubit extends Cubit<GetNumbersState> {
  final FirebaseFirestore firestore;

  GetNumbersCubit({required this.firestore}) : super(GetNumbersInitial());

  Future<void> getDeviceNumbers() async {
    try {
      emit(GetNumbersLoading());
      final contactNumbers = await getNumbersFromFirestore();
      emit(GetNumbersLoaded(contacts: contactNumbers));
    } catch (error) {
      emit(GetNumbersFailure(error.toString()));
    }
  }

  Future<List<ContactModel>> getNumbersFromFirestore() async {
    try {
      final querySnapshot = await firestore.collection('contacts').get();
      return querySnapshot.docs
          .map((doc) => ContactModel.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to get device numbers: $e");
    }
  }
}
