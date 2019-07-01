

import 'package:Orchid/src/ui/events/BaseEvent.dart';

class SearchEvent extends BaseEvent{

  static const SEARCH_QUERY_ENTERED = "search_query_entered";
  static const SEARCH_LOAD_MORE = "search_load_more";
  static const SEARCH_COMPLETED = "search_completed";
  static const EMPTY_LIST = "empty_list";

}