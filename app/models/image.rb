class Image < ApplicationRecord
  belongs_to :theme

  # get images array of arrays by given theme_id
  scope :theme_images, -> (theme_id) {
    select('id','name','file','ave_value').where(theme_id: theme_id).order('id ASC')
  }
  scope :next_image, -> (theme_id, image_id) {
    select('id','name','file','ave_value').where(theme_id: theme_id).where('id > ?', image_id).order('id ASC').first
  }
  scope :prev_image, -> (theme_id, image_id) {
    select('id','name','file','ave_value').where(theme_id: theme_id).where('id < ?', image_id).order('id ASC').last
  }

end
