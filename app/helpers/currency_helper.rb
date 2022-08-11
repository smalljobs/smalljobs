module CurrencyHelper
  def get_currency(obj)
    country = nil
    begin
      country = case obj.class
                when Place then obj.place.region.country
                when Job then obj.region.country
                end
    rescue StandardError => e
      Raven.extra_context({ "#{obj.class.name.downcase}_id" => obj.id }) do
        Raven.capture_exception(e)
      end
    end

    return 'CHF' if country.blank?
    return 'EUR' if country.name.downcase == 'Germany' || country.alpha2.downcase == 'de'

    'CHF'
  end
end