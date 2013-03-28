
PluginStatsGraphs = {}

PluginStatsGraphs.activityGraph = ->
  $.ajax $("#plugin_activity_graph").data("source"),
    success: (data) ->

      activity = []
      for date,point of data.activity
        activity.push
          d: date
          t: point

      Morris.Line
        element: 'plugin_activity_graph'
        data: activity.slice(data.created_index)
        xkey: 'd'
        ykeys: ['t']
        labels: ["Translations"]
        hideHover: 'always'
        lineColors: ["#0088cc"]
        eventStrokeWidth: 2
        continuousLine: true
        events: [data.created_week]
        ymax: data.max + 10
    dataType: "json"
  return




$(document).ready ->
  if $("#plugin_activity_graph").length > 0 
    PluginStatsGraphs.activityGraph()
