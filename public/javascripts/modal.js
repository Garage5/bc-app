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
    modal = $($(e.target).attr('href'))
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
	$("a[rel='modal']").attach(Modal)
})