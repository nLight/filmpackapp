module.exports = function (req, res) {
    var callback = req.query.callback;
    if (callback) {
        res.append('Content-Type', 'application/javascript');
        res.send(callback + '(' + JSON.stringify(res.body) + ');');
    } else {
        res.send(res.body);
    }
}
