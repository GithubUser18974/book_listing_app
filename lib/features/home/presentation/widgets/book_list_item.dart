import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookListItem extends StatefulWidget {
  final Book book;

  const BookListItem({
    super.key,
    required this.book,
  });

  @override
  State<BookListItem> createState() => _BookListItemState();
}

class _BookListItemState extends State<BookListItem> {
  bool _isExpanded = false;
  bool _hasOverflow = false;
  final _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    final RenderBox renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox;
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.book.summary ?? '',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      maxLines: AppConstants.maxLinesForSummary,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      maxWidth: renderBox.size.width,
    );
    setState(() {
      _hasOverflow = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          16.r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        widget.book.coverImage ?? AppConstants.placeholderImage,
                    width: 100.w,
                    height: 150.h,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 100.w,
                      height: 150.h,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 100.w,
                      height: 150.h,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.error,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        widget.book.authors.join(', '),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.book.summary != null) ...[
              SizedBox(
                height: 16.h,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.summary!,
                        key: _textKey,
                        maxLines: _isExpanded
                            ? null
                            : AppConstants.maxLinesForSummary,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                      if (_hasOverflow)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(
                            _isExpanded ? 'Show Less' : 'Show More',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
