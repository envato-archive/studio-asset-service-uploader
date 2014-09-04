class StudioAssetRemoteFileUploader
  constructor: (options) ->
    @assetServiceLink = options.assetServiceLink

  uploadFile: (fileUrl, callback) ->
    @assetServiceLink.payload.fileUrl = fileUrl

    $.ajax
      url: @assetServiceLink.href
      async: false
      method: 'POST'
      data: @assetServiceLink.payload
      success: (data, status, xhr) =>
        callback(null, data.asset)

window.StudioAssetRemoteFileUploader = StudioAssetRemoteFileUploader
