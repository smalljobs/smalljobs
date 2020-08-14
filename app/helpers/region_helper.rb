module RegionHelper
  def header_image_for_region(region)
    if region.present? and region.header_image.present?
      return "background: linear-gradient(180deg, rgba(6,47,39,0.9) 0%, rgba(6,47,39,0) 50%, rgba(6,47,39,0) 100%),"+
          "url(#{region.header_image.url}) no-repeat top center fixed;"+
          "-webkit-background-size: contain;"+
          "-moz-background-size: contain;"+
          "-o-background-size: contain;"+
          "background-size: contain;"
    end
  end
end
