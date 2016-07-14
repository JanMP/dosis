exports.thisYear = -> (new Date()).getFullYear()
exports.nextYear = -> exports.thisYear() + 1
exports.years = [1980..2050]
monthsSimple = [ "Januar", "Februar", "März", "April",
  "Mai", "Juni", "Julie", "August", "September",
  "Oktober", "November", "Dezember" ]
monthsObjects = (
  for month, i in monthsSimple
    ordinal : i + 1
    name : month
)
exports.months = monthsObjects
exports.monthName = (n) -> exports.months[n-1].name
exports.monthOrdinal = (s) -> exports.months.indexOf(s) + 1
