module EventsHelper
  def error_for?(field)
  	@event.errors.full_messages_for(field).any?
  end
end
