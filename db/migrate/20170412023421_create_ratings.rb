class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table(:ratings) do |t|
      t.column(:name, :string)
      t.column(:score, :int)
      t.column(:recipe_id, :int)

      t.timestamps()
    end
  end
end
