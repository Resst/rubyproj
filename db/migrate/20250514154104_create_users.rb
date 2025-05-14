class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table "users", force: :cascade do |t|
      t.string   "name"
      t.string   "email"
    end
  end
end
