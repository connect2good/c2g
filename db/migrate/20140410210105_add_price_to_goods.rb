class AddPriceToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :price, :float
  end
end
