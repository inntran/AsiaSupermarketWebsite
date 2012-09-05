# -*- coding: utf-8 -*-
ActiveAdmin.register Stop do
  menu :label => "车站", :parent => "班车"

  filter :shuttle, :label => "班车路线"
  filter :name, :label => "车站名"
end
