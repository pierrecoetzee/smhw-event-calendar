
describe('$.fn.clear_events()', function() {

	beforeEach(function() {
		loadFixtures('clear_events.html');
	});

  it("it clears the events currently on the calendar", function() {
  	$.fn.clear_events()
    expect($('.event').length).toEqual(0)

  });
});


describe('$.fn.check_for_events',function(){
  beforeEach(function(){
  	jasmine.Ajax.install();
  })

  afterEach(function() {
      jasmine.Ajax.uninstall();
  });

  it('gets the weekly calendar from the server', function(){
		var doneFn = jasmine.createSpy("success");
		var xhr = new XMLHttpRequest();
    
    xhr.onreadystatechange = function(args) {
      if (this.readyState == this.DONE) {
        doneFn(this.responseText);
      }
    };

    xhr.open("GET", "/weekly_events");
    xhr.send();

    expect(jasmine.Ajax.requests.mostRecent().url).toBe('/weekly_events');
    expect(doneFn).not.toHaveBeenCalled();
  })
})


describe('set_calendar_events',function(){
	var result = [{"start_date":"2016-05-31","end_date":"2016-06-09","description":"test description 1","title":"Mr Math","subject":"Math"},
								{"start_date":"2016-06-01","end_date":"2016-06-03","description":"test description 2","title":"Mr Geography","subject":"Geography"}]
	
	beforeEach(function() {
		loadFixtures('clear_events.html');
		$.fn.clear_events()
		set_calendar_events(result)
	});

	it('sets two events on the calendar', function(){
		expect($('.event').length).toEqual(2)
	})

	it('sets the title for each event', function(){
		$.each(result,function(i,e){
			expect($("[day-month='"+ e.start_date +"']").find('div div:eq(0)').text()).toEqual( e.title )
		})
	})
	
	it('sets the subject for each event', function(){
		$.each(result,function(i,e){
			expect($("[day-month='"+ e.start_date +"']").find('div div:eq(1)').text()).toEqual( e.subject )
		})
	})	
})

describe('normalizeDate', function(){
	
	it('returns a hyphenated date string',function(){
		 var test_date = new Date("05/01/2016")
		 expect(normalizeDate(test_date)).toEqual('2016-05-01')
	})
})
