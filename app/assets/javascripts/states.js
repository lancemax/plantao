

jQuery(document).ready(function(){

  // when the #search field changes
  $("#hospital_state_id").change(function() {
  	
   
     estado=$(this).val();
    if(estado=="")
      $("#hospital_city_id").html("<option>Escolha uma cidade</option>");	
  	else
  	{	
	   	$.post("/cities/load_cities/"+estado, function(data) {
	      //console.log(data);
	      $("#hospital_city_id").html(data);
	   	});
   }

  });
});

  
