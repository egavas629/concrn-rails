class Upload < ActiveRecord::Base
  belongs_to :report

  has_attached_file :file
  do_not_validate_attachment_file_type :file

  def file_image_url
    type = file_content_type.split("/")[0]
    if type == "image"
      file.url
    else
      ActionController::Base.helpers.asset_path("paperclip.png")
    end
  end
end
