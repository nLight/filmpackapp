var _user$project$Native_Token = function() {

  var getToken = _elm_lang$core$Native_Scheduler.nativeBinding(function(callback)
  {
    var matching = window.location.hash.match(/access_token=(\w+)/);

    if (matching) {
      callback(_elm_lang$core$Native_Scheduler.succeed(
        _elm_lang$core$Maybe$Just(matching[1])
      ));
    }
    else {
      callback(_elm_lang$core$Native_Scheduler.succeed(
        _elm_lang$core$Maybe$Nothing
      ));
    }
  });

  return {
    getToken: getToken
  }
}();
