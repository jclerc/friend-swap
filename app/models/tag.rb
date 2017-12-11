class Tag < ApplicationRecord
  MIN_ASSOC = 2
  MAX_ASSOC = 5

  has_many :tag_relations
  has_many :friends, through: :tag_relations

  def label test
    return test.is_male ? label_male : label_female if test.is_a? Friend
    test ? label_male : label_female
  end

  def friends_grouped
    groups = Hash.new(0)
    friends.each do |friend|
      groups[friend] += 1
    end
    groups
  end

  def friends_sorted(asc = false)
    friends_grouped.sort_by { |_, v| v }.tap { |o| o.reverse! unless asc }
  end
end
