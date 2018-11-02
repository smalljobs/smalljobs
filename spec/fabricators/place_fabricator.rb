Fabricator(:place) do
  zip       { Random.rand(9999).to_s.rjust(4, '0') }
  name      { sequence(:place) { |i| "Place #{ i }" }}
  longitude { rand(-180.000000000...180.000000000) }
  latitude  { rand(-90.000000000...90.000000000) }
end
