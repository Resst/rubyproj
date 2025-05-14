class CreateThemes < ActiveRecord::Migration[8.0]
  def change
    create_table "themes", force: :cascade do |t|
      t.string   "name"
      t.integer  "qty_items"
    end
  end
end
