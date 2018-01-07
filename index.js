var ghost = require('ghost');
var path = require('path');
var express = require('express');
var parentApp = express();
var utils = require('./node_modules/ghost/core/server/services/url/utils');

ghost().then(function (ghostServer) {
    parentApp.use(utils.getSubdir(), ghostServer.rootApp);
    ghostServer.start(parentApp);
});
