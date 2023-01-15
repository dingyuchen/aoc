module ChallengeInput
  extend self

  def get_string(day)
    yield File.read("#{day}/input.in")
  end
end
