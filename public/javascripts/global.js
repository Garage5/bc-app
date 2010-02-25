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

var Modal = new Class({
  initialize: function(html){
    this.build(html)
    this.element.getElements('[data-close-modal="true"]').addEvent('click', function(event){
      event.stop()
      document.getElements('.spinner').dispose()
      this.element.dispose()
    }.bind(this));
  },
  
  build: function(html){
    this.element = new Element('div', {
      'class': 'modal',
      'html': '<div class="modal-inner">' + html + '</div>'
    }) 
  },
  
  show: function(){
    this.element.inject(document.body, 'top')
    
    this.element.position({
      position: {x: 'center', y: 'center'}
    })
    
    var spinner = document.getElement('.spinner-content')
    spinner.hide()
    
    var coords = this.element.getCoordinates()
    this.element.set('morph', {duration: 'normal', transition: Fx.Transitions.Cubic.easeOut})
    this.element.morph({
      opacity: [0, 1],
      top: [this.element.getTop() - 100, this.element.getTop()]
    })
  },
  
  destroyAll: function(){
    if(spinner = document.body.get('spinner')){
      spinner.destroy()
    }
  } 
})

function show_modal(modal) {
  modal.show()
  modal.element.getElements('form[data-remote="true"]').addEvent('submit', rails.handleRemote);
  modal.element.getElements('a[data-remote="true"], input[data-remote="true"]').addEvent('click', rails.handleRemote);
  $$('a[data-method][data-remote!=true]').addEvent('click', function(e) {
    e.preventDefault();

    var form = new Element('form', {
      method: 'post',
      action: this.get('href'),
      styles: { display: 'none' }
    }).inject(this, 'after');

    var methodInput = new Element('input', {
      type: 'hidden',
      name: '_method',
      value: this.get('data-method')
    });

    var csrfInput = new Element('input', {
      type: 'hidden',
      name: rails.csrf.param,
      value: rails.csrf.token
    });

    form.adopt(methodInput, csrfInput).submit();
  });
}

window.addEvent('domready', function(){
  document.getElements('a[data-modal="true"]').addEvents({
    'ajax:before': function(xhr){
      this.mask = new Spinner(document.body, {hideOnClick: true, destroyOnHide: true})
      this.mask.addEvent('destroy', function(){
        document.getElements('.modal').dispose()
      });
      this.mask.show(true)
    },
    'ajax:complete': function(xhr) { 
      modal = new Modal(xhr.responseText)
      show_modal(modal)
    }
  })
});
