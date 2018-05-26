class AddIsVerifiedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_verified, :boolean, :null =>false, :default => false #null 값을 허용 x rmflrh default값이 false
    #users 테이블에 is_verified 컬럼 추가 . 데이터형식 (boolean , null은 false ,defualt 값은 false )
  end
end
