import 'package:Orchid/src/ui/BloC/BaseBloc.dart';
import 'package:Orchid/src/ui/events/SearchEvent.dart';

class SearchBloc extends BaseBloc {

  @override
  // TODO: implement initialState
  get initialState => (){
    final


  };

  @override
  Stream mapEventToState(event) async*{


    switch(event){
      case

    }

    yield super.mapEventToState(event);
  }

  void _onSearchParamChanged(String query, bool isLoadingRequired) {

    if (query.length >= 3) {
      if (isLoadingRequired) {
        setState(() {
          isLoading = isLoadingRequired;
        });
      }

      if (_lastSearchedQuery.toLowerCase() == query.toLowerCase()) {
        _currentPage += 1;
      } else {
        _currentPage = 1;
        _currentSearchResponse = null;
        _lastSearchedQuery = query;
      }

      DataManager.searchMovies(query.toLowerCase(), _currentPage).then((value) {

        if (_currentSearchResponse == null) {
          _currentSearchResponse = value.responseBody;
        } else {
          _currentSearchResponse.movieList
              .addAll((value.responseBody as SearchResponse).movieList);
        }

        if ((_currentPage <= 4) &&
            _currentSearchResponse.movieList.length <
                num.parse(_currentSearchResponse.totalResults)) {
          _onSearchParamChanged(_searchController.text, false);
        }

        setState(() {
          if (_currentSearchResponse == null ||
              _currentSearchResponse.movieList.isEmpty) {
            isEmptyList = true;
          } else {
            isEmptyList = false;
          }
          isLoading = false;
        });

      }).catchError((error) {
        if (_currentPage > 1) {
          _currentPage--;
        }
        setState(() {
          if (_currentSearchResponse == null ||
              _currentSearchResponse.movieList.isEmpty) {
            isEmptyList = true;
          } else {
            isEmptyList = false;
          }
          isLoading = false;
        });
      });
    }
  }




}
