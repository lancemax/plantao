# -*- coding: utf-8 -*-


SimpleNavigation::Configuration.run do |navigation|

  navigation.items do |primary|
    
    primary.dom_class = 'breadcrumbs'
    primary.item :admin_home, 'Admin', admin_root_path do |admin|
      
      admin.item :admin_packages, 'Pacotes', admin_packages_path do |package|
        package.item :new_admin_package, 'Novo', new_admin_package_path
        package.item :edit_admin_package, "Editar #{@package.try(:name)}",  edit_admin_package_path( @package.blank? ? 0 : (@package.id || 0) ), :if => Proc.new { !@package.blank? and !@package.new_record? }
        package.item :admin_package, "Destalhes de #{@package.try(:name)}",  admin_package_path( @package.blank? ? 0 : (@package.id || 0) )
      end


    end
      
  end
  
end
