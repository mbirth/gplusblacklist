readBlacklist = function() {
    var needles = JSON.parse(localStorage.getItem("blacklist"));
    var blacklistItemsDiv = document.getElementById("blacklist_items");
    blacklistItemsDiv.innerHTML = "";
    if (needles) {
        for ( var i = 0; i < needles.length; i++ ) {
            var color = "light";
            if ( i % 2 != 0 ) {
                color = "dark";
            }
            var newdiv = document.createElement("div");
            newdiv.setAttribute("id", "blacklist_item_" + i);
            newdiv.setAttribute("class", "blacklist_item " + color);
            newdiv.innerHTML = "<div>" + needles[i] + "</div>";

            var newbtn = document.createElement("input");
            newbtn.setAttribute("type", "button");
            newbtn.setAttribute("id", "blacklist_btn_" + i);
            newbtn.setAttribute("value", "Delete");
            newbtn.removeId = i;
            removeFunc =  function(event) {
                removeBlacklistItem(event.target.removeId);
            }
            newbtn.addEventListener("click", removeFunc, false);
            newdiv.appendChild(newbtn);
            blacklistItemsDiv.appendChild(newdiv);
        }
    }
}

removeBlacklistItem = function(id) {
    var needles = JSON.parse(localStorage.getItem("blacklist"));
    if (needles[id]) {
        needles.splice(id, 1);
        localStorage.setItem("blacklist", JSON.stringify(needles));
    }
    document.getElementById("addword_text").value = "";
    readBlacklist();
    renewBlacklist();
}

addBlacklistItem = function(value) {
    var needles = JSON.parse(localStorage.getItem("blacklist"));
    if (needles) {
        for ( var i = 0; i < needles.length; i++ ) {
            if (needles[i] == value) {
                return;
            }
        }
        needles.push(value);
    } else {
        needles = new Array(value);
    }
    localStorage.setItem("blacklist", JSON.stringify(needles));
    document.getElementById("addword_text").value = "";
    document.getElementById("addword_text").focus();
    readBlacklist();
    renewBlacklist();
}

renewBlacklist = function() {
    var needles = JSON.parse(localStorage.getItem("blacklist"));
    if (!needles) {
        needles = new Array();
    }
    chrome.tabs.getSelected(null, function (tab) {
        chrome.tabs.sendMessage(tab.id,
            { blacklist: needles},
            function (response) {}
        );
    });
}

addEventListener("load", function() {
    var addwordBtn = document.getElementById("addword_btn");
    var addwordTxt = document.getElementById("addword_text");
    var currentUrlDiv = document.getElementById("current_url");

    addwordBtn.addEventListener("click",
        function() { addBlacklistItem(addwordTxt.value); }, false
    );
    
    addwordTxt.addEventListener("keydown",
        function(e) {
            if (e.keyCode == 13) {
                addBlacklistItem(addwordTxt.value);
            }
        }, false
    );
    
    addwordTxt.focus();
    
    readBlacklist();
}, false);