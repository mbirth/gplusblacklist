chrome.tabs.onUpdated.addListener(
    (tabId, changeInfo, tab) ->
        if tab.url.indexOf('://plus.google.com/') > -1
            chrome.pageAction.show(tabId)
)

chrome.extension.onRequest.addListener(
    (request, sender, sendResponse) ->
        if request.method is 'getBlacklist'
            sendResponse(
                blacklist: JSON.parse(localStorage['blacklist'])
            )
)
