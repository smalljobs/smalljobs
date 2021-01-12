module RegionHelper
  def header_image_for_region(region)
    if region.present? and region.header_image.present?
      return "background: linear-gradient(180deg, rgba(6,47,39,0.9) 0%, rgba(6,47,39,0) 50%, rgba(6,47,39,0) 100%),"+
          "url(#{region.header_image.url}) no-repeat top center fixed;"+
          "-webkit-background-size: cover;"+
          "-moz-background-size: cover;"+
          "-o-background-size: cover;"+
          "background-size: cover;"
    end
  end
end
