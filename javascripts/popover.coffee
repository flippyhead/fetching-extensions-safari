require ['backbone', 'meteor_ddp'], (Backbone, MeteorDdp) ->

  console = safari?.extension.globalPage.contentWindow.console or console
  console.debug 'POPOVER: started.'

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
        console.debug 'POPOVER: Logging in...'

        e.preventDefault()
        email = $('[name=email]').val()
        password = $('[name=password]').val()

        ddp = new MeteorDdp 'ws://fetching.io/websocket'
        ddp.connect().done =>
          console.debug 'POPOVER: Connected.'

          ddp.call('login', [{user:{email}, password}]).done (resp) =>
            console.debug 'POPOVER: Successfully logged in.', resp
            @settings.accessToken = resp.token

    initialize: ->
      console.debug 'POPOVER: INIT'
      @settings = safari?.extension.secureSettings or {}
      @settings.indexingPaused ?= off

      @settings.addEventListener 'change', (e) =>
        @showLogin() if e.key is 'accessToken'
        @showPaused() if e.key is 'indexingPaused'
      , false

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