import 'package:Orchid/src/network/models/SearchResponse.dart';
import 'package:Orchid/src/ui/events/BaseEvent.dart';

class SearchEvent extends BaseEvent {}

class SearchQueryEnteredEvent extends SearchEvent {
  bool isLoadingRequired;
  String query = "";

  SearchQueryEnteredEvent(this.query, this.isLoadingRequired);
}

class SearchCompletedEvent extends SearchEvent {
  var lastSearchedQuery = "";
  int currentPage = 1;
  bool isError = false;

  SearchResponse currentSearchResponse;

  SearchCompletedEvent(
    this.lastSearchedQuery,
    this.currentPage,
    this.currentSearchResponse,
    this.isError,
  );
}
