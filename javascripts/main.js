// Generated by CoffeeScript 1.6.3
window.addEventListener("load", function(e) {
  var location;
  console.debug("Page loaded.");
  if (window.top === window) {
    location = document.location.toString();
    console.debug("Processed " + location);
    if (location.indexOf('fetching.io') > 0) {
      return;
    }
    return safari.self.tab.dispatchMessage("page-loaded", {
      body: document.body.innerText,
      title: document.title,
      url: location
    });
  }
}, false);