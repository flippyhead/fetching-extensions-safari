window.addEventListener "load", (e) ->
  console.debug "INJECTED: Page loaded."

  if window.top is window
    location = document.location.toString()
    console.debug "INJECTED: Processed #{location}"

    return if location.indexOf('fetching.io') > 0

    safari.self.tab.dispatchMessage "page-loaded",
      body: document.body.innerText
      title: document.title
      url: location

, false