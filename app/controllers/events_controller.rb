class EventsController < ApplicationController

	def index
		@this_weeks_calendar = this_weeks_calendar
		render :index, locals:{this_weeks_calendar: @this_weeks_calendar}
	end

	def new
		@event = Event.new

		respond_to do |format|
			format.js{render action: :new}
		end
	end

	def create
		
		@event = Event.create(allowed_paramameters)
		@events = current_events.to_json

		respond_to do |format|
			format.js{ render :new } 
		end
	end

	def weekly_events

		@events = current_events

		respond_to do |format|
			format.json{render json: @events }
		end
	end

	private 

	def current_events
		Event.all.to_json(only: [:title,:subject,:start_date,:end_date, :description])
	end

	def this_weeks_calendar
    
    start_date = DateTime.now.beginning_of_week
    end_date = start_date + 6.days

    (start_date..end_date).inject({}) do |result, date|
    	
    	description = {details: "#{date.day.ordinalize} #{date.strftime('%b')}" }
    	date_details = {date: date.strftime('%Y-%m-%d') }

      result["#{date.strftime("%A")}"] = date_details.merge(description)
      result
    end
  end

	def allowed_paramameters
		params.required(:event).permit(:title,:subject,:start_date, :end_date, :description)
	end
end
