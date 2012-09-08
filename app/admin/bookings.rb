# -*- coding: utf-8 -*-
ActiveAdmin.register Booking do
  menu :priority => 2, :label => "订车情况"
  config.sort_order = "created_at_desc"

  filter :shuttle, :label => "班车路线"
  filter :stop, :label => "车站"
  filter :shuttle_sequence, :label => "车次", :as => :check_boxes, :collection => {"第一班" => 1, "第二班" => 2}
  filter :customer, :label => "客户姓名"
  filter :phone_number, :label => "电话"
  filter :email, :label => "E-mail"
  filter :created_at, :label => "订车时间", :as => :date_range

  index do
    selectable_column
    column "序号", :id
    column "客户姓名", :customer
    column  "电话", :phone_number
    column "E-mail", :email, :label
    column "班车路线", :shuttle
    column "车站", :stop
    column "车次" do |booking|
      if booking.shuttle_sequence == 1
        "第一班"
      elsif booking.shuttle_sequence == 2
        "第二班"
      end
    end

    column "订车时间" do |booking|
      I18n.l booking.created_at.in_time_zone
    end
  end

  form do |f|
    f.inputs "班车" do
      f.input :shuttle, :label => "路线"
      f.input :stop, :label => "车站"
    end
    
    f.inputs "个人信息" do
      f.input :customer, :label => "姓名"
      f.input :phone_number, :label => "电话号码"
      f.input :email, :labe => "E-Mail"
    end

    f.actions
  end

end
