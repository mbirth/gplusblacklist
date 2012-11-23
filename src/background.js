chrome.extension.onRequest.addListener(
    function(request, sender, sendResponse) {
        if (request.method == "getBlacklist") {
            sendResponse({blacklist: JSON.parse(localStorage["blacklist"])});
        }
    }
);