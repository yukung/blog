var ghost = require('ghost');
var path = require('path');
var express = require('express');
var parentApp = express();
var urlService = require('./node_modules/ghost/core/frontend/services/url');
var Raven = require('raven');

var sentryDsn = process.env.SENTRY_DSN;

ghost().then(function (ghostServer) {
    // Error tracking by Sentry
    if (!!sentryDsn) {
        Raven.config(sentryDsn).install();
        parentApp.use(Raven.requestHandler());
        parentApp.use(Raven.errorHandler());
        parentApp.use(function onError(err, req, res, next) {
            res.statusCode = 500;
            res.end(res.sentry + '\n');
        });
    }
    parentApp.use(urlService.utils.getSubdir(), ghostServer.rootApp);
    ghostServer.start(parentApp);
});
