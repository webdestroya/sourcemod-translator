
Metrics = {}

Metrics.loadUsersGraphs = ->
  return if $("#users_chart").size() == 0
  $.ajax "/metrics/users.json",
    success: (data) ->
      Morris.Area
        element: 'users_chart'
        data: data.metrics
        xkey: 'd'
        ykeys: ['u']
        labels: ["Users"]
        hideHover: true
        continuousLine: true

      Morris.Donut
        element: 'users_pie'
        data: data.providers

      return
  return

Metrics.loadTranslationsGraph = ->
  return if $("#translations_chart").size() == 0
  $.ajax "/metrics/translations.json",
    success: (data) ->
      Morris.Area
        element: 'translations_chart'
        data: data.metrics
        xkey: 'd'
        ykeys: ['w']
        labels: ["Web"]
        hideHover: true
        continuousLine: true
  return

Metrics.loadPluginsGraph = ->
  return if $("#plugins_chart").size() == 0
  $.ajax "/metrics/plugins.json",
    success: (data) ->
      Morris.Area
        element: 'plugins_chart'
        data: data.metrics
        xkey: 'd'
        ykeys: ['p']
        labels: ["Plugins"]
        hideHover: true
        continuousLine: true
  return


$(document).ready ->
  Metrics.loadTranslationsGraph() 
  Metrics.loadPluginsGraph() 
  Metrics.loadUsersGraphs()
  return