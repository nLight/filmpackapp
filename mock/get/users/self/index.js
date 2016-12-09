module.exports = {
  path: '/users/self',
  proxy: false,
  template: {
    "meta": {"code": 200},
    "data": function(params, query, body, cookies) {
      if (query.access_token.startsWith('229274478')) {
        return {
          "username": "redshoesphoto",
          "bio": "Hamburg \u2693\ufe0f Street photography. Medium format film photography. Vintage lenses. Film camera porn.\nDM um ihr Bild zu l\u00f6schen, danke!",
          "website": "http://500px.com/DmitriyRozhkov",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
          "full_name": "Senior Software Photographer",
          "counts": {"media": 668, "followed_by": 164, "follows": 198},
          "id": "229274478"
        }
      }
      if (query.access_token.startsWith('3860476144')) {
        return {
          "username": "typeface_hh",
          "bio": "Discover hidden gems of typography in Hamburg",
          "website": "",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/14723483_112869989182572_7232168655184723968_a.jpg",
          "full_name": "Typeface of Hamburg",
          "counts": {"media": 54, "followed_by": 59, "follows": 106},
          "id": "3860476144"
        }
      }
      if (query.access_token.startsWith('3926772192')) {
        return {
          "username": "rojkov.dmitry",
          "bio": "\u0421\u043d\u0438\u043c\u0430\u044e \u043d\u0430 \u0441\u0442\u0440\u0435\u043c\u043d\u044b\u0439 \u0442\u0435\u043b\u0435\u0444\u043e\u043d. \u041d\u0430 \u043d\u0435\u043c \u0434\u0430\u0436\u0435 \u043d\u0435\u0442 \u0441\u043c\u0430\u0439\u043b\u0438\u043a\u043e\u0432.",
          "website": "",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/14280350_173512333057016_1264995420_a.jpg",
          "full_name": "\u0414\u0438\u043c\u0430 \u0420\u043e\u0436\u043a\u043e\u0432",
          "counts": {"media": 24, "followed_by": 61, "follows": 64},
          "id": "3926772192"
        }
      }
    }
  },
  render: require('../../../jsonp')
};
