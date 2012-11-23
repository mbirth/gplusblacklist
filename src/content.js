blacklistFilter = function(blacklist) {
    if (blacklist) {
        var nodes = document.getElementsByClassName("Tg");
        for (var i = 0; i < nodes.length; i++) {
            var hideBtn = nodes[i].getElementsByClassName("hidden");
            if (hideBtn[0]) {
                var contents = nodes[i].getElementsByClassName("qf");
                if (contents[0]) {
                    contents[0].style.display = "block";
                }
                nodes[i].removeChild(hideBtn[0]);
            }
            for (var j = 0; j < blacklist.length; j++) {
                if (nodes[i].innerHTML.toLowerCase().indexOf(blacklist[j].toLowerCase()) != -1) {
                    var contents = nodes[i].getElementsByClassName("qf");
                    if (contents[0]) {
                        contents[0].style.display = "none";
                    }
                    
                    var newdiv = document.createElement("div");
                    newdiv.setAttribute("id", "blacklist_item_" + i);
                    newdiv.setAttribute("class", "hidden");
                    newdiv.innerHTML = "Hidden: \"" + blacklist[j] + "\"";
                    
                    var newbtn = document.createElement("input");
                    newbtn.setAttribute("type", "button");
                    newbtn.setAttribute("id", "blacklist_btn_" + i);
                    newbtn.setAttribute("value", "Unhide");
                    newbtn.removeId = i;
                    removeFunc =  function(event) {
                        var hiddenContents = nodes[event.target.removeId].getElementsByClassName("qf");
                        hiddenContents[0].style.display = "block";
                        var unhideBtn = nodes[event.target.removeId].getElementsByClassName("hidden")[0];
                        
                        nodes[event.target.removeId].removeChild(unhideBtn);
                    }
                    newbtn.addEventListener("click", removeFunc, false);
                    newdiv.appendChild(newbtn);
                    
                    nodes[i].appendChild(newdiv);
                }
            }
        }
    }
}

blacklist = function() {
    chrome.extension.sendRequest({method: "getBlacklist"}, function(response) {
        if (response.blacklist) {
            blacklistFilter(response.blacklist);
        }
    });
}

chrome.extension.onMessage.addListener(function (request, sender, sendResponse) {
    blacklistFilter(request.blacklist);
});

blacklist();
document.getElementsByClassName("ow")[0].addEventListener("DOMNodeInserted",
    function(event) {
        if (event.target.children
            && event.target.children[0]
            && event.target.children[0].firstChild
            && event.target.children[0].firstChild.className
            && event.target.children[0].firstChild.className == "ii"
        ) {
            blacklist();
        }
    },
    false
);