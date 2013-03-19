$(document).ready ->
  $(".fancy-text [rel=tooltip]").tooltip('destroy')
  $(".fancy-text [rel=tooltip]").tooltip
    animation: false
  return