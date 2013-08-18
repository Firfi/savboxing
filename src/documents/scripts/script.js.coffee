$ ->
  $(".fancybox").fancybox()

  $body = $(document.body)

  getRootUrl = ->
    rootUrl = document.location.protocol + "//" + (document.location.hostname or document.location.host)
    rootUrl += ":" + document.location.port  if document.location.port or false
    rootUrl += "/"
    rootUrl

  # Selectors

  # Internal Helper
  $.expr[":"].internal = (obj, index, meta, stack) ->
    # Prepare
    $this = $(obj)
    url = $this.attr("href") or $this.data("href") or ""
    rootUrl = getRootUrl()

    # Check link
    isInternalLink = url.substring(0, rootUrl.length) is rootUrl or url.indexOf(":") is -1

    # Ignore or Keep
    return isInternalLink


  # External Helper
  $.expr[":"].external = (obj, index, meta, stack) ->
    return $.expr[":"].internal(obj, index, meta, stack) is false

  # Open Link
  openLink = ({url,action}) ->
    if action is 'new'
      window.open(url,'_blank')
    else if action is 'same'
      wait = (delay,callback) -> setTimeout(callback,delay)
      wait(100, -> document.location.href = url)
    return

  # Open Outbound Link
  openOutboundLink = ({url,action}) ->
    # https://developers.google.com/analytics/devguides/collection/gajs/eventTrackerGuide
    hostname = url.replace(/^.+?\/+([^\/]+).*$/,'$1')
    _gaq?.push(['_trackEvent', "Outbound Links", hostname, url, 0, true])
    openLink({url,action})
    return

  # Outbound Link Tracking
  $body.on 'click', 'a[href]:external', (event) ->
    # Prepare
    $this = $(this)
    url = $this.attr('href')
    return  if !url or url.indexOf('mailto:') is 0

    # Discover how we should handle the link
    if event.which is 2 or event.metaKey
      action = 'default'
    else
      action = 'same'
      event.preventDefault()

    # Open the link
    openOutboundLink({url,action})

    # Done
    return