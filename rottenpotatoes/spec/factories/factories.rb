FactoryGirl.define do
  factory :movie do
    title 'a title'
    director 'a director'
    rating 'a rating'
    release_date '1992-11-25 00:00:00'
  end
end

FactoryGirl.define do
  factory :no_dir_movie, class:Movie do
    title 'a title'
    rating 'a rating'
    release_date '1992-11-25 00:00:00'
  end
end

FactoryGirl.define do
  factory :diff_dir_movie, class:Movie do
    title 'a title'
    rating 'a rating'
    director 'I am different'
    release_date '1992-11-25 00:00:00'
  end
end
