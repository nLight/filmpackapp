var _nLight$packfilmapp$Native_DevUtil = function() {

  function getStreams() {
    var tokens = localStorage.getItem('tokens');

    if (! tokens ) {
      return _elm_lang$core$Maybe$Nothing;
    }

    return _elm_lang$core$Maybe$Just(
      _elm_lang$core$Native_List.fromArray(
        JSON.parse(tokens).map(function (token) {
          return _elm_lang$core$Native_Utils.Tuple2(
            token,
            {
              user: _elm_lang$core$Maybe$Nothing,
              recent: _elm_lang$core$Native_List.Nil
            }
          )
        })
      )
    );
  };

  return {
    getStreams: getStreams
  }
}();
