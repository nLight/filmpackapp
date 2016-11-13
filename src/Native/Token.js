var _nLight$packfilmapp$Native_Token = function() {

  function getToken() {
    var matching = window.location.hash.match(/access_token=(.+)/);

    if (matching) {
      return _elm_lang$core$Maybe$Just(matching[1]);
    }
    else {
      return _elm_lang$core$Maybe$Nothing;
    }
  };

  return {
    getToken: getToken
  }
}();
