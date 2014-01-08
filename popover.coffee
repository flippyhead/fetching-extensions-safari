console = safari?.extension.globalPage.contentWindow.console or console

class MainView extends Backbone.View

  el: '#container'

  events:
    'click #pause': (e) ->
      @settings.indexingPaused = on

    'click #resume': (e) ->
      @settings.indexingPaused = off

    'click #logout': (e) ->
      e.preventDefault()
      @settings.accessToken = null

    'submit #login': (e) ->
      e.preventDefault()
      email = $('[name=email]').val()
      password = $('[name=password]').val()

      ddp = new MeteorDdp 'ws://localhost:3001/websocket'
      ddp.connect().done =>
        ddp.call('login', [{user:{email}, password}]).done (resp) =>
          @settings.accessToken = resp.token

  initialize: ->
    @settings = safari?.extension.secureSettings or {}
    @settings.addEventListener 'change', (e) =>
      @showLogin() if e.key is 'accessToken'
      @showPaused() if e.key is 'indexingPaused'
    , false

    # DEBUG WITH:
    # @settings.accessToken = 'asasdfasf'
    # @settings.indexingPaused = false

  render: ->
    super
    @showLogin()
    @showPaused()
    @

  showPaused: ->
    $('#on-air').toggleClass 'hidden', @settings.indexingPaused
    $('#off-air').toggleClass 'hidden', not @settings.indexingPaused

  showLogin: ->
    $('#login').toggleClass 'hidden', @settings.accessToken?
    $('#main').toggleClass 'hidden', not @settings.accessToken?

$(document).ready ->
  new MainView(el: $('#container')).render()