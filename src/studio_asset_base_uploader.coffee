class StudioAssetBaseUploader
  hiddenField: (name, value) ->
    """
      <input type="hidden" name="#{name}" value="#{value}">
    """

  constructor: (options) ->
    @options = options
    @el = $(@options.el)
    @_initializeUploader()
    @listeners = []

  rebindElements: ->
    $(@el.selector).replaceWith(@el)
    $(@uploaderOptions.previewsContainer).replaceWith(@uploader.previewsContainer)
    $(@uploaderOptions.previewsContainer).empty()
    if @options.hiddenFieldName?
      @el.find("[name='#{@options.hiddenFieldName}']").remove()

  addUploadListener: (listener) ->
    @listeners.push(listener)

  triggerUploader: (err, file) ->
    for listener in @listeners
      listener(err, file)

  _initializeUploader: ->
    throw "Not implemented, make sure to call _createUploader in your implementation"

  _createUploader: (uploaderOptions) ->
    @uploaderOptions = uploaderOptions

    # We don't support a fallback for < IE 10 users.
    @uploaderOptions.fallback =
      ->

    @uploaderOptions["headers"] =
      "Accept": null
      "Cache-Control": null
      "X-Requested-With": null

    @uploader = new Dropzone @el.selector, uploaderOptions

    @uploader.on 'uploadprogress', (file, progress) ->
      $(file.previewElement).find('.dz-percent').html("#{Math.min(Math.floor(progress), 99)}%")

    @uploader.on "success", (file) =>
      @triggerUploader(null, file)

      if @options.hiddenFieldName?
        @el.append @hiddenField(@options.hiddenFieldName, file.assetId)

      $(file.previewElement).find('.dz-percent').html("")
      $(file.previewElement).find('.dz-progress').empty()
      $(file.previewElement).find('.remove').remove()

      $(document).trigger('upload:complete', file)

    @uploader.on "sending", (file, xhr, formData) =>
      $(document).trigger('upload:start', file)

      @_createAsset (err, data) =>
        formData.append 'signature', data.signature
        formData.append 'params', JSON.stringify(data.params)
        file.assetId = data.asset_id

    @uploader.on "addedfile", (file) =>
      fileName = if file.name.length > 13 then jQuery.trim(file.name).substring(0, 10).trim(this) + "..." else file.name

    @uploader.on "thumbnail", (file) =>
      $(file.previewElement).find('.message__attachment__icon').remove()
      $(file.previewElement).find('.message__attachment__filename').remove()

    @uploader

  _createAsset: (cb) ->
    $.ajax
      url: @options.assetServiceLink.href
      async: false
      method: 'POST'
      data: @options.assetServiceLink.payload
      success: (data, status, xhr) =>
        cb(undefined, {signature: data.transloadit.signature, params: data.transloadit.params, asset_id: data.asset.id})


if module?
  module.export = StudioAssetBaseUploader
else
  window.StudioAssetBaseUploader = StudioAssetBaseUploader
