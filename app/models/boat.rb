

# class CreateBoats < ActiveRecord::Migration
#     def change
#         create_table :boats do |t|
#             t.string  :name
#             t.integer :length
#             t.integer :captain_id
#
#             t.timestamps null: false
#         end
#     end
# end

class Boat < ActiveRecord::Base

    belongs_to  :captain
    has_many    :boat_classifications
    has_many    :classifications, through: :boat_classifications

    def self.first_five
        limit(5)
    end

    def self.dinghy
        # All of these work

        # self.where(self.arel_table[:length].lt(20))
        # where(Boat.arel_table[:length].lt(20))
        Boat.where(Boat.arel_table[:length].lt(20))
    end

    def self.ship
        Boat.where(Boat.arel_table[:length].gt(20))
    end

    def self.last_three_alphabetically
        Boat.order(Boat.arel_table[:name].desc).limit(3)
    end

    def self.without_a_captain
        Boat.where(Boat.arel_table[:captain_id].eq(nil))
    end

    def self.sailboats
        Boat.joins(:classifications).where(classifications: {name: 'Sailboat'})
    end

    def self.with_three_classifications
        # comments.join(replies).on(replies[:parent_id].eq(comments[:id])).where(comments[:id].eq(1))
        # => SELECT * FROM comments INNER JOIN comments AS comments_2 WHERE comments_2.parent_id = comments.id AND comments.id = 1
        Boat.joins(:boat_classifications).group(:name).having('count(name)=3')
    end
end
