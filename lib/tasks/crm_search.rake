desc "Seach crm"
task :crm_search => :environment do
  require 'nokogiri'
  require 'open-uri'
  
    url = "http://portal.cfm.org.br/index.php?medicosNome=&medicosCRM=13704&medicosUF=CE&medicosSituacao=&medicosTipoInscricao=&medicosEspecialidade=&buscaEfetuada=true&option=com_medicos#buscaMedicos"
    doc = Nokogiri::HTML(open(url))
    puts doc.css(".row0 span").text
	doc.css(".row0 span").each do |span|
	  p span
	end
end
