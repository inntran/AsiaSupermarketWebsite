# -*- coding: utf-8 -*-
ActiveAdmin.register ImageAsset do
  menu label: '图片'
  index :as => :grid, :download_links => false do |image_asset|
    div do
      link_to(image_tag(image_asset.storage.thirtysix), admin_image_asset_path(image_asset))
    end
    resource_selection_cell(image_asset)
  end

  form do |f|
    f.inputs do
      f.input :storage
    end

    f.buttons
  end

  show do
    attributes_table do
      row('Dimensions') do
        "#{image_asset.dimensions[:width]}px x #{image_asset.dimensions[:height]}px"
      end
      row('Thumbnail') do
        image_tag(image_asset.storage.thumb)
      end
      row('36%') do
        image_tag(image_asset.storage.thirtysix)
      end
      row('61.8%') do
        image_tag(image_asset.storage.golden)
      end
      row('Full Image') do
        image_tag(image_asset.storage)
      end
    end
  end

  controller do

    def create
      if params['qqfile']
        @image_asset = ImageAsset.new
        io = request.env['rack.input']

        def io.original_filename=(name) @original_filename = name; end
        def io.original_filename() @original_filename; end

        io.original_filename = params['qqfile']

        @image_asset.storage = io
        if @image_asset.save!
          render json: { success: true }.to_json
        else
          render nothing: true, status: 500 and return
        end
      else
        create!
      end
    end

  end
end
