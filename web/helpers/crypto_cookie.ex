defmodule Scrumex.Helper.CryptoCookie do
  import Plug.Conn

  require Logger

  def put_encrypted_cookie(conn, key, value, opts \\ []) do
    opts = Keyword.put_new(opts, :max_age, 31_536_000) # one year

    conn
    |> put_resp_cookie(key, Cipher.cipher(value), opts)
  end

  def get_encrypted_cookie(conn, key) do
    case conn.cookies[key] do
      nil ->
        nil
      encrypted ->
        case Cipher.parse(encrypted) do
          {:ok, decrypted} -> decrypted
          {:error, msg} ->
            Logger.warn msg
            nil
          _ -> nil
        end
    end
  end
end
