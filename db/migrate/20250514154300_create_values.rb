class CreateValues < ActiveRecord::Migration[8.0]
  def change
    create_table "values", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "image_id"
      t.integer  "value"
    end
  end
end
