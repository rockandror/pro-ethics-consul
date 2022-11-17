require_dependency Rails.root.join("app", "models", "abilities", "everyone").to_s

class Abilities::Everyone
  alias_method :consul_initialize, :initialize

  def initialize(user)
    consul_initialize(user)

    if user&.guest?
      can :answer, Poll do |poll|
        !poll.expired?
      end

      can :create, Comment
      can :vote, Comment
    end
  end
end
