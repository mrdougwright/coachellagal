FactoryGirl.define do
  factory :user do
    first_name  'John'
    last_name   'Doe'
    sequence(:email)      { |n| "person#{n}@example.com" }
    password              'pasword1'
    password_confirmation "pasword1"
    after(:build) {|user| user.send(:initialize_state_machines, :dynamic => :force)}
  end

  factory :registered_user, :parent => :user do
    state    'registered'
    birth_date  Time.now.to_date
  end
  factory :registered_user_with_credit, :parent => :registered_user do
    state    'registered_with_credit'
  end

  factory :admin_user, :parent => :user do
    before(:create) do |u|
      u.roles = [Role.find_by_name(Role::ADMIN)]
    end
  end

  factory :super_admin_user, :parent => :user do
    #roles     {
    #  [Role.find_by_name(Role::SUPER_ADMIN)]
    #}
    before(:create) do |u|
      u.roles = [Role.find_by_name(Role::SUPER_ADMIN)]
    end
  end
end
