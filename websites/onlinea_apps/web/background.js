
chrome.app.runtime.onLaunched.addListener(function(launchData) {
  chrome.app.window.create('set_discussion_forum_properties.html', {
    'id': '_mainWindow', 'bounds': {'width': 800, 'height': 600 }
  });
});
