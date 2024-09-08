import { Controller } from "@hotwired/stimulus";
import "dropzone";

export default class extends Controller {
  connect() {
    const previewTemplate = `
      <div class="dz-preview dz-file-preview">
        <div class="dz-details">
          <div class="dz-thumbnail">
            <img data-dz-thumbnail>
            <span class="dz-nopreview">No preview</span>
            <div class="dz-success-mark"></div>
            <div class="dz-error-mark"></div>
            <div class="dz-error-message"><span data-dz-errormessage></span></div>
            <div class="progress">
              <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuemin="0" aria-valuemax="100" data-dz-uploadprogress></div>
            </div>
          </div>
          <div class="dz-filename" data-dz-name></div>
          <div class="dz-size" data-dz-size></div>
        </div>
      </div>`;

    const myDz = new Dropzone('#dropzone-basic', {
      previewTemplate: previewTemplate,
      parallelUploads: 2,
      maxFilesize: 1,
      addRemoveLinks: true,
      maxFiles: 2,
      init: function () {
        this.on("sending", function (file, xhr, formData) {
          const fileType = getNextFileType();
          const paramName = `user[${fileType}]`;
          formData.append(paramName, file);
        });
      }
    });

    let uploadIndex = 0;

    function getNextFileType() {
      const types = ['first_valid_id', 'second_valid_id'];
      const type = types[uploadIndex] || 'file';
      uploadIndex++;
      return type;
    }
  }
}
