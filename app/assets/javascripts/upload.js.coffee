$(document).ready ->
  $("#phrase_upload_form").fileupload
    singleFileUploads: true
    sequentialUploads: true
    dataType: "json"
    paramName: "sourcemod_plugin[file]"
    acceptFileTypes: /(\.|\/)(txt|zip)$/i
    downloadTemplateId: false
    limitConcurrentUploads: 1
    done: (e, data) ->
      context = data.context[0]
      result = data.result
      $("td.cancel", context).html ""
      $("div.progress", context).removeClass("progress-striped active")
      if result.status == "ok" && result.phrases>=0
        $("td.start", context).text "#{result.phrases} phrases"
      else
        $("td.start", context).text "Failure"
        $("div.progress", context).removeClass("progress-success").addClass("progress-danger")
      #console.log(data)
      return
    stop: (e, data) ->
      $("#upload_finished").show()
      $(".fileupload-progress .progress").removeClass("active progress-striped")
      return

  return