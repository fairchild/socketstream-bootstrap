// My SocketStream app

var http  = require('http')
, ss      = require('socketstream')
, authom  = require('authom')
, express = require('express');

var app = express.createServer();;

var github = authom.createServer({
  service: "github",
  id: "6e084a8b6117d5cc16c3",
  secret: "5a6f1b27aa4b70d2d8930e3cf43c8ecce4c04b32",
  callback: "http://localhost:5000/users/auth/github/callback",
  scope: ["gist"]
})

// called when a user is authenticated on any service
authom.on("auth", function(req, res, data) {
  console.log('Hit Auth!\n');
  console.log(data);
  console.log(req);
  res.send(
    "<html>" +
      "<body>" +
        "<div style='font: 300% sans-serif'>You are " + data.id + " on " + data.service + ".</div>" +
        "<pre><code>" + JSON.stringify(data, null, 2) + "</code></pre>" +
      "</body>" +
    "</html>"
  );
})

ss.client.define('chat', {
  view: 'chat.jade',
  css:  ['chat.styl'],
  code: ['libs', 'modules', 'main']
});

// ss.http.router.on('/', function(req, res) {
//   res.serve('chat');
// });

// ss.session.store.use('redis', {redis: {host: 'localhost', port: 6379}});
// ss.publish.transport.use('redis', {redis: {host: 'localhost', port: 6379}});

ss.ws.transport.use('socketio');

// Remove to use only plain .js, .html and .css files if you prefer
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-jade'));
ss.client.formatters.add(require('ss-stylus'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimise and pack assets if you type  SS_ENV=production node app.js
if (ss.env == 'production') ss.client.packAssets();

app.get('/login', function(req, res){
  console.log('Hello there!\n')
  res.send('<a href="/users/auth/github/callback">login via github</a>');
});

app.get("/users/auth/:service/callback", authom.app);


app.get('/chat', function(req, res){
  res.serve('chat');
});

app.stack = app.stack.concat(ss.http.middleware.stack)

// var server = http.Server(ss.http.middleware);
server = app.listen(5000);
ss.start(server);