http    = require "http"
ss      = require "socketstream"
authom  = require "authom"
express = require "express"

app     = express.createServer()

github  = authom.createServer(
  service:  "github"
  id:       "6e084a8b6117d5cc16c3"
  secret:   "5a6f1b27aa4b70d2d8930e3cf43c8ecce4c04b32"
  callback: "http://localhost:5000/users/auth/github/callback"
  scope:    [ "gist" ]
)
  
# use authom to authenticate from third party providers, such as github
authom.on "auth", (req, res, data) ->
  console.log "Hit Auth!\n"
  console.log data
  res.send "<html>" + "<body>" + "<div style='font: 300% sans-serif'>You are " + data.id + " on " + data.service + ".</div>" + "<pre><code>" + JSON.stringify(data, null, 2) + "</code></pre>" + "</body>" + "</html>"


ss.client.define "basic",
  view: "basic.jade"
  css:  [ "chat.styl" ]
  code: [ "libs", "modules", "main" ]

ss.client.define "fluid",
  view: "fluid.jade"
  css:  [ "chat.styl" ]
  code: [ "libs", "modules", "main" ]

ss.client.define "hero",
  view: "hero.jade"
  css:  [ "chat.styl" ]
  code: [ "libs", "modules", "main" ]

ss.ws.transport.use "socketio"
ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")

ss.client.packAssets()  if ss.env is "production"

app.get "/users/auth/:service/callback", authom.app

app.get "/hero", (req, res) ->
  res.serve "hero"

app.get "/fluid", (req, res) ->
  res.serve "fluid"

app.get "/", (req, res) ->
  res.serve "basic"

app.stack = app.stack.concat(ss.http.middleware.stack)
server = app.listen(5000)
ss.start server
