module.exports = {
    path: '/users/self/follows',
    proxy: false,
    template: {
      "pagination": {},
      "meta": {"code": 200},
      "data": [
        {
          "username": "typeface_hh",
          "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/14723483_112869989182572_7232168655184723968_a.jpg",
          "id": "3860476144",
          "full_name": "Typeface of Hamburg"
        }
      ]
    },
    render: require('../../../jsonp')
};
