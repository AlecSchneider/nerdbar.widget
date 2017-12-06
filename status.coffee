command: "sh nerdbar.widget/scripts/status.sh"

refreshFrequency: 10000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="./nerdbar.widget/colors.css" />
    <div class="compstatus"></div>
  """

style: """
  right: 60px
  top: 8px
  height: 13
  .wifi
    font: 14px FontAwesome
    top: 1px
    position: relative
    left: 10px
  .charging
    font: 12px FontAwesome
    position: relative
    top: 0px
    right: -12px
    z-index: 1
  """
timeAndDate: (date, time) ->
  # returns a formatted html string with the date and time
  return "<span class='white'><span class='icon'>&nbsp </span>#{date}&nbsp<span class='icon'> </span>#{time}</span></span>";

batteryStatus: (battery, state) ->
  #returns a formatted html string current battery percentage, a representative icon and adds a lighting bolt if the
  # battery is plugged in and charging
  batnum = parseInt(battery)
  if state == 'AC' and batnum >= 90
    return "<span class='charging white sicon'></span><span class='green icon '> </span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum >= 50 and batnum < 90
    return "<span class='charging white icon'></span><span class='green icon'> </span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 50 and batnum >= 15
    return "<span class='charging white icon'></span><span class='yellow icon'> </span><span class='white'>#{batnum}%</span>"
  else if state == 'AC' and batnum < 15
    return "<span class='charging white icon'></span><span class='red icon'> </span><span class='white'>#{batnum}%</span>"
  else if batnum >= 90
    return "<span class='green icon'>&nbsp </span><span class='white'>#{batnum}%</span>"
  else if batnum >= 50 and batnum < 90
    return "<span class='green icon'>&nbsp </span><span class='white'>#{batnum}%</span>"
  else if batnum < 50 and batnum >= 25
    return "<span class='yellow icon'>&nbsp </span><span class='white'>#{batnum}%</span>"
  else if batnum < 25 and batnum >= 15
    return "<span class='yellow icon'>&nbsp </span><span class='white'>#{batnum}%</span>"
  else if batnum < 15
    return "<span class='red icon'>&nbsp </span><span class='white'>#{batnum}%</span>"

#getReminders: (reminders) ->
#  return "<span class='reminders'><span class='icon'> </span></span><span class='white'>#{reminders}&nbsp</span>"

getMail: (mail) ->
  return "<span class='mail'><span class='icon'> </span></span><span class='white'>#{mail}&nbsp</span>"

#getMessages: (messages) ->
#  return "<span class='messages'><span class='icon'> </span></span><span class='white'>#{messages}&nbsp</span>"
  

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  time = values[0].replace /^\s+|\s+$/g, ""
  date = values[1]
  battery = values[2]
  isCharging = values[3]
  netStatus = values[4].replace /^\s+|\s+$/g, ""
  netName = values[5]
  netIP = values[6]
#  reminders = values[7].replace /^\s+|\s+$/g, ""
  mail = values[8].replace /^\s+|\s+$/g, ""
#  messages = values[8]

  # create an HTML string to be displayed by the widget
  htmlString =  @batteryStatus(battery, isCharging) + "<span>" + " ⎢ " + "</span>" +
             #  @getMessages(messages) +
               @getMail(mail) + "<span>⎢ </span>" +
              # @getReminders(reminders) + "<span>⎢</span>" +
               @timeAndDate(date,time) + "<span> ⎢ </span>"

  $(domEl).find('.compstatus').html(htmlString)
