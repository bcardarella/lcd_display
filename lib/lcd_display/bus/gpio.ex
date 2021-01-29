defmodule LcdDisplay.GPIO.Behaviour do
  @moduledoc """
  Defines a behaviour required for GPIO abstraction.
  """

  @type pin_number :: Circuits.GPIO.pin_number()
  @type pin_direction :: Circuits.GPIO.pin_direction()
  @type value :: Circuits.GPIO.value()

  @callback open(pin_number, pin_direction) :: {:ok, reference} | {:error, any}
  @callback write(reference, value) :: :ok | {:error, any}
end

defmodule LcdDisplay.GPIO do
  @moduledoc """
  Lets you control GPIOs.
  A thin wrapper of [elixir-circuits/circuits_gpio](https://github.com/elixir-circuits/circuits_gpio).
  """

  @behaviour LcdDisplay.GPIO.Behaviour

  def open(pin_number, :output), do: gpio_module().open(pin_number, :output)

  def write(gpio_ref, 0), do: gpio_module().write(gpio_ref, 0)
  def write(gpio_ref, 1), do: gpio_module().write(gpio_ref, 1)

  defp gpio_module() do
    # https://hexdocs.pm/elixir/master/library-guidelines.html#avoid-compile-time-application-configuration
    Application.get_env(:lcd_display, :gpio_module, Circuits.GPIO)
  end
end

defmodule LcdDisplay.GPIO.Stub do
  @moduledoc false

  @behaviour LcdDisplay.GPIO.Behaviour

  def open(_pin_number, :output), do: {:ok, Kernel.make_ref()}

  def write(_reference, 0), do: :ok
  def write(_reference, 1), do: :ok
end
