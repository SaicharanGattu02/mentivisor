import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_states.dart';

class AddResourceCubit extends Cubit<AddResourceStates> {
  AddResourceRepository addResourceRepository;
  AddResourceCubit(this.addResourceRepository) : super(AddResourceInitially());

  Future<void> addResource(Map<String, dynamic> data) async {
    emit(AddResourceLoading());
    try {
      final response = await addResourceRepository.addResource(data);
      if (response != null && response.status == true) {
        emit(AddResourceLoaded(response));
      } else {
        emit(AddResourceFailure(response?.message ?? ""));
      }
    } catch (e) {
      emit(AddResourceFailure(e.toString()));
    }
  }
}
