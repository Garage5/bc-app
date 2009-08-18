$(document).ready(function(){
  // hide .note elements when closed
  $(".note-close").click(function(e){
    e.preventDefault()
    $(this).closest('.note').fadeOut(300)
  })
  
  // convert dates to relative
  $(".date").timeago()
  
  // 'examplify' form fields
  $('input[title], textarea[title]').example(function() {
    return $(this).attr('title');
  });
})

$.metadata.setType('attr', 'rel');

