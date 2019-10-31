const cstore = require('cstore');

exports.test = function (event, context) {
    let config = cstore.pull({
        tags: [process.env.ENV],
        format: "json-object",
        inject: false
    })

    Object.keys(config).forEach(function (key) {
        console.log(key + "=" + config[key]);
    });
}