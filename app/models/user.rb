class User < ApplicationRecord
  has_many :verifications #하나의 유저는 여러개의 verification 가짐 
end
