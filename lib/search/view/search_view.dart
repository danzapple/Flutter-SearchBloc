import 'package:advanced_search_flutter/product/widget/search_field.dart';
import 'package:advanced_search_flutter/search/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../product/base/base_state.dart';
import '../../product/widget/search_item_card.dart';
import '../model/user_model.dart';
import '../service/search_item_service.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with BaseState {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(SearchService(networkManager)),
      child: Scaffold(
        body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case SearchLoading:
                return Center(child: CircularProgressIndicator());
              case SearchComplete:
                return _createSearchListView(context, state as SearchComplete);
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _createSearchListView(
      BuildContext context, SearchComplete searchComplete) {
    final List<Data> items = searchComplete.model?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SearchField(
          onChanged: (value) {
            context.read<SearchCubit>().findItems(value);
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          shrinkWrap: true,
          children: [_sliverList(items)],
        ),
      ),
    );

    // CustomScrollView(
    //   slivers: [_sliverAppBar(context), _sliverList(items)],
    // );
  }

  SliverAppBar _sliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: SearchField(
          onChanged: (value) {
            context.read<SearchCubit>().findItems(value);
          },
        ),
      ),
    );
  }

  Widget _sliverList(List<Data> items) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 6,
      itemCount: items.length,
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(3, index.isEven ? 3.2 : 3.2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      itemBuilder: (context, index) {
        return SearchItemCard(item: items[index]);
      },
    );
  }
}
