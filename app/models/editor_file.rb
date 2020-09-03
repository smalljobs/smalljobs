class EditorFile < ApplicationRecord
  mount_uploader :file, EditorFileUploader
end
