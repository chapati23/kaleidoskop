$(document).ready ->

    # PARAMETER: *s* is the speed of the automatic timeout animation.

    # PARAMETER: *n* is the number of segments.

    # PARAMETER: *src* is the URL for an alternate image.

    # PARAMETER: *clean* hides the Github and fullscreen links.

    # PARAMETER: *opacity* sets opacity (0.0 -> 1.0).

    # PARAMETER (undocumented): *mode* changes the animation style.

    # Project changes in cursor (x, y) onto the image background position.

    # An alternate image can be supplied via Dragon Drop.
    readFile = (file) ->
        r = new FileReader()
        return false    unless file.type.match("image/.*")
        r.onload = (e) ->
            $image.css "background-image", [
                "url("
                e.target.result
                ")"
            ].join("")
            return

        r.readAsDataURL file
        return

    # Request Fullscreen for maximum LSD effect

    # Animate all the things!
    animate = ->
        time = new Date().getTime() * [
            ".0000"
            s
        ].join("")
        auto_x = Math.sin(time) * document.body.clientWidth
        auto_y++
        move auto_x, auto_y
        requestAnimFrame animate    if auto
        return
    move = (x, y) ->
        $image.css "background-position", [
            x + "px"
            y + "px"
        ].join(" ")
        return
    parameters = ((src) ->
        params = {}
        qryStr = src.split("?")[1]
        if qryStr
            $.each qryStr.split("&"), (i, p) ->
                ps = p.replace(/\/$/, "").split("=")
                k = ps[0].replace(/^\?/, "")
                params[k] = ps[1] or true
                return

        params
    )(location.search)
    x = 0
    y = 0
    auto = undefined
    auto_x = 0
    auto_y = 0
    auto_throttle = undefined
    s = parameters.s or 3
    n = ~~parameters.n or 6
    tiles = ""
    if n
        i = 0

        while i <= n * 2
            tiles += [
                "<div class=\"tile t"
                i
                "\"><div class=\"image\"></div></div>"
            ].join("")
            i++
    $kaleidescope = $(".kaleidoscope").addClass("n" + n).append(tiles)
    $image = $kaleidescope.find(".image")
    $fullscreen = $("#fullscreen")
    k = $kaleidescope[0]
    src = parameters.src
    if src
        $image.css "background-image", [
            "url("
            decodeURIComponent(src)
            ")"
        ].join("")
    clean = parameters.clean
    $("body").addClass "clean"    if clean
    opacity = parseFloat(parameters.opacity)
    $kaleidescope.css("opacity", 0).fadeTo 3000, opacity    if opacity
    mode = ~~parameters.mode or 2
    $kaleidescope.mousemove (e) ->
        x++
        y++
        nx = e.pageX
        ny = e.pageY
        switch mode
          when 1
                nx = -x
                ny = e.pageY
          when 2
                nx = e.pageX
                ny = -y
          when 3
                nx = x
                ny = e.pageY
          when 4
                nx = e.pageX
                ny = y
          when 5
                nx = x
                ny = y
        move nx, ny
        auto = auto_throttle = false
        return

    if "draggable" of document.createElement("b") and window.FileReader
        k.ondragenter = k.ondragover = (e) ->
            e.preventDefault()
            return

        k.ondrop = (e) ->
            readFile e.dataTransfer.files[0]
            e.preventDefault()
            return
    $fullscreen.click ->
        if document.fullscreenEnabled or document.mozFullScreenEnabled or document.webkitFullscreenEnabled
            k.requestFullscreen()    if k.requestFullscreen
            k.mozRequestFullScreen()    if k.mozRequestFullScreen
            k.webkitRequestFullscreen()    if k.webkitRequestFullscreen
        return

    window.requestAnimFrame = ((window) ->
        suffix = "equestAnimationFrame"
        rAF = [
            "r"
            "webkitR"
            "mozR"
        ].filter((val) ->
            val + suffix of window
        )[0] + suffix
        window[rAF] or (callback) ->
            window.setTimeout (->
                callback +new Date()
                return
            ), 1000 / 60
            return
    )(window)

    # Timer to check for inactivity
    (timer = ->
        setTimeout (->
            timer()
            if auto and not auto_throttle
                animate()
                auto_throttle = true
            else
                auto = true
            return
        ), 5000
        return
    )()
    return

