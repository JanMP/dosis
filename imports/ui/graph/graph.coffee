require "./d3graph.coffee"
require "./graph.jade"
require "./graph.sass"

{ Dosis } = require "/imports/api/dosis.coffee"

Template.graph.viewmodel
  startDate : -> new Date Meteor.user()?.profile?.startYear or 2015,
    Meteor.user()?.profile?.startMonth-1 or 0
  endDate : -> new Date Meteor.user()?.profile?.endYear or 2020,
    Meteor.user()?.profile?.endMonth-1 or 12
  inTakeData : ->
    Dosis.find
      userId : Meteor.userId()
      inTake :
        $exists : true
        $gt : 0
    .fetch().map (d) ->
      id : d._id
      date : new Date d.year, d.month, d.day, 12
      inTake : d.inTake
  inrData : ->
    Dosis.find
      userId : Meteor.userId()
      inr :
        $exists : true
        $gt : 0
    .fetch().map (d) ->
      date : new Date d.year, d.month, d.day, 11, 59, 59
      inr : d.inr

  interpolation : "basis"
  res : 3
  dayWidth : 20
  tAbsorb : 2

  editIsSet : false
  editDate : new Date()
  editFormattedDate : ""
  editInr : ""
  editInTake : ->
    @editDoc()?.inTake

  graph : {}

  editDoc : ->
    if @editIsSet()
      date = @editDate()
      doc = Dosis.findOne
        userId : Meteor.userId()
        year : date.getFullYear()
        month : date.getMonth()
        day : date.getDate()

  editSet : (d, i) ->
    @editDate d.date
    @editFormattedDate d.date.toLocaleDateString()
    @editIsSet true
    @editInr @editDoc()?.inr or ""
    @editInTake @editDoc()?.inTake or ""

  incInTake : ->
    date = @editDate()
    Meteor.call "meth.updateInTake",
      year : date.getFullYear()
      month : date.getMonth()
      day : date.getDate()
      plus : true

  decInTake : ->
    date = @editDate()
    Meteor.call "meth.updateInTake",
      year : date.getFullYear()
      month : date.getMonth()
      day : date.getDate()
      plus : false

  updateInr : ->
    date = @editDate()
    Meteor.call "meth.updateInr",
      year : date.getFullYear()
      month : date.getMonth()
      day : date.getDate()
      inr : Number(@editInr())

  onRendered : ->
    @graph = share.newDoseGraph this, @editSet
    $("#scrolling").perfectScrollbar()

  autorun : ->
    options =
      startDate : @startDate()
      endDate : @endDate()
      inTakeData : @inTakeData()
      inrData : @inrData()
      interpolation : @interpolation()
      res : @res()
      dayWidth : @dayWidth()
      tAbsorb : @tAbsorb()
    @graph.update options
    $("#scrolling").perfectScrollbar "update"
