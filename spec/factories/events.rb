FactoryGirl.define do

  factory :event do |f|
		start_date "2016-06-01"
		end_date "2016-06-05"
		title 'some title'
		subject 'GCSE Math'   

		trait :invalid do 
			after(:build) do |event|
				event.start_date = nil
			end
		end
  end
end
