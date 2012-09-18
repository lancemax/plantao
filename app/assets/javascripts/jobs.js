
jQuery(document).ready(function(){
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
 });


function verificaBotoes(){

	dias = ["domingo","segunda","terca","quarta", "quinta", "sexta", "sabado"];

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



