


class Captain < ActiveRecord::Base

    has_many :boats
    has_many :classifications, through: :boats

    def self.using_boat_class(class_name)
        Captain.joins(:classifications).where(classifications: {name: class_name}).distinct
    end

    def self.catamaran_operators
        Captain.using_boat_class("Catamaran")
        ###====OR====###
        # includes(boats: :classifications).where(classifications: {name: 'Catamaran'})
    end


    def self.sailors
        Captain.using_boat_class("Sailboat")
        ###====OR====###
        # includes(boats: :classifications).where(classifications: {name: 'Sailboat'}).uniq
    end

    def self.motor_operators
        Captain.using_boat_class("Motorboat")
        ###====OR====###
        # includes(boats: :classifications).where(classifications: {name: 'Motorboat'})
    end


    def self.talented_seafarers
        Captain.where(id: sailors.pluck(:id) & motor_operators.pluck(:id))
    end


    def self.non_sailors
        Captain.where.not(id: sailors.pluck(:id))
    end
end
