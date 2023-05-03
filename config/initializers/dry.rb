module Types
  include Dry::Types()

  ForceInteger = Types::Integer.constructor do |val|
    val&.to_i
  end
end
