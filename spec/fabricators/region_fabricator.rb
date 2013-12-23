Fabricator(:region) do
  name             { sequence(:region) { |i| "Region #{ i }" }}
  places(count: 2) { Fabricate(:place) }
end
