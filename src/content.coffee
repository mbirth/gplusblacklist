blacklistFilter = (blacklist) ->
    if not blacklist then return
    nodes = document.getElementsByClassName('Tg')
    for own i of nodes
        hideBtn = nodes[i].getElementsByClassName('hidden')
        if hideBtn[0]
            contents = nodes[i].getElementsByClassName('qf')
            contents[0]?.style.display = 'block'
            nodes[i].removeChild(hideBtn[0])

        for own j of blacklist
            if nodes[i].innerHTML.toLowerCase().indexOf(blacklist[j].toLowerCase()) is -1
                continue
            contents = nodes[i].getElementsByClassName('qf')
            contents[0]?.style.display = 'none'

            newdiv = document.createElement('div')
            newdiv.setAttribute('id', "blacklist_item_#{i}")
            newdiv.setAttribute('class', 'hidden')
            newdiv.innerHTML = "Hidden: \"#{blacklist[j]}\""

            newbtn = document.createElement('input')
            newbtn.setAttribute('type', 'button')
            newbtn.setAttribute('id', "blacklist_btn_#{i}")
            newbtn.setAttribute('value', 'Unhide')
            newbtn.removeId = i
            removeFunc = (event) ->
                hiddenContents = nodes[event.target.removeId].getElementsByClassName('qf')
                hiddenContents[0].style.display = 'block'
                unhideBtn = nodes[event.target.removeId].getElementsByClassName('hidden')[0]
                nodes[event.target.removeId].removeChild(unhideBtn)
            newbtn.addEventListener('click', removeFunc, false)
            newdiv.appendChild(newbtn)

            nodes[i].appendChild(newdiv)

blacklist = ->
    chrome.extension.sendRequest(
        method: 'getBlacklist',
        (response) ->
            if response.blacklist then blacklistFilter(response.blacklist)
    )

chrome.extension.onMessage.addListener( (request, sender, sendResponse) -> blacklistFilter(request.blacklist) )

blacklist()

document.getElementsByClassName('ow')[0].addEventListener( 'DOMNodeInserted',
    (event) ->
        blacklist() if event.target.children[1]?.getAttribute('role') is 'article'
    , false
)
