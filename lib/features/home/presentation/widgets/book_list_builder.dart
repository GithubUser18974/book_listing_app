import 'package:book_listing_app/features/home/presentation/widgets/book_list_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constants/app_constants.dart';
import '../../domain/entities/book.dart';
import 'book_list_item.dart';

class BooksListBuilder extends StatelessWidget {
  final List<Book> books;
  final bool isCached;
  final bool isPaginating;
  final ScrollController scrollController;
  const BooksListBuilder({
    super.key,
    required this.books,
    required this.isCached,
    required this.isPaginating,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          AppConstants.noBooksFound,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return Column(
      children: [
        if (isCached)
          Container(
            padding: EdgeInsets.all(
              8.r,
            ),
            color: Colors.amber[100],
            child: Row(
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.amber[900],
                ),
                SizedBox(width: 8.w),
                Text(
                  'Showing cached data',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.amber[900],
                      ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: books.length + (isPaginating ? 2 : 0),
            itemBuilder: (context, index) {
              if (index >= books.length) {
                return BookListItemShimmer();
              }
              return BookListItem(book: books[index]);
            },
          ),
        ),
      ],
    );
  }
}
