import 'package:Orchid/src/network/models/SearchResponse.dart';
import 'package:Orchid/src/ui/states/BaseState.dart';

class SearchState extends BaseState {
  bool isEmptyList = false;
  bool isSearching = false;

  var lastSearchedQuery = "";
  int currentPage = 1;

  SearchResponse currentSearchResponse;

  SearchState._();

  factory SearchState.initial({isEmptyList = false, isSearching = false}) {
    return SearchState._()
      ..isEmptyList = isEmptyList
      ..isSearching = isSearching;
  }
}
