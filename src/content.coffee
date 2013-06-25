blacklistFilter = (blacklist) ->
    if not blacklist then return
    nodes = document.getElementsByClassName('Tg')
    for node, i in nodes
        hideBtn = node.getElementsByClassName('hidden')
        if hideBtn[0]
            contents = node.getElementsByClassName('qf')
            contents[0]?.style.display = 'block'
            node.removeChild(hideBtn[0])

        for blentry, j in blacklist
            continue if node.innerHTML.toLowerCase().indexOf(blentry.toLowerCase()) is -1

            contents = node.getElementsByClassName('qf')
            contents[0]?.style.display = 'none'

            newdiv = document.createElement('div')
            newdiv.setAttribute('id', "blacklist_item_#{i}")
            newdiv.setAttribute('class', 'hidden')
            newdiv.innerHTML = "Hidden: \"#{blentry}\""

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

            node.appendChild(newdiv)

blacklist = ->
    chrome.extension.sendRequest(
        method: 'getBlacklist',
        (response) ->
            blacklistFilter(response.blacklist) if response.blacklist
    )

chrome.extension.onMessage.addListener( (request, sender, sendResponse) -> blacklistFilter(request.blacklist) )

blacklist()

document.getElementsByClassName('ow')[0].addEventListener( 'DOMNodeInserted',
    (event) ->
        blacklist() if event.target.children[1]?.getAttribute('role') is 'article'
    , false
)
