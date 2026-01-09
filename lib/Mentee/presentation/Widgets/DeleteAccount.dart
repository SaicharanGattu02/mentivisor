import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../Components/CustomSnackBar.dart';
import '../../../utils/color_constants.dart';
import '../../data/cubits/delete_account/DeleteAccountCubit.dart';
import '../../data/cubits/delete_account/DeleteAccountStates.dart';

class DeleteAccountConfirmation {
  static void showDeleteConfirmationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      elevation: 8,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
              listener: (context, state) {
                if (state is DeleteAccountSuccessState) {
                  context.pushReplacement('/login_mobile');
                  CustomSnackBar1.show(context, state.message ?? '');
                } else if (state is DeleteAccountError) {
                  CustomSnackBar1.show(context, state.message ?? '');
                }
              },
              builder: (context, state) {
                final bool isLoading = state is DeleteAccountLoading;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Description
                      Text(
                        'Are you sure you want to delete your account?',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: "lexend",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // Description
                      Text(
                        'All your data, including session history and coupons, will be permanently removed.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Inter",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.pop();
                                    },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[400]!),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      context
                                          .read<DeleteAccountCubit>()
                                          .deleteAccount();
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                backgroundColor: primarycolor,
                                foregroundColor: primarycolor,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
