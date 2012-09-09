# -*- coding: utf-8 -*-
ActiveAdmin.register Article do
  menu :label => "文章"

  index do
    selectable_column
    column "标题" do |article|
      link_to article.title, admin_article_path(article)
    end
    column "摘要" do |article|
      simple_format article.content.truncate(90)
    end
    column "创建日期", :created_at
    column "修改日期", :updated_at
    default_actions
  end
    
  show do
    attributes_table do
      row :title
      row :content do |article|
        raw article.content
      end
    end
  end
  
  form do |f|
    f.inputs do
      f.input :category
      f.input :title
      f.input :content, :as => :html_editor
    end
    f.actions
  end
end
