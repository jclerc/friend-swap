class Exchange < ApplicationRecord
  include ExchangesHelper

  belongs_to :friend_initier, class_name: 'Friend', foreign_key: 'friend_initier_id'
  belongs_to :friend_receiver, class_name: 'Friend', foreign_key: 'friend_receiver_id'
  has_many :tag_relations, inverse_of: :exchange

  scope :latest, -> { order updated_at: :desc }
  scope :active, ->(active = true) { where is_active: active }
  scope :of_friend, (lambda do |friend|
    where(friend_initier_id: friend)
      .or(Exchange.where(friend_receiver_id: friend))
  end)

  def friends
    [friend_initier, friend_receiver]
  end

  def user_rated?(user)
    friend_rated? distinct_friends(self, user).second
  end

  def friend_rated?(friend)
    tag_relations.where(friend: friend).any?
  end

  # AUTO-UPDATE FIELDS

  before_create :set_start_date
  before_save :set_end_date

  # VALIDATION

  validates :friend_initier_id, presence: true
  validates :friend_receiver_id, presence: true

  validate :check_different
  validate :check_owner
  validate :check_available, on: :create
  validate :check_unavailable, on: :update
  validate :check_tags_count, on: :update

  accepts_nested_attributes_for :tag_relations

  # PRIVATE METHODS

  private

  def set_start_date
    self.start_date = Time.now unless start_date
  end

  def set_end_date
    self.end_date = Time.now unless is_active? || end_date
  end

  def check_different
    errors.add(:base, "Impossible d'échanger un ami contre lui même") unless friend_initier.id != friend_receiver.id
  end

  def check_available
    errors.add(:base, "Un des amis n'est pas disponible") unless friend_initier.available? && friend_receiver.available?
  end

  def check_unavailable
    errors.add(:base, "L'échange est déjà terminé") if is_active
  end

  def check_owner
    errors.add(:base, "Impossible d'échanger deux amis du même utilisateur") unless friend_initier.user.id != friend_receiver.user.id
  end

  def check_tags_count
    # Using length as they are not saved in database yet
    # length - count = how many tags in total - how many in database = how many are added
    l = tag_relations.length - tag_relations.count
    errors.add(:tags, ': choisis entre 2 et 5 tags') if l != 0 && (l < Tag::MIN_ASSOC || l > Tag::MAX_ASSOC)
  end
end
