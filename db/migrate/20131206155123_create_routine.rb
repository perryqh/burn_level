class CreateRoutine < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :role
      t.string :api_token
      t.index [:provider, :uid]
      t.index :api_token
      t.timestamps
    end

    create_table :preferences do |t|
      t.references :user
      t.string :mass_units
      t.string :distance_units
      t.index :user_id
      t.timestamps
    end

    create_table :routines do |t|
      t.string :slug
      t.references :user
      t.string :name
      t.index :slug, unique: true
      t.index :user_id
      t.timestamps
    end

    create_table :exercises do |t|
      t.string :slug
      t.references :routine
      t.string :name
      t.string :exercise_type
      t.integer :order_num
      t.index :routine_id
      t.index :slug, unique: true
      t.timestamps
    end

    create_table :routine_logs do |t|
      t.references :routine
      t.index :routine_id
      t.timestamps
    end

    create_table :exercise_logs do |t|
      t.references :exercise
      t.references :routine_log
      t.integer :rep_count
      t.decimal :mass
      t.string :mass_units
      t.decimal :distance
      t.string :distance_units
      t.string :duration
      t.index :exercise_id
      t.index :routine_log_id
      t.timestamps
    end
  end
end
