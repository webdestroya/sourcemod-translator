# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# TODO: Eventually, we will do an ajax search.
$(document).ready ->
  if $("#sourcemod_plugin_tag_list").size() > 0
    $("#sourcemod_plugin_tag_list").select2
      tags: $("#sourcemod_plugin_tag_list").data("all-tags").split(",")
      tokenSeparators: [",", " "]
      width: "325px"
      minimumInputLength: 2

  if $(".search-form").size() > 0
    $("#search_tags").select2
      width: "265px"

    $("#tags").select2
      width: "265px"
      tags: $("#tags").data("taglist").split(",")
      tokenSeparators: [","," "]
