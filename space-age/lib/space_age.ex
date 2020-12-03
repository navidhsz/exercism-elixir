defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    t = 60 * 60 * 24 * 365.25

    cond do
      planet == :mercury -> seconds / (t * 0.2408467)
      planet == :venus -> seconds / (t * 0.61519726)
      planet == :earth -> seconds / t
      planet == :mars -> seconds / (t * 1.8808158)
      planet == :jupiter -> seconds / (t * 11.862615)
      planet == :saturn -> seconds / (t * 29.447498)
      planet == :uranus -> seconds / (t * 84.016846)
      planet == :neptune -> seconds / (t * 164.79132)
    end
  end
end
