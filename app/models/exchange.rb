class Exchange < ApplicationRecord
  belongs_to :friend1, class_name: 'Friend', foreign_key: 'friend1_id'
  belongs_to :friend2, class_name: 'Friend', foreign_key: 'friend2_id'
  has_many :tag_relations

  def friends
    [friend1, friend2]
  end

  # VALIDATION

  validates :friend1_id, presence: true
  validates :friend2_id, presence: true

  validate :check_different
  validate :check_availables
  validate :check_owner

  def check_different
    errors.add(:base, "Impossible d'échanger un ami contre lui même") unless friend1.id != friend2.id
  end

  def check_availables
    errors.add(:base, "Un des amis n'est pas disponible") unless friend1.available? and friend2.available?
  end

  def check_owner
    errors.add(:base, "Impossible d'échanger deux amis du même utilisateur") unless friend1.user.id != friend2.user.id
  end
end
