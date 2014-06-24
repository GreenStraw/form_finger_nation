Fabricator(:endorsement_request) do
  user { Fabricate(:user) }
  team { Fabricate(:team) }
end
