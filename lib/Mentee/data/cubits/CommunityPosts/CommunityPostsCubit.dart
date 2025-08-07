 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsRepository.dart';
import 'package:mentivisor/Mentee/data/cubits/CommunityPosts/CommunityPostsStates.dart';

class CommunityPostsCubit extends Cubit<CommunityPostsStates>{
  CommunityPostsRepo communityPostsRepo;
  CommunityPostsCubit(this.communityPostsRepo):super(CommunityPostsInitially());

  Future<void> getCommunityPosts() async{
    emit(CommunityPostsLoading());
    try{
      final response = await communityPostsRepo.getCommunityPosts(1);
      if(response!=null && response.status==true){
        emit(CommunityPostsLoaded(response));
      }else{
        emit(CommunityPostsFailure("Something went wrong"));
      }
    }catch(e){
      emit(CommunityPostsFailure(e.toString()));
    }
  }
}