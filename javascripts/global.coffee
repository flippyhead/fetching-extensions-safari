require ['backbone'], (Backbone) ->

  class GlobalView extends Backbone.View

    performLoaded: (e) =>
      return unless e.name is "page-loaded"
      return if not @settings.accessToken or @settings.indexingPaused is true

      console.log "GLOBAL: Posting page contents."

      $.ajax
        method: 'POST'
        url: "http://#{@settings.host}/documents"
        data:
          body: e.message.body
          title: e.message.title
          token: safari.extension.secureSettings.accessToken
          url: e.message.url
        success: (@document) =>
          @setBookmarked()
        error: (err) ->
          console.error 'GLOBAL: Error saving document: ', err

    toggleBookmark: (e) =>
      return if e.command isnt "bookmark"
      $.ajax
        method: 'PUT'
        data:
          token: @settings.accessToken
        url: "http://#{@settings.host}/documents/#{@document._id}/bookmark"
        success: (@document) =>
          @setBookmarked()
        error: (err) ->
          console.error 'GLOBAL: Error bookmarking document: ', err

    setBookmarked: ->
      console.log @document
      @starButton.image = if @document.bookmarked
        @extension.baseURI + 'star-full.png'
      else
        @extension.baseURI + 'star-empty.png';

    initialize: ->
      console.log "GLOBAL: Initializing."

      @settings = safari.extension.secureSettings
      @settings.host = "localhost:3000"  unless @settings.host

      @extension = safari.extension
      @starButton = @extension.toolbarItems[0]

      safari.application.addEventListener "message", @performLoaded, true
      safari.application.addEventListener "command", @toggleBookmark, false


  new GlobalView