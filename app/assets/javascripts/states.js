

jQuery(document).ready(function(){

  // when the #search field changes
  $("#hospital_state_id").change(function() {
  	
   
     estado=$(this).val();
    if(estado=="")
      $("#result").html("<option>Escolha uma cidade</option>");	
  	else
  	{	
	   	$.post("/cities/load_cities/"+estado, function(data) {
	      console.log(data);
	      $("#result").html(data);
	   	});
   }

  });
});

  
