module StringHelper
  # Change last \n to br and formated
  #
  # @param [String] text
  # @return [String] formated html
  #
  def simple_format_for_pdf(text)
    simple_format(text.to_s.gsub(/\n$/, "<br>"))
  end
end
