module CurrencyHelper
  def get_currency(country)
    return 'CHF' if country.blank?
    return 'EUR' if country.name.downcase == 'Germany' || country.alpha2.downcase == 'de'

    'CHF'
  end
end