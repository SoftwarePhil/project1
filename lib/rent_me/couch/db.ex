defmodule RentMe.Couch.Db do
    alias Couchdb.Connector.Writer
    alias Couchdb.Connector.Reader
    alias Couchdb.Connector

    #http://127.0.0.1:5984/_utils/index.html
    @couch_config %{protocol: "http", hostname: "localhost",database: "rent_me", port: 5984}
    @rent_me %{protocol: "http", hostname: "localhost",database: "rent_me_main", port: 5984}

    def init_db(name) do
        db = db_config(name)
        Couchdb.Connector.Storage.storage_up(db)
        {:ok, db}
    end

    def db_config(name) do
        %{@couch_config | database: "rent_me"<>name}
    end

    def init_rent_me do
        Couchdb.Connector.Storage.storage_up(@rent_me)
        write_document(@rent_me, Poison.encode!(%{"locations"=>[], "user_db"=>"rent_me_users"}))
        {:ok, db_config} = init_db(rent_me_users)
        {:ok, db_config}
    end

    def rent_me do
        @rent_me
    end


    @doc"""
    updates a the couch db docuement.
    Takes the old document, the field name, the new field,
    and a success message
    returns {:ok, new_document}
    """
    def update_document(db, old, field_name, new_field_data, success) do
            case Connector.update(db, %{old | field_name => new_field_data}) do
                {:ok, %{:headers => _h, :payload => _p}} -> {:ok, %{old | field_name => new_field_data}}
                {:error, _} -> {:error, "failed to update document (error doing #{success})"}
            end
    end

    def update_document_map(db, old, map, success) do
            case Connector.update(db, new = Map.merge(old, map)) do
                {:ok, %{:headers => _h, :payload => _p}} -> {:ok, new}
                {:error, _} -> {:error, "failed to update document (error doing #{success})"}
            end
    end


    @doc"""
    returns a document if found (not decoded from JSON)
    returns {:ok, document}
    """    
    def valid_document?(db, key, error) do
        case Reader.get(db, key) do
            {:ok, data}      -> {:found, data}
            {:error, _error} -> {:error, error}
        end
    end


    @doc"""
    returns a document if found decoded from JSON
    returns {:ok, document}
    """  
    def get_document(db, key, error) do
        case Reader.get(db, key) do
            {:ok, data} -> {:ok, Poison.decode!(data)}
            {:error, _} -> {:error, error}  
        end
    end

    def delete_document(db, key, error) do
            case get_document(db, key, error) do
                {:ok, document} -> 
                    Couchdb.Connector.destroy(db, key, document["_rev"])
                    {:ok, "document deleted"}
            _ -> {:error, error}
            end
    end

    def write_document(db, key, body) do
        json = Poison.encode!(%{"body"=>body})
        case Writer.create(db, json, key) do
            {:ok, _, _} -> {:ok, "document added"}
            {:error, _, _} -> {:error, "cound not add document"}
        end
    end
end