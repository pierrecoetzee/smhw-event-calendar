let data_store = null;

$(window).on('resize',function(e){
  if (data_store){
  	$.fn.clear_events()
  	set_calendar_events(data_store)
  }
})

$.fn.clear_events = function(){
  $('.event').remove()
}

$.fn.check_for_events = function getEvents(){
	$.ajax({type: 'GET', url: 'weekly_events', dataType: 'json'})
	.success(function(data){
		data_store = data
    $.fn.clear_events()
		set_calendar_events(data)
	})
	.fail(function(error_data){

	});
}

function set_calendar_events(events){

	$.each(events,function(i, e){

		let start_date = new Date(e.start_date);
		let end_date = new Date(e.end_date);
    let title = e.title
    let subject = e.subject

    let days_between = (end_date.getUTCDate() - start_date.getUTCDate())
		
		add_event_to_calendar(days_between,start_date, end_date, title, subject)
	})
}

function normalizeDate(date){
	return date.toLocaleDateString('en-GB', 
														{year: 'numeric' , month: 'numeric', day: 'numeric'})
														.split('/').reverse().join('-')
}

function get_id(){
  return Math.random().toString().substr(2)
}

function add_event_to_calendar(days_between,start_date, end_date, title, subject){

	let cell_width = parseInt($('td.content:first').css('width')); 
	let start_cell = $("td.content[day-month='" + normalizeDate(start_date) + "']")
	
  div_id = get_id()

	let event_area = "<div id='"+ div_id +"' class='event'>"+
												"<div>"+ title +"</div>"+
                        "<div>"+ subject +"</div>"+    
										"</div>";

	start_cell.append(event_area)
  end_cell = new Date(end_date.setDate(end_date.getDate() + 1 ))
  cells = start_cell.nextUntil("[day-month='"+ normalizeDate(end_cell) +"']")
  width = start_cell.width();

  $.each(cells,function(i, obj){
    width += $(obj).width() + 2
  })

  $('#'+ div_id).css('width', width)
}

$.fn.check_for_events();
