Fabricator(:region) do
  name             { sequence(:region) { |i| "Region #{ i }" }}
  places(count: 2) { Fabricate(:place) }

  before_create do |r|
    if r.subdomain.blank?
      r.subdomain = I18n.transliterate(r.name).downcase.tr(' ', '-').gsub(/[^0-9a-z-]/i, '')
    end
  end
end
