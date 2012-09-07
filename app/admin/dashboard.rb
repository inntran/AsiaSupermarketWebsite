# -*- coding: utf-8 -*-
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
        panel "最近订车", :priority => 1 do
          table_for Booking.order("created_at desc").limit(10) do |b|
            column("姓名") {|b| b.customer }
            column("电话") {|b| b.phone_number }
            column("路线") {|b| b.shuttle.name }
            column("车次") {|b| b.shuttle_sequence }
            column("车站") {|b| b.stop.name}
          end
        end
      end
      
      column do
        panel "班车线路", :priority => 2 do
          table_for Shuttle.limit(10) do |s|
            column("线路名") {|s| s.name}
            column("发车次数") {|s| s.shuttle_count}
              column("人数") {|s| s.population}
          end
        end
      end
    end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
