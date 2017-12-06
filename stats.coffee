command: "sh nerdbar.widget/scripts/stats.sh"

refreshFrequency: 3000 # ms

render: (output) ->
  """
    <link rel="stylesheet" type="text/css" href="./nerdbar.widget/colors.css" />
    <div class='stats'></div>
  """

style: """
  right: 350px
  top: 8px
  color: #66d9ef
  height: 13
  .wifi
    font: 14px FontAwesome
    top: 1px
    position: relative
    left: 10px
"""


getCPU: (cpu) ->
  cpuNum = parseFloat(cpu)
  # I have four cores, so I divide my CPU percentage by four to get the proper number
  cpuNum = cpuNum/8
  cpuNum = cpuNum.toFixed(1)
  cpuString = String(cpuNum)
  if cpuNum < 10
    cpuString = '0' + cpuString
  return "<span class='icon'>&nbsp </span>" +
         "<span class='white'>#{cpuString}%</span>"

getMem: (mem) ->
  memNum = parseFloat(mem)
  memNum = memNum.toFixed(1)
  memString = String(memNum)
  if memNum < 10
    memString = '0' + memString
  return "<span class='icon'>&nbsp </span>" +
         "<span class='white'>#{memString}%</span>"

convertBytes: (bytes) ->
  kb = bytes / 1024
  return @usageFormat(kb)

usageFormat: (kb) ->
    mb = kb / 1024
    if mb < 0.01
      return "0.00mb"
    return "#{parseFloat(mb.toFixed(2))}MB"

getNetTraffic: (down, up) ->
  downString = @convertBytes(parseInt(down))
  upString = @convertBytes(parseInt(up))
  return "<span>&nbsp</span><span class='icon blue'> </span>" +
         "<span class='white'>#{downString} " +
         "<span class='icon orange'> </span>" +
         "<span class='white'>#{upString}</span>"

getWifiStatus: (status, netName, netIP) ->
  if status == "Wi-Fi"
    return "<span class='wifi'> &nbsp</span>"#<span class='white'>#{netName}&nbsp</span>"
  if status == 'USB 10/100/1000 LAN' or status == 'Apple USB Ethernet Adapter'
    return "<span class='wifi '> &nbsp</span>"#<span class='white'>Ethernet</span>"
  else
    return "<span class='grey wifi'> &nbsp</span>"#<span class='white'>--&nbsp&nbsp&nbsp</span>"

getFreeSpace: (space) ->
  return "<span class='icon'> </span><span class='white'>#{space}gb</span>"

update: (output, domEl) ->

  # split the output of the script
  values = output.split('@')

  cpu = values[0]
  mem = values[1]
  down = values[2]
  up   = values[3]
  netStatus = values[5].replace /^\s+|\s+$/g, ""
  netName = values[6]
  netIP = values[7]
#  free = values[4].replace(/[^0-9]/g,'')

  # create an HTML string to be displayed by the widget
  htmlString =  @getWifiStatus(netStatus, netName, netIP) +
                @getNetTraffic(down, up) + "<span class='cyan'>&nbsp⎢&nbsp</span>" +
               # @getMem(mem) + "<span class='cyan'>&nbsp⎢&nbsp</span>" +
                @getCPU(cpu) + "<span class='cyan'>&nbsp⎢&nbsp</span>"# +
            #    @getFreeSpace(free)

  $(domEl).find('.stats').html(htmlString)
