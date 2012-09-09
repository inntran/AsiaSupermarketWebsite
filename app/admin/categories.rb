# -*- coding: utf-8 -*-
ActiveAdmin.register Category do
  menu :label => "分类"

  index do
    selectable_column
    column "名称" do |category|
      link_to category.name, admin_category_path(category)
    end
    column "创建日期", :created_at
    column "修改日期", :updated_at
    default_actions
  end
    
  show do
    attributes_table do
      row :name
      row :description do |category|
        raw category.description
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description, :as => :html_editor
    end
    f.actions
  end
end
