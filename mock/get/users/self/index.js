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
          "username": "redshoesphoto",
          "bio": "Hamburg \u2693\ufe0f Street photography. Medium format film photography. Vintage lenses. Film camera porn.\nDM um ihr Bild zu l\u00f6schen, danke!",
          "website": "http://500px.com/DmitriyRozhkov",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
          "full_name": "Senior Software Photographer",
          "counts": {"media": 668, "followed_by": 164, "follows": 198},
          "id": "3860476144"
        }
      }
      if (query.access_token.startsWith('3926772192')) {
        return {
          "username": "redshoesphoto",
          "bio": "Hamburg \u2693\ufe0f Street photography. Medium format film photography. Vintage lenses. Film camera porn.\nDM um ihr Bild zu l\u00f6schen, danke!",
          "website": "http://500px.com/DmitriyRozhkov",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
          "full_name": "Senior Software Photographer",
          "counts": {"media": 668, "followed_by": 164, "follows": 198},
          "id": "3926772192"
        }
      }
    }
  },
  render: require('../../../jsonp')
};
