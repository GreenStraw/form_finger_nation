class ImageSerializer < BaseSerializer
  attributes :image_url

  private

  def image_url
    if object.image_url.present?
      object.image_url_url
    else
      ENV["PLACEHOLDER_IMAGE_URL"]
    end
  end
end
