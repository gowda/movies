# frozen_string_literal: true

[
  {
    name: 'title.basics',
    display_name: 'Titles',
    ordering: 1
  },
  {
    name: 'name.basics',
    display_name: 'Artists',
    ordering: 2
  },
  {
    name: 'title.crew',
    display_name: 'Directors & writers',
    ordering: 3
  },
  {
    name: 'title.principals',
    display_name: 'Principal cast & crew',
    ordering: 4
  },
  {
    name: 'title.episode',
    display_name: 'Episodes',
    ordering: 5
  },
  {
    name: 'title.akas',
    display_name: 'Alternative names',
    ordering: 6
  },
  {
    name: 'title.ratings',
    display_name: 'IMDb Ratings',
    ordering: 7
  }
].each do |attrs|
  Dataset.create!(attrs)
end
