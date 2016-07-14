require "./settings.jade"
{ thisYear, nextYear, monthName, monthOrdinal, years, months } =
  require "./dateStuff.coffee"

Template.settings.viewmodel
  profile : -> Meteor.user()?.profile

Template.settingsForm.viewmodel
  months : months
  years : years
  startMonthName : -> monthName @startMonth()
  endMonthName : -> monthName @endMonth()
  saveEnabled : ->
    Number(@startMonth())/12 + Number(@startYear()) <
    Number(@endMonth())/12 + Number(@endYear())
  save : (event) ->
    event.preventDefault()
    Meteor.call "meth.updateSettings",
      startMonth : Number @startMonth()
      endMonth : Number @endMonth()
      startYear : Number @startYear()
      endYear : Number @endYear()
  autorun : [
    ->
      @startMonthSelect.dropdown "set selected", @startMonth()
      @startMonthSelect.dropdown "set text", @startMonthName()
    ->
      @endMonthSelect.dropdown "set selected", @endMonth()
      @endMonthSelect.dropdown "set text", @endMonthName()
    ->
      @startYearSelect.dropdown "set selected", @startYear()
      @startYearSelect.dropdown "set text", @startYear()
    ->
      @endYearSelect.dropdown "set selected", @endYear()
      @endYearSelect.dropdown "set text", @endYear()
    -> console.log "startMonth", @startMonth()
    -> console.log "endMonth", @endMonth()
    -> console.log "startYear", @startYear()
    -> console.log "endYear", @endYear()
  ]
