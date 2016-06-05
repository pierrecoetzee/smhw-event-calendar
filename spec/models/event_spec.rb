require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do 

  	let(:event){ build(:event) }

    describe 'dates' do 
      context 'when no start date is set' do 

        before do
          event.update_attributes(start_date: nil)
          event.update_attributes(end_date: Date.today)
        end

        it 'has an error message' do 
          event.save
          expected = ['Start date must be provided']
          expect(event.errors.full_messages_for(:start_date)).to eq(expected)
        end
      end
      
      context 'when no end date is set' do 

        before do
          event.update_attributes(start_date: Date.today)
          event.update_attributes(end_date: nil)
        end

        it 'has an error message' do 
          event.save
          expected = ['End date must be provided']
          expect(event.errors.full_messages_for(:end_date)).to eq(expected)
        end
      end      
    end


  	describe '#start_date and #end_at' do
  		context 'when the start date is after the end date' do 

  			before do
  				event.update_attributes(start_date: Date.today + 7.days)
  				event.update_attributes(end_date: Date.today)
  			end

  			it 'should not be valid' do 
  				event.save
  				expect(event.valid?).to be(false)
  			end

  			it 'should contain the error messages for both dates' do 
  				event.save
  				expected = {:start_date =>["needs to be before end date"], 
                      :end_date=>["needs to be after start date"]}.freeze
     
					expect(event.errors.messages).to eq(expected)
  			end
  		end

      context 'when the end date is before the start date' do 

        before do
          event.update_attributes(start_date: Date.today)
          event.update_attributes(end_date: Date.today - 7.days)
        end

        it 'should not be valid' do 
          event.save
          expect(event.valid?).to be(false)
        end

        it 'should contain the error messages for both dates' do 
          event.save
          expected = {:start_date=>["needs to be before end date"], 
                      :end_date=>["needs to be after start date"]}.freeze
     
          expect(event.errors.messages).to eq(expected)
        end
      end      
  	end
  end
end

