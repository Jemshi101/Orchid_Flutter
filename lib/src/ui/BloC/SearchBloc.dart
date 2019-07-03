import 'dart:async';

import 'package:Orchid/src/network/DataManager.dart';
import 'package:Orchid/src/network/models/SearchResponse.dart';
import 'package:Orchid/src/ui/events/SearchEvent.dart';
import 'package:Orchid/src/ui/states/SearchState.dart';
import 'package:bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  get initialState => new SearchState.initial();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Stream<SearchState> mapEventToState(event) async* {
    if (event is SearchQueryEnteredEvent) {
      if (currentState.currentSearchResponse != null &&
          currentState.currentSearchResponse.movieList.length <
              num.parse(currentState.currentSearchResponse.totalResults)) {}

      if (event.query.length >= 3) {
        if (event.isLoadingRequired) {
          currentState.isProgressVisible = true;
        }
        _onSearchParamChanged(event.query, event.isLoadingRequired);
        yield currentState;
      }
    } else if (event is SearchCompletedEvent) {
      currentState.isSearching = false;
      if (event.isError) { /*On Error Reducing the CurrentPage Count*/
        currentState..isSearching = false;
        if (currentState.currentPage > 1) {
          currentState.currentPage--;
        }
      } else { /* OnSuccess Adding the Result into CurrentMovie Array*/
        if (currentState.currentSearchResponse == null) {
          currentState.currentSearchResponse = event.currentSearchResponse;
        } else {
          currentState.currentSearchResponse.movieList.addAll(
              event.currentSearchResponse.movieList);
        }
      }

      /*Setting Search UI States Based On Result*/
      if (currentState.currentSearchResponse == null ||
          currentState.currentSearchResponse.movieList.isEmpty) {
        currentState.isEmptyList = true;
      } else {
        currentState.isEmptyList = false;
      }
      currentState.isProgressVisible = false;

      yield currentState;
    }
//    super.mapEventToState(event);
    yield currentState;
  }

  void _onSearchParamChanged(String query, bool isLoadingRequired) {
    if (query.length >= 3) {
      /*if (isLoadingRequired) {
        currentState.isProgressVisible = true;
        return new Future<BaseState>.value(currentState);
      }*/

      if (currentState.lastSearchedQuery.toLowerCase() == query.toLowerCase()) {
        currentState.currentPage += 1;
      } else {
        currentState.currentPage = 1;
        currentState.currentSearchResponse = null;
        currentState.lastSearchedQuery = query;
      }

      DataManager.searchMovies(query.toLowerCase(), currentState.currentPage)
          .then((value) async {

        var searchResponse = value.responseBody as SearchResponse;

        if ((currentState.currentPage <= 4) &&
            (currentState.currentSearchResponse == null
                        ? 0
                        : currentState.currentSearchResponse.movieList.length) +
                    searchResponse.movieList.length <
                num.parse(searchResponse.totalResults)) {
          _onSearchParamChanged(currentState.lastSearchedQuery, false);
        }

        dispatch(SearchCompletedEvent(
            currentState.lastSearchedQuery,
            currentState.currentPage,
            searchResponse,
            false));
      }).catchError((error) {
        dispatch(SearchCompletedEvent(
            currentState.lastSearchedQuery,
            currentState.currentPage,
            currentState.currentSearchResponse,
            true));
      });
    }
  }
}
