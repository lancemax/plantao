
jQuery(document).ready(function(){
   $("input[name*='price']").maskMoney({symbol:'R$ ', showSymbol:true, thousands:'.', decimal:',', symbolStay: true});
   $('.date').datepicker({"format": "dd/mm/yyyy", "weekStart": 1, "autoclose": true, "language": "br"})
 });