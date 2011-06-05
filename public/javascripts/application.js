// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(function(){

  $.fn.countable = function(){
    var elem = $(this);
    var identifier = $(this).attr('id');
    if(!identifier) var identifier = $(this).attr('name');
    $('<span id="'+identifier+'_counter"></span>').insertAfter($(this)).css({display:'block',fontWeight:'bold'});
    recount = function(){
      $('#'+identifier+'_counter').text($(elem).val().length);
    }
    $(this).bind('keyup',recount);
    recount();
  }
  $('.countable').countable();
});
