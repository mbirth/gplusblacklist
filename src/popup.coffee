readBlacklist = ->
    needles = JSON.parse(localStorage.getItem('blacklist'))
    blacklistItemsDiv = document.getElementById('blacklist_items')
    blacklistItemsDiv.innerHTML = ''
    if not needles then return
    for own i of needles
        color = if i%2 is not 0 then 'dark' else 'light'
        newdiv = document.createElement('div')
        newdiv.setAttribute('id', "blacklist_item_#{i}")
        newdiv.setAttribute('class', "blacklist_item #{color}")
        newdiv.innerHTML = "<div>#{needles[i]}</div>"

        newbtn = document.createElement('input')
        newbtn.setAttribute('type', 'button')
        newbtn.setAttribute('id', "blacklist_btn_#{i}")
        newbtn.setAttribute('value', 'Delete')
        newbtn.removeId = i
        removeFunc = (event) ->
            removeBlacklistItem(event.target.removeId)
        newbtn.addEventListener('click', removeFunc, false)
        newdiv.appendChild(newbtn)
        blacklistItemsDiv.appendChild(newdiv)

removeBlacklistItem = (id) ->
    needles = JSON.parse(localStorage.getItem('blacklist'))
    if needles[id]
        needles.splice(id, 1)
        localStorage.setItem('blacklist', JSON.stringify(needles))
    document.getElementById('addword_text').value = ''
    readBlacklist()
    renewBlacklist()

addBlacklistItem = (value) ->
    needles = JSON.parse(localStorage.getItem('blacklist'))
    if needles
        if value in needles then return
        needles.push(value)
    else
        needles = new Array(value)
    localStorage.setItem('blacklist', JSON.stringify(needles))
    document.getElementById('addword_text').value = ''
    document.getElementById('addword_text').focus()
    readBlacklist()
    renewBlacklist()

renewBlacklist = ->
    needles = JSON.parse(localStorage.getItem('blacklist'))
    needles ?= new Array()
    chrome.tabs.getSelected(null, (tab) ->
        chrome.tabs.sendMessage(tab.id, blacklist: needles, (response) ->)
    )

addEventListener(
    'load',
    ->
        addwordBtn = document.getElementById('addword_btn')
        addwordTxt = document.getElementById('addword_text')
        currentUrlDiv = document.getElementById('current_url')

        addwordBtn.addEventListener('click', ->
            addBlacklistItem(addwordTxt.value)
        , false)

        addwordTxt.addEventListener('keydown', (e) -> if e.keycode is 13 then addBlacklistItem(addwordTxt.value))

        addwordTxt.focus()

        readBlacklist()
    , false
)
