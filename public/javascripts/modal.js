// Dark Background Overlay
Overlay = $.klass({
  initialize: function(options){},
  onclick: function(){
    $(this.element).remove()
    $($modalId).hide()
  }
})

Modal = $.klass({
  onclick: function(e){    
    e.preventDefault()
    data = $(e.target).metadata()
    if (data) {
      modal = "#generic_modal"
      $('#generic_modal_title').html(data.title);
      $('#generic_modal_text').html(data.text);
      $('#generic_modal_method').attr("value", data.method?data.method:'get' );
      $('#generic_modal_form').attr("action", $(e.target).attr("href"));
    } else {
      modal = $(e.target).attr('href')
    }
    modal = $(modal)
    $(modal)
      .css({
        marginTop: modal.height()/2 - modal.height()/2 * 2,
        marginLeft: modal.width()/2 - modal.width()/2 * 2,
      })
      .show()
      .after('<div class="overlay"></div>')
    $('div.overlay').click(function(){
      $(this).remove()
      $(modal).hide()
    })
  }
})

$(document).ready(function(){
	$("a[rel^='modal']").attach(Modal)
	$("a[rel^='modal'] span").click(function(){
		$(this).parent('a[rel^="modal"]').click()
	})
})

function closeModal() {
  $('div.overlay').remove()
  $('#generic_modal').hide()
  return false
}
