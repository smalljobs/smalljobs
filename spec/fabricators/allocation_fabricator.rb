Fabricator(:allocation) do
  seeker
  job
  provider
  state { 0 }
  contract_returned { false }
end
