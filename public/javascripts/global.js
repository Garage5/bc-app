$(document).ready(function(){
  // hide .note elements when closed
  $(".note-close").click(function(e){
    e.preventDefault()
    $(this).closest('.global_note').fadeOut(300)
  })
  
  $("#system_msg_close").click(function(e){
    e.preventDefault()
    $(this).closest('#system_msg').fadeOut(300)
  })
  
  // convert dates to relative
  $(".date").timeago()
  
  // 'examplify' form fields
  $('input[title], textarea[title]').example(function() {
    return $(this).attr('title');
  });
  
  // auto focus next field for dates
  $('.date input.date_month').each(function() { $(this).autotab({target: $(this).next('input'), format: 'numeric'}) } );
  $('.date input.date_day').each(function() { $(this).autotab({previous: $(this).prev('input'), target: $(this).next('input'), format: 'numeric'}) } );
  $('.date input.date_year').each(function() { $(this).autotab({previous: $(this).prev('input'), format: 'numeric'}) } );

  $('.time input.date_month').each(function() { $(this).autotab({target: $(this).next('input'), format: 'numeric'}) } );
  $('.time input.date_day').each(function() { $(this).autotab({previous: $(this).prev('input'), target: $(this).next('input'), format: 'numeric'}) } );
  $('.time input.date_year').each(function() { $(this).autotab({previous: $(this).prev('input'), target: $(this).next('input'), format: 'numeric'}) } );
  $('.time input.date_hour').each(function() { $(this).autotab({previous: $(this).prev('input'), target: $(this).next('input'), format: 'numeric'}) } );
  $('.time input.date_minutes').each(function() { $(this).autotab({previous: $(this).prev('input'), format: 'numeric'}) } );
})

$.metadata.setType('attr', 'rel');

