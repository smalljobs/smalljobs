Fabricator(:review) do
  seeker
  job
  rating { rand(5) }

  after_build do |r|
    if r.provider
      r.seeker = nil
    end
  end
end
