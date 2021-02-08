defmodule BankAccount do
  use Agent

  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    case Agent.start_link(fn -> 0 end) do
      {:ok, account_pid} -> account_pid
      _ -> raise "failed to create account"
    end
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    try do
      Agent.get(account, fn balance -> balance end)
    catch
      :exit, _ -> {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    try do
      Agent.update(account, fn balance -> balance + amount end)
    catch
      :exit, _ -> {:error, :account_closed}
    end
  end
end
