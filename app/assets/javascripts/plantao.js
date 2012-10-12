  jQuery(document).ready(function(){
   
   $("input[type=submit]").click(function(){
   	$("#new_hospital").submit();

   });

  	$('a[href="#submitform"]').click(function(e) {
    e.preventDefault();
    //do other stuff when a click happens
	});
   /* jobs */

   // guardar dados do form
   $("form").sisyphus({timeout: 0,
    onSave: function() { console.log("salvo"); },
    onBeforeRestore: function() {console.log("vai restaurar"); },
    onRestore: function() {console.log("reustaurado"); },
    autoRelease:false,
  });
   

   $("input[name*='price']").maskMoney({symbol:'R$ ', showSymbol:true, thousands:'.', decimal:',', symbolStay: true});
   $('.date').datepicker({"format": "dd/mm/yyyy", "weekStart": 1, "autoclose": true, "language": "br"});

   verificaBotoes();

   $(".clicavel").click(function(){
   		
   		var dia=$(this).attr("id");

		if ( getCookie(dia) == "true" ){
			setCookie(dia,"false",1);

			$(this).removeClass("btn-"+dia);
			$(this).addClass("btn-kilo");
		}
			
		else {

			$(this).addClass("btn-"+dia);
			$(this).removeClass("btn-kilo");
			setCookie(dia,"true",1);
		}
			//location.reload();
    });

   	$(".exibir").click(function(){
   		
   		var exibe=$(this).attr("id");

   		if ( getCookie(exibe) != "true" ){
   			if (exibe =='todos' ){
   				$('#todos').addClass("btn-terca");
   				$('#todos').removeClass("btn-kilo");
   				setCookie('todos',"true",1);

   				$('#meus').addClass("btn-kilo");
   				$('#meus').removeClass("btn-terca");
   				setCookie('meus',"false",1);

   				$('#pleiteados').addClass("btn-kilo");
   				$('#pleiteados').removeClass("btn-terca");
   				setCookie('pleiteados',"false",1);
   			}else if (exibe =='meus'){
   				$('#meus').addClass("btn-terca");
   				$('#meus').removeClass("btn-kilo");
   				setCookie('meus',"true",1);

   				$('#todos').addClass("btn-kilo");
   				$('#todos').removeClass("btn-terca");
   				setCookie('todos',"false",1);

   				$('#pleiteados').addClass("btn-kilo");
   				$('#pleiteados').removeClass("btn-terca");
   				setCookie('pleiteados',"false",1);

   			}else if (exibe =='pleiteados'){
   				$('#pleiteados').addClass("btn-terca");
   				$('#pleiteados').removeClass("btn-kilo");
   				setCookie('pleiteados',"true",1);

   				$('#todos').addClass("btn-kilo");
   				$('#todos').removeClass("btn-terca");
   				setCookie('todos',"false",1);

   				$('#meus').addClass("btn-kilo");
   				$('#meus').removeClass("btn-terca");
   				setCookie('meus',"false",1);

   			}
   			location.reload();
		}
			
    });

   /* states */
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

  	// hospitals
   $("#hospital_zip_code").mask("99999-999");  


   $('#myCarousel').carousel({
      interval: 20000
    });

   // meus dados
   $("#user_phone").mask("(99)9999-9999?9");  
   $("#user_cellphone").mask("(99)9999-9999?9");  


 });







function verificaBotoes(){

	dias = ["domingo","segunda","terca","quarta", "quinta", "sexta", "sabado"];
	exibe = ["todos","meus","pleiteados"];
	for (x in dias)
	  {
	  	//console.log(dias[x]);
	  	//console.log(getCookie(dias[x]));

  		if ( getCookie(dias[x]) == null )
  			setCookie(dias[x],"true",1);

	  if ( getCookie(dias[x]) == "false" ){
		
			$("#"+dias[x]).removeClass("btn-"+dias[x]);
			$("#"+dias[x]).addClass("btn-kilo");
		}
			
		else{

			$("#"+dias[x]).addClass("btn-"+dias[x]);
			$("#"+dias[x]).removeClass("btn-kilo");
			
		}
	  }

	for (y in exibe){
		if ( getCookie(exibe[y]) == null ){
			setCookie("todos","true",1);
  			setCookie("meus","false",1);
  			setCookie("pleiteados","false",1);
		}
  		
  		if ( getCookie(exibe[y]) == "false" ){
  			$("#"+exibe[y]).removeClass("btn-terca");
			$("#"+exibe[y]).addClass("btn-kilo");
  		}else{
  			$("#"+exibe[y]).addClass("btn-terca");
			$("#"+exibe[y]).removeClass("btn-kilo");
  		}
	}


}

function getCookie(c_name)
{
var i,x,y,ARRcookies=document.cookie.split(";");
for (i=0;i<ARRcookies.length;i++)
 {
 x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
 y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
 x=x.replace(/^\s+|\s+$/g,"");
 if (x==c_name)
   {
   return unescape(y);
   }
 }
}

function setCookie(c_name,value,exdays)
{
var exdate=new Date();
exdate.setDate(exdate.getDate() + exdays);
var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
document.cookie=c_name + "=" + c_value +";path=/";
}
