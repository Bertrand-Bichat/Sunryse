module CloudinaryHelper
  def mp4_content_type
    'video/mp4'
  end

  def jpg_content_type
    'image/jpg'
  end

  def jpeg_content_type
    'image/jpeg'
  end

  def png_content_type
    'image/png'
  end

  def img_choice
    [jpg_content_type, jpeg_content_type, png_content_type]
  end

  def video_img_choice
    img_choice << mp4_content_type
  end

  # favicon.ico format
  def ico_content_type
    'image/vnd.microsoft.icon'
  end
end
