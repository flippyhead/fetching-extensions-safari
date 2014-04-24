Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $
window.$ = $
MeteorDdp = require './ddp'

class GlobalView extends Backbone.View

  initialize: ->
    console.debug "GLOBAL: Initializing."

    @settings = safari.extension.secureSettings
    @settings.host = "fetching.io"  unless @settings.host

    @extension = safari.extension
    @starButton = @extension.toolbarItems[0]

    safari.application.addEventListener "message", @performLoaded, true
    safari.application.addEventListener "command", @toggleBookmark, false
    safari.application.addEventListener "navigate", @findDocument, true
    safari.application.addEventListener "activate", @findDocument, true

  findDocument: (e) =>
    {target} = e
    return unless target instanceof SafariBrowserTab

    $.ajax
      method: 'POST'
      url: "http://#{@settings.host}/documents/search"
      data:
        token: safari.extension.secureSettings.accessToken
        url: target.url
      success: (doc) =>
        @setBookmarked doc
      error: (err) ->
        console.error 'GLOBAL: Error retrieving document: ', err

  performLoaded: (e) =>
    return unless e.name is "page-loaded"
    return if not @settings.accessToken or @settings.indexingPaused is true

    console.debug "GLOBAL: Posting page contents."

    $.ajax
      method: 'POST'
      url: "http://#{@settings.host}/documents"
      data:
        body: e.message.body
        title: e.message.title
        token: safari.extension.secureSettings.accessToken
        url: e.message.url
      success: (doc) =>
        @setBookmarked doc
      error: (err) ->
        switch err.status
          when 550
            console.debug 'GLOBAL: Url blocked by Url Pattern.'
          else
            console.error 'GLOBAL: Error saving document: ', err

  toggleBookmark: (e) =>
    return if e.command isnt "bookmark"
    url = safari.application.activeBrowserWindow.activeTab.url

    $.ajax
      method: 'PUT'
      data:
        token: @settings.accessToken
        url: url
      url: "http://#{@settings.host}/documents/bookmark"
      success: (doc) =>
        @setBookmarked doc
      error: (err) ->
        console.error 'GLOBAL: Error bookmarking document: ', err

  setBookmarked: (doc) ->
    @starButton.image = if doc.bookmarked
      @extension.baseURI + 'star-full.png'
    else
      @extension.baseURI + 'star-empty.png';

$(document).ready ->
  new GlobalView