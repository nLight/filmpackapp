var _user$project$Native = function() {

  function getUser() {
    var data = {
      "meta": {"code": 200},
      "data": {
        "username": "redshoesphoto",
        "bio": "Medium format film photography. Vintage lenses. Film camera porn. Accidental street photography.",
        "website": "http://500px.com/DmitriyRozhkov",
        "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
        "full_name": "Senior Software Photographer",
        "counts": {
          "media": 652,
          "followed_by": 150,
          "follows": 159
        },
        "id": "229274478"
      }
    };

    return _elm_lang$core$Native_Scheduler.nativeBinding(function(callback) {
      callback(_elm_lang$core$Native_Scheduler.succeed(data));
    });
  }

  return {
    getLocation: getLocation
  }
}();
