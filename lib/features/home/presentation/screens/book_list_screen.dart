import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/common/utils/debouncer.dart';
import 'package:book_listing_app/features/home/domain/entities/book.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:book_listing_app/features/home/presentation/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _searchDebouncer = Debouncer();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BookCubit>().loadInitialBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BookCubit>().loadMoreBooks();
    }
  }

  void _onSearchChanged(String query) {
    _searchDebouncer(() {
      if (query.isNotEmpty) {
        context.read<BookCubit>().searchBooks(query);
      } else {
        context.read<BookCubit>().loadInitialBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: AppConstants.searchHint,
                  border: InputBorder.none,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[400],
                      ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                autofocus: true,
                onChanged: _onSearchChanged,
              )
            : const Text('Book Listing'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<BookCubit>().loadInitialBooks();
                }
              });
            },
          ),
        ],
      ),
      body: BlocConsumer<BookCubit, BookState>(
        listener: (context, state) {
          if (state is BookError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookInitial || state is BookLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BookError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookCubit>().loadInitialBooks();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BookLoaded) {
            final books = state.books;
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
                if (state.isCached)
                  Container(
                    padding: EdgeInsets.all(8.r),
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.amber[900],
                                  ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: books.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index == books.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return BookListItem(book: books[index]);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
