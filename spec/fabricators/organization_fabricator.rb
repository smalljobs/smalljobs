Fabricator(:organization) do
  name { sequence(:name) { |n| Forgery(:name).company_name + ' 1' } }
  website { "http://#{ Forgery(:internet).domain_name }" }
  street { "#{ Forgery(:address).street_name } #{ Forgery(:address).street_number }" }
  place
  email  { Forgery(:internet).email_address }
  phone  { '044 444 44 44' }
end

Fabricator(:org_bremgarten, from: :organization) do
  name 'Jugendarbeit Bremgarten'
  after_create do |o|
    Fabricate(:employment,
              organization: o,
              region: Fabricate(:region_bremgarten),
              broker: Fabricate(:broker))
  end
end

Fabricator(:org_lenzburg, from: :organization) do
  name 'Jugendarbeit Lenzburg'
  description 'regionale Jugendarbeit Lotten'
  place { Fabricate(:place, zip: '5600', name: 'Lenzburg')}
  email 'info@jugendarbeit-lotten.ch '
  phone '062 508 13 14'
  website 'http://www.jugendarbeit-lotten.ch'
  street 'c/o JA Lenzburg, Soziale Dienste'
  after_create do |o|
    Fabricate(:employment,
              organization: o,
              region: Fabricate(:region_lenzburg),
              broker: Fabricate(:broker,
                                firstname: 'Mich',
                                lastname: 'Wyser',
                                phone: '062 897 01 21'))
  end
end
