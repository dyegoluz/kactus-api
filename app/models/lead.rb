class Lead
  include Nerdify::Model
  orm :mongoid

  filters :leads, label: false do
    add :search, type: :search, size: 9
    add :page, type: :select, collection: "/admin/pages", size: 3
  end

  list :leads, type: :table do
  end
end