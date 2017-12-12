class Exchange < ApplicationRecord
  include ExchangesHelper

  belongs_to :friend1, class_name: 'Friend', foreign_key: 'friend1_id'
  belongs_to :friend2, class_name: 'Friend', foreign_key: 'friend2_id'
  has_many :tag_relations, inverse_of: :exchange

  def friends
    [friend1, friend2]
  end

  def user_rated?(user)
    friend_rated? distinct_friends(self, user).second
  end

  def friend_rated?(friend)
    tag_relations.where(friend: friend).any?
  end

  # VALIDATION

  validates :friend1_id, presence: true
  validates :friend2_id, presence: true

  validate :check_different
  validate :check_owner
  validate :check_available, on: :create
  validate :check_unavailable, on: :update
  validate :check_tags_count, on: :update

  accepts_nested_attributes_for :tag_relations

  def check_different
    errors.add(:base, "Impossible d'échanger un ami contre lui même") unless friend1.id != friend2.id
  end

  def check_available
    errors.add(:base, "Un des amis n'est pas disponible") unless friend1.available? && friend2.available?
  end

  def check_unavailable
    errors.add(:base, "L'échange est déjà terminé") if is_active
  end

  def check_owner
    errors.add(:base, "Impossible d'échanger deux amis du même utilisateur") unless friend1.user.id != friend2.user.id
  end

  def check_tags_count
    # Using length as they are not saved in database yet
    # length - count = how many tags in total - how many in database = how many are added
    l = tag_relations.length - tag_relations.count
    errors.add(:tags, ': choisis entre 2 et 5 tags') if l != 0 && (l < Tag::MIN_ASSOC || l > Tag::MAX_ASSOC)
  end
end
