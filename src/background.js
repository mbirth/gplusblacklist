chrome.tabs.onUpdated.addListener(
    function(tabId, changeInfo, tab) {
        if (tab.url.indexOf('://plus.google.com/') > -1) {
            chrome.pageAction.show(tabId);
        }
    }
);

chrome.extension.onRequest.addListener(
    function(request, sender, sendResponse) {
        if (request.method == "getBlacklist") {
            sendResponse({blacklist: JSON.parse(localStorage["blacklist"])});
        }
    }
);