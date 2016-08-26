require_relative 'data_magic.rb'

class Player < SQLObject
 belongs_to :team
 has_one_through(
  :owner, :team, :owner
 )
 self.finalize!
end

class Team < SQLObject
  has_many :players
  belongs_to :owner
  self.finalize!
end

class Owner < SQLObject
  has_many(
    :teams,
    class_name: 'Team',
    foreign_key: :owner_id,
    primary_key: :id
  )
  self.finalize!
end
