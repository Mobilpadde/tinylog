const path = require('path');

module.exports = {
    mode: 'development',

    entry: {
        lazy: path.resolve(__dirname, 'src', 'lazy.js'),
    },

    output: {
        path: path.resolve(__dirname, '../', 'static'),
        filename: '[name].js'
    }
};
