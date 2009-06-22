// Dark Background Overlay
Overlay = $.klass({
  initialize: function(options){},
  onclick: function(){
    $(this.element).remove()
    $($modalId).hide()
  }
})

Modal = $.klass({
  initialize: function(options){
    // set a global variable for the #id of the modal to trigger
    $modalId = options.modalId
  },
  onclick: function(event){    
    event.preventDefault()
    modal = $($modalId)
    $($modalId)
      .css({
        marginTop: modal.height()/2 - modal.height()/2 * 2,
        marginLeft: modal.width()/2 - modal.width()/2 * 2,
      })
      .show()
      .after('<div class="overlay"></div>')
    $('div.overlay').attach(Overlay)
  }
})

$(document).ready(function(){
  // to add a modal trigger to a link:
  // $(link_selector).attach(Modal, {modalId: ID tag of modal element to trigger})
  $("a[href='/account']").attach(Modal, {modalId: "#some_modal"})
})