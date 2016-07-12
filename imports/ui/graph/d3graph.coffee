#little helpers
oneHour = 60 * 60 * 1000
oneDay = 24 * oneHour
{floor, random, round} = Math
updateFunc = ->

makeDoseData = (n) -> ( for d in [1..n]
  date : new Date 2016, 0, d, 12
  inTake : floor(random() * 5) / 4
)

makeInrData = (n) -> ( for d in [1..n]
  date : new Date 2016, 0, d*7, 11, 59, 59
  inr : floor(random() * 31) / 10
)

share.newDoseGraph = (caller, callback)->

  decay = (n0, dt) ->
    n0 * 2 ** (-dt / oneDay / 6.5)

  doseFunction = (n0, t0, ta) ->
    (t) ->
      if t < t0
        0
      else if t < (new Date t0.valueOf()+ta)
        (t-t0) / ta * n0
      else
        decay n0, t-t0-ta

  addDoseFunctions = (doseFunc1, doseFunc2) ->
    (t) ->
      doseFunc1(t) + doseFunc2(t)

  margin =
    top : 20
    right : 40
    bottom : 30
    left : 40

  leftViz = d3.select "#left-viz"
  centerViz = d3.select "#center-viz"
  rightViz = d3.select "#right-viz"
  vizzes = d3.select "#vizzes-container"

  chart = centerViz.append "g"
    .attr "transform", "translate(0, #{margin.top})"
  dosePath = chart.append "path"
    .attr "class", "dose-path"
  xAxisGroup = chart.append "g"
    .attr "class", "time-axis"
  yAxisGroup = leftViz.append "g"
    .attr "class", "dose-axis"
    .attr "transform", "translate(#{margin.left - 1}, #{margin.top})"
  inrAxisGroup = rightViz.append "g"
    .attr "class", "inr-axis"
    .attr "transform", "translate(0, #{margin.top})"
  tip = d3.select("body").append "div"
    .attr "class", "tooltip"

  update = (opt) ->
    #defaults
    opt.res ?= 3
    opt.startDate ?= new Date()
    opt.endDate ?= new Date() + oneDay*7
    opt.dayWidth ?= 20
    opt.height ?= 400
    opt.interpolation ?= "linear"
    opt.tAbsorb ?= 1

    inTakeData = opt.inTakeData
    inrData = opt.inrData

    # Doing the Math
    # Build the function
    calcDose = (t) -> 0
    for d in inTakeData
      calcDose = addDoseFunctions calcDose,
        doseFunction d.inTake, d.date, opt.tAbsorb*oneDay

    # Calculate the data points
    doseData = (
      for t in [opt.startDate.valueOf()..opt.endDate.valueOf()] by opt.res*oneHour
        date :  new Date(t)
        dose :  calcDose(t)
    )

    # Set dates for mouseover boxes
    dayData = (
      for t in [opt.startDate.valueOf()..opt.endDate.valueOf()] by oneDay
        date : new Date (t)
    )

    centerWidth = doseData.length * opt.res / 24 * opt.dayWidth
    height = opt.height

    vizzes
      .attr "width", centerWidth + margin.left + margin.right

    centerViz
      .attr "width", centerWidth
      .attr "height", height

    leftViz
      .attr "width", margin.left
      .attr "height", height

    rightViz
      .attr "width", margin.right
      .attr "height", height

    x = d3.time.scale()
      .domain [d3.min(doseData, (d) -> d.date),
               d3.max(doseData, (d) -> d.date)]
      .range [0, centerWidth]

    y = d3.scale.linear()
      .domain [0,
               d3.max(doseData, (d) -> d.dose)]
      .range [height - margin.top - margin.bottom, 0]

    inrY = d3.scale.linear()
      .domain [0,
               d3.max(inrData, (d) -> d.inr)]
      .range [height - margin.top - margin.bottom, 0]


    pathFunc = d3.svg.line()
      .x (d) -> x d.date
      .y (d) -> y d.dose
      .interpolate opt.interpolation

    dosePath
      .transition()
      .attr "d", pathFunc doseData

    inTakeBar = chart.selectAll ".intake-bar"
      .data inTakeData

    inTakeBar.enter().append "line"
      .attr "class", "intake-bar"

    inTakeBar
      .transition()
      .style "opacity", (d) ->
        if opt.startDate < d.date < opt.endDate
          .7
        else
          0
      .style "stroke-width", opt.dayWidth
      .attr "x2", (d) -> x d.date
      .attr "y2", (d) -> y d.inTake
      .attr "x1", (d) -> x d.date
      .attr "y1", (d) -> y 0

    inTakeBar.exit().remove()

    inrPoint = chart.selectAll ".inr-point"
      .data inrData

    inrPoint.enter().append "circle"
      .attr "class", "inr-point"

    inrPoint
      .transition()
      .style "opacity", (d) ->
        if opt.startDate < d.date < opt.endDate
          .7
        else
          0
      .attr "cx", (d) -> x d.date
      .attr "cy", (d) -> inrY d.inr
      .attr "r", opt.dayWidth/2

      inrPoint.exit().remove()

    dayGroup = chart.selectAll ".day-group"
      .data dayData

    showTip = (d) ->
      tip
        .html "#{d.date.toLocaleDateString()}"
        .style "top", "#{d3.event.pageY-30}px"
        .style "left", "#{d3.event.pageX-30}px"
        .transition()
        .style "opacity", .9

    hideTip = ->
      tip
        .transition()
        .style "opacity", 0

    dayGroup.enter().append "g"
      .attr "class", "day-group"
    .append "rect"
      .attr "class", "day-box"

    dayGroup
      .attr "transform", (d) -> "translate(#{x d.date}, 0)"
      .on "mouseover", (d,i) ->
        showTip d
      .on "mouseleave", (d,i) ->
        hideTip()
      .on "click", (d,i) ->
        callback.call caller, d, i

    dayGroup.selectAll ".day-box"
      .attr "width", opt.dayWidth
      .attr "height", height - margin.top - margin.bottom


    dayGroup.exit().remove()

    xAxis = d3.svg.axis()
      .scale x
      .orient "bottom"

    yAxis = d3.svg.axis()
      .scale y
      .orient "left"

    inrAxis = d3.svg.axis()
      .scale inrY
      .orient "right"

    xAxisGroup
      .transition()
      .attr "transform", "translate(0, #{height - margin.bottom - margin.top})"
      .call xAxis

    yAxisGroup
      .transition()
      .call yAxis

    inrAxisGroup
      .transition()
      #.attr "transform", "translate(#{width-margin.left - margin.right}, 0)"
      .call inrAxis

  #return
  update : update
