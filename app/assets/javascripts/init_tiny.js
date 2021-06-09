window.addEventListener('DOMContentLoaded', function () {
  if(!window.location.href.match('broker/region/edit')) return
  tinyMCE.init({
    selector: 'textarea.tinymce-js',
    height: 500,
    menubar: false,
    statusbar: false,
    toolbar: 'code | styleselect | bold italic underline strikethrough | undo redo | tableinsertrowbefore tableinsertrowafter tabledeleterow | image | link | media',
    table_toolbar: 'tableinsertrowbefore tableinsertrowafter tabledeleterow',
    style_formats: [
      {
        title: 'Header 1',
        format: 'h1'
      },
      {
        title: 'Header 2',
        format: 'h2',
      },
      {
        title: 'Header 3',
        format: 'h3'
      }
    ],
    extended_valid_elements: 'img[class=img-responsive|src|border=0|alt|title|hspace|vspace|width=auto|height=auto|align|onmouseover|onmouseout|name]',
    image_dimensions: false,
    file_picker_callback: function (cb, value, meta) {
      var input = document.createElement('input');
      input.setAttribute('type', 'file');
      input.setAttribute('accept', 'image/*');
      input.onchange = function () {
        var file = this.files[0];
        var reader = new FileReader();
        reader.onload = function () {
          var id = 'blobid' + (new Date()).getTime();
          var blobCache = tinymce.activeEditor.editorUpload.blobCache;
          var base64 = reader.result.split(',')[1];
          var blobInfo = blobCache.create(id, file, base64);
          blobCache.add(blobInfo);
          cb(blobInfo.blobUri(), {title: file.name});
        };
        reader.readAsDataURL(file);
      };
      input.click();
    },
    plugins: 'code table image link media',
    media_filter_html: false,
    init_instance_callback: function (e) {
      if (e.id === 'region[content]') {
        e.contentDocument.body.innerHTML = gon.content
      } else if (e.id === 'region_contanct_content') {
        e.contentDocument.body.innerHTML = gon.contact_content
      }
    },
  });
})

