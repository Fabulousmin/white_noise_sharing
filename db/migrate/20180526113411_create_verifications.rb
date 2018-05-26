class CreateVerifications < ActiveRecord::Migration[5.0]
  def change
    create_table :verifications do |t|
      t.references :user, foreign_key: true #어떤 유저의 인증인
      t.boolean :is_verified     #인증 되었는지.
      t.boolean :is_active       #인증 코드가 활성화상태인지 만료되었는지
      t.string :code             #인증코드 담길 속성 

      t.timestamps
    end
  end
end
