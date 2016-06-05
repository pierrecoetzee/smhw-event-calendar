require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  
  let(:test_date){Date.parse('2 June 2016')}

  before do
    allow(DateTime).to receive(:now).and_return(test_date)
  end
      
  describe '#index' do 
    it 'has a response code of 200' do
      get :index
      expect(response.status).to eq(200)
    end
    
    it 'renders the index view' do
      get :index
      expect(response).to render_template('events/index')
    end

    describe '#this_weeks_calendar' do

      let(:expected_week) do
        {'Monday'=>{:date=>'2016-05-30', :details=>'30th May'}, 
        'Tuesday'=>{:date=>'2016-05-31', :details=>'31st May'}, 
        'Wednesday'=>{:date=>'2016-06-01', :details=>'1st Jun'}, 
        'Thursday'=>{:date=>'2016-06-02', :details=>'2nd Jun'}, 
        'Friday'=>{:date=>'2016-06-03', :details=>'3rd Jun'}, 
        'Saturday'=>{:date=>'2016-06-04', :details=>'4th Jun'}, 
        'Sunday'=>{:date=>'2016-06-05', :details=>'5th Jun'}}.freeze
      end

      it 'returns a hash with the weeks days' do
        get :index
        expect(assigns(:this_weeks_calendar)).to eq expected_week
      end
    end 
  end

  describe '#new' do 
    it 'has a response code of 200' do
      xhr :get, :new
      expect(response.status).to eq(200)
    end
    
    it 'renders the new view' do
      xhr :get, :new
      expect(assigns(:event)).to be_instance_of(Event)
      expect(response).to render_template('events/new')
    end
  end

  describe '#create' do 

    let(:event){ {event: {start_date: DateTime.now, 
                          end_date: DateTime.now + 2.days, 
                          subject: 'test subject',
                          title: 'Mr Mathematics'}}}

    it 'has a response code of 200' do
      xhr :post, :create, event.merge({invalid_param: 'hello'})
      expect(response.status).to eq(200)
    end
    
    context 'when an valid event is posted' do 
      it 'creates a valid event' do 
        expect{
          xhr :post, :create, event
        }.to change{Event.count}.from(0).to(1)
      end

      it 'renders the new view' do 
        xhr :post, :create, event
        expect(response).to render_template('new')
      end
    end

    context 'when an invalid event is posted' do 
      it 'does not create an event' do
        event[:event][:start_date] = nil

        expect{
          xhr :post, :create, event
        }.to_not change{Event.count}
      end
    end
  end

  describe '#weekly_events' do 

    let(:json_events) do 
        [build(:event).to_json(only: [:title,:subject,:start_date,:end_date]) * 3]
    end

    let(:expected_result) do 
        {events: json_events }.to_json
    end

    before do 
      allow(subject).to receive(:current_events){expected_result}
      xhr :get, :weekly_events
    end

    it 'returns an array of events as json' do 
      expect(JSON.parse(response.body)).to eq( JSON.parse(expected_result) )
    end

    it 'returns a successful response' do 
      expect(response.status).to eq(200)
    end
  end
end
