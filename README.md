Studio Asset Service Uploader
=============================

An uploader for the studio asset service


example uploader usage:

```
class MessageUploader extends StudioAssetBaseUploader
  template: ->
    """
      <div class="message__attachment">
        <span class="message__attachment__icon hot-icon__paper-clip"></span>
        <span class="message__attachment__filename"></span>
        <div class="dz-progress"><span class="message__attachment__mask dz-upload" data-dz-uploadprogress></span></div>
        <span class="dz-percent message__attachment__percent">0%</span>
        <img data-dz-thumbnail>
      </div>
    """

  _initializeUploader: =>
    @_createUploader
      url: @options.uploadEndpoint
      thumbnailWidth: 80
      thumbnailHeight: 80
      previewTemplate: @template()
      previewsContainer: @options.previewsContainer
```

then to initialize:

```
var uploader = new MessageUploader({
  el: ".asset-uploader",
  previewsContainer: ".asset-preview-images",
  hiddenFieldName: "job_event[attachment_uuids][]",
  uploadEndpoint: "http://url-to-uploader.com/upload,
  assetServiceLink: { href: "http://asset-service.com/asset", payload: { type: "message-asset" } }
});
```



TODO:
- Tests and Build pipeline
- spit out an artefact that can be used by bower/npm
