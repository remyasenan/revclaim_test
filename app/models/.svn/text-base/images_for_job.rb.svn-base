class ImagesForJob < ActiveRecord::Base
#  has_attached_file :image,
#    :styles => { :content_type => :image,
#    :storage => :file_system ,
#    :resize_to=>'930X1196',
#    :path_prefix => 'public/unzipped_files',
#    :processor=>'Rmagick' },
#    :url => "/unzipped_files/:id_partition/:basename:style.:extension",
#    :path => ":rails_root/public/unzipped_files/:id_partition/:basename:style.:extension"
has_attached_file :image,
    :url => "/unzipped_files/:id_partition/:basename:style.:extension",
    :path => ":rails_root/public/unzipped_files/:id_partition/:basename:style.:extension"
  
  has_many :jobs,:dependent=>:destroy

  #creating alias for the old columns of attachment_fu which are renamed for paperclip....
  alias_attribute :image_file_name,:filename
  alias_attribute :image_content_type,:content_type
  alias_attribute :image_file_size,:size

  def base_path
    return File.join(Rails.root, 'public')
  end

  def public_filename (type=nil)
    self.image.url
  end

end
