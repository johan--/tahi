FactoryGirl.define do
  factory :phase do
    sequence(:name) { |n| "Phase #{n}" }
    paper
  end
end
