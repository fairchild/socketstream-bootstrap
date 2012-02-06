http    = require("http")
ss      = require("socketstream")
authom  = require("authom")
express = require("express")
app     = express.createServer()

github  = authom.createServer(
  service: "github"
  id: "6e084a8b6117d5cc16c3"
  secret: "5a6f1b27aa4b70d2d8930e3cf43c8ecce4c04b32"
  callback: "http://localhost:5000/users/auth/github/callback"
  scope: [ "gist" ])
  
authom.on "auth", (req, res, data) ->
  console.log "Hit Auth!\n"
  console.log data
  console.log req
  res.send "<html>" + "<body>" + "<div style='font: 300% sans-serif'>You are " + data.id + " on " + data.service + ".</div>" + "<pre><code>" + JSON.stringify(data, null, 2) + "</code></pre>" + "</body>" + "</html>"

ss.client.define "chat",
  view: "chat.jade"
  css: [ "chat.styl" ]
  code: [ "libs", "modules", "main" ]

ss.ws.transport.use "socketio"
ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")
ss.client.packAssets()  if ss.env is "production"
app.get "/login", (req, res) ->
  console.log "Hello there!\n"
  res.send "<a href=\"/users/auth/github/callback\">login via github</a>"

app.get "/users/auth/:service/callback", authom.app
app.get "/chat", (req, res) ->
  res.serve "chat"

app.stack = app.stack.concat(ss.http.middleware.stack)
server = app.listen(5000)
ss.start server
