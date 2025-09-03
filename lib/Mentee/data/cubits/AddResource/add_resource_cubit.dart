import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_repository.dart';
import 'package:mentivisor/Mentee/data/cubits/AddResource/add_resource_states.dart';

class AddResourceCubit extends Cubit<AddResourceStates> {
  AddResourceRepository addResourceRepository;
  AddResourceCubit(this.addResourceRepository) : super(AddResourceInitially());

  Future<void> resourceDownload(String id) async {
    emit(AddResourceLoading(id));
    try {
      final response = await addResourceRepository.resourceDownload(id);
      if (response != null && response.status == true) {
        emit(AddResourceLoaded(response, id));
      } else {
        emit(AddResourceFailure(response?.message ?? "Unknown error", id));

      }
    } catch (e) {
      emit(AddResourceFailure(e.toString(), id));
    }
  }

  Future<void> addResource(Map<String, dynamic> data, String id) async {
    emit(AddResourceLoading(id));
    try {
      final response = await addResourceRepository.addResource(data);
      if (response != null && response.status == true) {
        emit(AddResourceLoaded(response, id));
      } else {
        emit(AddResourceFailure(response?.message ?? "Unknown error", id));
      }
    } catch (e) {
      emit(AddResourceFailure(e.toString(), id));
    }
  }

}
