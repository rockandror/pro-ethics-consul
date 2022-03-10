require_dependency Rails.root.join("app", "models", "abilities", "everyone").to_s

class Abilities::Everyone
  alias_method :consul_initialize, :initialize

  def initialize(user)
    consul_initialize(user)

    if user&.guest?
      can :answer, Poll
      can :answer, Poll::Question
    end
  end
end
