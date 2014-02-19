Fabricator(:review) do
  seeker
  job
  rating { rand(5) }
end
