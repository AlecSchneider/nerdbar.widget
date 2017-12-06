command: "echo $(~/../../usr/local/bin/chunkc tiling::query --window tag)"
refreshFrequency: 2000 # ms

render: (output) ->
  """
<link rel="stylesheet" type="text/css" href="./colors.css" />
    <div class='kwmmode'></div>
  """

style: """
  -webkit-font-smoothing: antialiased
  left: 200px
  top: 8px
  width:850px
  """

update: (output, domEl) ->


  file = ""
  screenhtml = ""
  wins = output
  win = ""
  winseg = wins.split('@')
  file = winseg[winseg.length - 1]
  j = winseg.length - 1
  flag1 = 0
  flag2 = 0

  while file.length >= 100
   file = file.slice(0, -1)
   flag1 = 1

  if j > 1
    while j >= 1
      j -= 1
      if (win + file).length >= 100
        win = '.../' + win
        break
      else
        win = winseg[j] + '/' + win

  while win.length >= 100
    win = win.slice(1)
    flag2 = 1

  if flag1 >= 1
    file = file + '...'

  if flag2 >= 1
    win = '...' + win

  if output == ""
    win = "<span class='white'>...</span>"

  $(domEl).find('.kwmmode').html("<span class='icon'></span> " +
                                 "<span>#{win}</span><span class='white'>#{file}</span>")
