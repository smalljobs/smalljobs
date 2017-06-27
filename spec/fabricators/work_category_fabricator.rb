Fabricator(:work_category) do
  name { sequence(:category) { |i| "Category #{ i }" }}
end
