# frozen_string_literal: true

[
  {
    name: 'title.basics',
    display_name: 'Titles'
  },
  {
    name: 'name.basics',
    display_name: 'Artists'
  },
  {
    name: 'title.akas',
    display_name: 'Alternative names'
  },
  {
    name: 'title.crew',
    display_name: 'Directors & writers'
  },
  {
    name: 'title.episode',
    display_name: 'Episodes'
  },
  {
    name: 'title.principals',
    display_name: 'Principal cast & crew'
  },
  {
    name: 'title.ratings',
    display_name: 'IMDb Ratings'
  }
].each do |attrs|
  Dataset.create!(attrs)
end
