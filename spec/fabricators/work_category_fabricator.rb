Fabricator(:work_category) do
  name { sequence(:category) { |i| "category #{ i }" }}
end
