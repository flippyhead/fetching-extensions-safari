window.addEventListener "load", (e) ->
  console.debug "Page loaded."

  if window.top is window
    console.debug "Page processed."

    safari.self.tab.dispatchMessage "page-loaded",
      body: document.body.innerText
      title: document.title
      url: document.location.toString()

, false