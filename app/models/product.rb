class Product < ApplicationRecord
  mount_uploader :picture, PictureUploader
  mount_uploader :thumbnail, ThumbnailUploader
  has_rich_text :description
end
