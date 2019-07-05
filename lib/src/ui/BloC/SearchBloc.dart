import 'package:Orchid/src/network/DataManager.dart';
import 'package:Orchid/src/network/models/SearchResponse.dart';
import 'package:Orchid/src/ui/BloC/BaseBloc.dart';

class SearchBloc extends BaseBloc {
  SearchResponse currentSearchResponse;

  String _lastSearchedQuery = "";
  int currentPage = 1;
  bool isEmptyList = false;
  bool isSearching = false;

  void onSearchQueryEntered(String query, bool isLoadingRequired) {
    if (currentSearchResponse != null &&
        currentSearchResponse.movieList.length <
            num.parse(currentSearchResponse.totalResults)) {}

    if (query.length >= 3) {
      if (isLoadingRequired) {
        isProgressVisible = true;
        notifyListeners();
      }
      _onSearchParamChanged(query, isLoadingRequired);
    }
  }

  void _onSearchParamChanged(String query, bool isLoadingRequired) {
    if (query.length >= 3) {
      /*if (isLoadingRequired) {
        isProgressVisible = true;
        return new Future<BaseState>.value(currentState);
      }*/

      if (_lastSearchedQuery.toLowerCase() == query.toLowerCase()) {
        currentPage += 1;
      } else {
        currentPage = 1;
        currentSearchResponse = null;
        _lastSearchedQuery = query;
      }

      DataManager.searchMovies(query.toLowerCase(), currentPage)
          .then((value) async {
        var searchResponse = value.responseBody as SearchResponse;

        if ((currentPage <= 4) &&
            (currentSearchResponse == null
                        ? 0
                        : currentSearchResponse.movieList.length) +
                    searchResponse.movieList.length <
                num.parse(searchResponse.totalResults)) {
          _onSearchParamChanged(_lastSearchedQuery, false);
        }

        onSearchCompleted(
            _lastSearchedQuery, currentPage, searchResponse, false);
      }).catchError((error) {
        onSearchCompleted(
            _lastSearchedQuery, currentPage, currentSearchResponse, true);
      });
    }
  }

  void onSearchCompleted(String lastSearchedQuery, int currentPage,
      SearchResponse searchResponse, bool isError) {
    isSearching = false;
    if (isError) {
      /*On Error Reducing the CurrentPage Count*/
      isSearching = false;
      if (currentPage > 1) {
        currentPage--;
      }
    } else {
      /* OnSuccess Adding the Result into CurrentMovie Array*/
      if (currentSearchResponse == null) {
        currentSearchResponse = searchResponse;
      } else {
        currentSearchResponse.movieList.addAll(searchResponse.movieList);
      }
    }

    /*Setting Search UI States Based On Result*/
    if (currentSearchResponse == null ||
        currentSearchResponse.movieList.isEmpty) {
      isEmptyList = true;
    } else {
      isEmptyList = false;
    }
    isProgressVisible = false;
    notifyListeners();
  }
}
