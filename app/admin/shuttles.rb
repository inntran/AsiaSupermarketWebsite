# -*- coding: utf-8 -*-
ActiveAdmin.register Shuttle do
  days = %w(星期二 星期四 星期五 星期六)
  times = %w(9:30AM 10:00AM 11:30AM 2:15PM 3:15PM 5:30PM)
  menu :label => "路线", :parent => "班车"

  filter :name, :label => "路线名"

  index do
    column "路线名", :name
    column "第一班车日期", :first_dayofweek
    column "第一班车时间", :first_timeofday
    column "第一班车人数" do |shuttle|
      shuttle.population(1)
    end
    column "第二班车日期", :second_dayofweek
    column "第二班车时间", :second_timeofday
    column "第二班车人数" do |shuttle|
      shuttle.population(2)
    end
    column "总容量" do |shuttle|
      shuttle.capacity * shuttle.shuttle_count
    end
    column "总人数" do |shuttle|
      shuttle.population
    end
    default_actions
  end

  form do |f|
    f.inputs "基本信息" do
      f.input :name, :label => "路线名称"
      f.input :capacity, :label => "容量"
    end

    f.inputs "车次" do
      f.input :first_dayofweek, :label => "第一班车日期", :as => :select, :collection => days
      f.input :first_timeofday, :label => "第一班车时间", :as => :select, :collection => times
      f.input :second_dayofweek, :label => "第二班车日期", :as => :select, :collection => days
      f.input :second_timeofday, :label => "第二班车时间", :as => :select, :collection => times
    end
    f.actions
  end

end
