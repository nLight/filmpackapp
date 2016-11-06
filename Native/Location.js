var _user$project$Native_Location = function() {

  function getLocation() {
    return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
      console.log(document.location);
      callback(_elm_lang$core$Native_Scheduler.succeed(document.location));
    });
  }

  return {
    getLocation: getLocation
  }
}();
