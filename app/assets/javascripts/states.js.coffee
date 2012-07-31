# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
// Append the function to the "document ready" chain
jQuery(function($) {
  // when the #search field changes
  $("#state_id").change(function() {
    console.log("ok");
    /*$.post(<%= live_search_path %>, function(data) {
      $("#results").html(data);
    });*/
  });
})