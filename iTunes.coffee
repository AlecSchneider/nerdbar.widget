command: "sh nerdbar.widget/scripts/itunes.sh"

refreshFrequency: 200 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="./colors.css" />
  """

style: """
  text-align: center
  top: 8px
  color: #fff
  height: 13
  width: 100%
"""

render: (output) -> """
 <span class='playing'><span class='icon blue'>&nbsp</span></span><span class='white'>#{output}</span>
"""
