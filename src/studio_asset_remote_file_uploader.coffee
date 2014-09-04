class StudioAssetRemoteFileUploader
  constructor: (options) ->
    @assetServiceLink = @options.assetServiceLink

  uploadFile: (fileUrl) ->
    @assetServiceLink.payload.fileUrl = fileUrl

    $.ajax
      url: @assetServiceLink.href
      async: false
      method: 'POST'
      data: @assetServiceLink.payload
      success: (data, status, xhr) =>
        console.log "DONE", data
