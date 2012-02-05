// My SocketStream app

var http = require('http')
  , ss = require('socketstream');

ss.client.define('chat', {
  view: 'chat.jade',
  css:  ['libs', 'chat.styl'],
  code: ['libs', 'modules', 'main']
});

// ss.session.store.use('redis', {redis: {host: 'localhost', port: 6379}});
// ss.publish.transport.use('redis', {redis: {host: 'localhost', port: 6379}});

ss.ws.transport.use('socketio')

ss.http.router.on('/chat', function(req, res) {
  res.serve('chat');
});

// Remove to use only plain .js, .html and .css files if you prefer
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('ss-stylus'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimise and pack assets if you type  SS_ENV=production node app.js
if (ss.env == 'production') ss.client.packAssets();

var server = http.Server(ss.http.middleware);
server.listen(3000);

ss.start(server);