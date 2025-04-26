import 'package:book_listing_app/common/constants/app_constants.dart';
import 'package:book_listing_app/common/utils/debouncer.dart';
import 'package:book_listing_app/features/home/presentation/cubit/book_cubit.dart';
import 'package:book_listing_app/features/home/presentation/widgets/book_list_builder.dart';
import 'package:book_listing_app/features/home/presentation/widgets/book_list_item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({
    super.key,
  });

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
            : const Text(
                'Book Listing',
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
            ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BookCubit>().reload();
        },
        child: BlocConsumer<BookCubit, BookState>(
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
            return (switch (state) {
              (BookError error) => _errorWidget(
                  error,
                  context,
                ),
              (BookPaginating paginating) => BooksListBuilder(
                  books: paginating.books,
                  isCached: paginating.isCached,
                  isPaginating: true,
                  scrollController: _scrollController,
                ),
              (BookLoaded loaded) => BooksListBuilder(
                  books: loaded.books,
                  isCached: loaded.isCached,
                  isPaginating: false,
                  scrollController: _scrollController,
                ),
              (_) => ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => const BookListItemShimmer(),
                ),
            });
          },
        ),
      ),
    );
  }

  Center _errorWidget(BookError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.message,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.h,
          ),
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
}
