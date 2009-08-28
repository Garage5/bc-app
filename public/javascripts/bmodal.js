
jQuery.fn.center = function(params) {

		var options = {

			vertical: true,
			horizontal: true

		}
		op = jQuery.extend(options, params);

   return this.each(function(){

		//initializing variables
		var $self = jQuery(this);
		//get the dimensions using dimensions plugin
		var width = $self.width();
		var height = $self.height();
		//get the paddings
		var paddingTop = parseInt($self.css("padding-top"));
		var paddingBottom = parseInt($self.css("padding-bottom"));
		//get the borders
		var borderTop = parseInt($self.css("border-top-width"));
		var borderBottom = parseInt($self.css("border-bottom-width"));
		//get the media of padding and borders
		var mediaBorder = (borderTop+borderBottom)/2;
		var mediaPadding = (paddingTop+paddingBottom)/2;
		//get the type of positioning
		var positionType = $self.parent().css("position");
		// get the half minus of width and height
		var halfWidth = (width/2)*(-1);
		var halfHeight = ((height/2)*(-1))-mediaPadding-mediaBorder;
		// initializing the css properties
		var cssProp = {
			position: 'absolute'
		};

		if(op.vertical) {
			cssProp.height = height;
			cssProp.top = '50%';
			cssProp.marginTop = halfHeight;
		}
		if(op.horizontal) {
			cssProp.width = width;
			cssProp.left = '50%';
			cssProp.marginLeft = halfWidth;
		}
		//check the current position
		if(positionType == 'static') {
			$self.parent().css("position","relative");
		}
		//aplying the css
		$self.css(cssProp);


   });

};

jQuery.fn.modal = function(options){
  var defaults = {
    overlayOpacity: 0.9,
    overlayColor: '#000'
  }
  
  var opts = $.extend(defaults, options)
  
  this.click(function(event){
    event.preventDefault();
    var trigger = $(event.target).closest('a')
    wrapper = $('<div class="modal-wrap"></div>').css({
      'width': '100%',
      'height': '100%',
      'position': 'fixed',
      'z-index': 100
    })
        
    overlay = $('<div class="overlay"></div>').css({
      'background-color': opts.overlayColor,
      'width': '100%',
      'height': '100%',
      'position': 'absolute',
      'opacity': opts.overlayOpacity
    })
    
    wrapper.append(overlay)
    
    data = $(trigger).metadata()
    
    overlay.click(function(){
      if ($(trigger).attr('href')[0] == '#'){
        $($(trigger).attr('href')).prependTo('body').hide() }
      
      if (data){
        $('#generic_modal').prependTo('body').hide() }
      
      $(wrapper).remove() 
    })
    
    if(data){
      modal = $("#generic_modal")
      $('#generic_modal_title').html(data.title);
      $('#generic_modal_text').html(data.text);
      $('#generic_modal_method').attr("value", data.method?data.method:'get' );
      $('#generic_modal_form').attr("action", $(trigger).attr("href"));

      wrapper.append(modal.fadeIn())
      $('body').prepend(wrapper.show())
      modal.center()
      
    } else if ($(trigger).attr('href')[0] == '#') {
      modal = $($(trigger).attr('href'))
      
      wrapper.append(modal.fadeIn())
      $('body').prepend(wrapper.show())
      modal.center()
      
    } else {
      indicator = $('<div><img src="/images/ajax-loader.gif" id="ajax-indicator" /></div>').center()
      wrapper.append(indicator)
      console.log($(this).attr('href'))
      $.get($(this).attr('href'), {}, function(html){
        modal = $(html)
        indicator.remove()
        
        wrapper.append(modal)
        $('body').prepend(wrapper.show())
        modal.center()
        modal.fadeIn()
      }) 
    }
    
    $(wrapper).find('.modal_close').click(function(event){
      event.preventDefault()
      overlay.trigger('click')
    })
  }) // end click
}

$(document).ready(function(){
  $('a[rel^="modal"]').modal({overlayOpacity: 0.3})
})
