class Attachment < ApplicationRecord
  belongs_to :question, optional: true

  mount_uploader :file, FileUploader
end
