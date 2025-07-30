import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rent_app/features/hotel%20details/blocs/review%20save%20bloc/bloc/savereview_bloc.dart';

class AddReviewModelSheet extends StatefulWidget {
  final String hotelId;
  final String userName;
  const AddReviewModelSheet(
      {super.key, required this.hotelId, required this.userName});

  @override
  State<AddReviewModelSheet> createState() => _AddReviewModelSheetState();
}

class _AddReviewModelSheetState extends State<AddReviewModelSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewCommentController =
      TextEditingController();
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<SavereviewBloc, SavereviewState>(
      listener: (context, state) {
        if (state is SaveUserReviewSaved) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review saved successfully')),
          );
        } else if (state is SaveUserReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${state.error}')),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Add A Review',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: _reviewCommentController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Enter your comment',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Add Rating'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    int starIndex = index + 1;
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          rating = starIndex;
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        color: rating >= starIndex
                            ? Colors.amber
                            : Colors.grey.shade400,
                      ),
                    );
                  }),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: size.width * 0.35,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(36, 33, 149, 243),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_reviewCommentController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Add a review')));
                        return;
                      }
                      final comment = _reviewCommentController.text.trim();
                      context.read<SavereviewBloc>().add(SaveUserReview(
                          hotelId: widget.hotelId,
                          review: comment,
                          rating: rating,
                          userName: widget.userName));
                    },
                    child: Container(
                      width: size.width * 0.35,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        'Save',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
