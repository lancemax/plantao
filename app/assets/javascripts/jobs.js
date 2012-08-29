
jQuery(document).ready(function(){
   $("input[name*='price']").maskMoney({symbol:'R$ ', showSymbol:true, thousands:'.', decimal:',', symbolStay: true});
 });