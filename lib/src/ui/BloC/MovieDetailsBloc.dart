import 'package:Orchid/src/constants/AppConstants.dart';
import 'package:Orchid/src/models/MovieBean.dart';
import 'package:Orchid/src/network/DataManager.dart';
import 'package:Orchid/src/network/models/MovieDetailResponse.dart';
import 'package:Orchid/src/ui/BloC/BaseBloc.dart';

class MovieDetailsBloc extends BaseBloc {

  MovieDetailResponse movieDetailResponse;

  fetchMovieDetails(MovieBean movieBean) async {
    _setLoading(true);

    DataManager.getMovieDetails(movieBean.imdbID, AppConstants.PLOT_TYPE_FULL)
        .then((value) {
      movieDetailResponse = value.responseBody;

      _setLoading(false);
    }).catchError((error) {
      _setLoading(false);
    });
  }

  void _setLoading(isLoadingRequired) {
    isProgressVisible = isLoadingRequired;
    notifyListeners();
  }
}
