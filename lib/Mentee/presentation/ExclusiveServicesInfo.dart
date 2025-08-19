import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentivisor/Components/CutomAppBar.dart';
import 'package:mentivisor/utils/media_query_helper.dart';

import '../../utils/spinkittsLoader.dart';
import '../data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_Cubit.dart';
import '../data/cubits/ExclusiveServiceDetails/ExclusiveServiceDetails_State.dart';
import 'Widgets/CommonBackground.dart';

class ExclusiveServiceDetails extends StatefulWidget {
  final int id;
  final String title;
  const ExclusiveServiceDetails({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<ExclusiveServiceDetails> createState() =>
      _ExclusiveServiceDetailsState();
}

class _ExclusiveServiceDetailsState extends State<ExclusiveServiceDetails> {
  @override
  void initState() {
    context.read<ExclusiveservicedetailsCubit>().exclusiveServiceDetails(
      widget.id,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar1(title: widget.title ?? "", actions: []),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child:
            BlocBuilder<
              ExclusiveservicedetailsCubit,
              ExclusiveservicedetailsState
            >(
              builder: (context, state) {
                if (state is ExclusiveservicedetailsStateLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExclusiveservicedetailsStateLoaded) {
                  final serviceDetails = state.exclusiveservicedetailsModel.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: serviceDetails?.imageUrl ?? "",
                              fit: BoxFit.cover,
                              placeholder: (c, _) => const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.8,
                                  ),
                                ),
                              ),
                              errorWidget: (c, _, __) => const Icon(
                                Icons.broken_image_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: serviceDetails?.imageUrl ?? "",
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: imageProvider,
                                ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey.shade200,
                              child: Center(
                                child: spinkits.getSpinningLinespinkit(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(
                                    "assets/images/profile.png",
                                  ),
                                ),
                          ),

                          SizedBox(width: 8),
                          Text(
                            serviceDetails?.name ?? "",
                            style: TextStyle(
                              fontFamily: 'segeo',
                              fontWeight: FontWeight.w600,
                              color: Color(0xff222222),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Text(
                       serviceDetails?.name??"",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff222222),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'segeo',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        serviceDetails?.description ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'segeo',
                        ),
                      ),

                      // SizedBox(height: 12),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Text(
                      //     'Visit this link to access the exclusive service.\nClick here',
                      //     style: TextStyle(
                      //       decoration: TextDecoration.underline,
                      //       fontSize: 14,
                      //       color: Color(0xff9D5AF7),
                      //       fontWeight: FontWeight.w700,
                      //       fontFamily: 'segeo',
                      //     ),
                      //   ),
                      // ),
                    ],
                  );
                } else if (state is ExclusiveservicedetailsFailure) {
                  return Center(child: Text(state.msg));
                }
                return Text("No Data");
              },
            ),
      ),
    );
  }
}
