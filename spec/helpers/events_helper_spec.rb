require 'rails_helper'

describe EventsHelper do
  describe '#error_for?' do 
    context 'when the the event is invalid' do 
      it 'returns true' do 
        @event = build(:event, :invalid)
        @event.save
        expect(helper.error_for?(:start_date)).to be
      end
    end

    context 'when the the event is valid' do 
      it 'returns false' do 
        
        @event = create(:event)
        
        expect(helper.error_for?(:start_date)).to be(false)
      end
    end
  end
end
