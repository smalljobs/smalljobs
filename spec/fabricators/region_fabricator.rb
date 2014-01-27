Fabricator(:region) do
  name             { sequence(:region) { |i| "Region #{ i }" }}
  places(count: 2) { Fabricate(:place) }

  before_create do |r|
    if r.subdomain.blank?
      r.subdomain = I18n.transliterate(r.name).downcase.tr(' ', '-').gsub(/[^0-9a-z-]/i, '')
    end
  end
end

Fabricator(:region_bremgarten, class_name: :region) do
  name 'Bremgarten'
  subdomain 'bremgarten'
  places {
    [
      Fabricate(:place, zip: '5620', name: 'Bremgarten'),
      Fabricate(:place, zip: '5621', name: 'Zufikon'),
      Fabricate(:place, zip: '5610', name: 'Wohlen')
    ]
  }
end
