class Event < ActiveRecord::Base
	
	validates_presence_of :title, :subject
	validate :check_dates
	
	private
	def check_dates
		unless self.start_date.present? 
			self.errors.add(:start_date,'must be provided')
			return
		end

		unless self.end_date.present? 
			self.errors.add(:end_date,'must be provided')
			return
		end

		if self.start_date > self.end_date
			self.errors.add(:start_date, 'needs to be before end date')
		end

		if self.end_date < self.start_date
			self.errors.add(:end_date, 'needs to be after start date')
		end
		
	end
	
end
