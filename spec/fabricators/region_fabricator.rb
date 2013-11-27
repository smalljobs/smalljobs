Fabricator(:region) do
  name             { Forgery(:address).province }
  places(count: 2) { Fabricate(:place) }
end
