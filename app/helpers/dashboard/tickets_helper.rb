module Dashboard::TicketsHelper

  LABEL_BADGE_CLASS = {
    "normal" => "badge bg-label-info",
    "urgent" => "badge bg-label-danger",
    "minor" => "badge bg-label-warning"
  }.freeze

  def label_badge(label)
    badge_class = LABEL_BADGE_CLASS[label] || LABEL_BADGE_CLASS["normal"]
    content_tag(:span, label.titleize, class: badge_class)
  end


  def dropzone_controller_div
    data = {
      'upload-ticket-images-max-file-size'=>"8",
      'upload-ticket-images-max-files' => "10",
      'upload-ticket-images-accepted-files' => 'image/jpeg,image/jpg,image/png,image/gif',
      'upload-ticket-images-dict-file-too-big' => "Your image to the size of {{filesize}}, but only images to the size are allowed {{maxFilesize}} MB",
      'upload-ticket-images-dict-invalid-file-type' => "Incorrect file format. Only .jpg, .png or .gif images are allowed",
    }

    content_tag :div, class: 'dropzone dropzone-default dz-clickable', data: data do
      yield
    end
  end

end
