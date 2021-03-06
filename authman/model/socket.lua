local socket = {}

function socket.model(config)

  local model = {}

  model.SPACE_NAME = config.spaces.socket.name

  model.PRIMARY_INDEX = 'primary'
  model.USER_ID_INDEX = 'user'

  model.ID = 1
  model.USER_ID = 2
  model.CREATION_TS = 3

  function model.get_space()
    return box.space[model.SPACE_NAME]
  end

  function model.serialize(socket_tuple)
      return {
          id = socket_tuple[model.ID],
          user_id = socket_tuple[model.USER_ID],
          creation_ts = socket_tuple[model.CREATION_TS],
      }
  end

  function model.create(socket_id, user_id, creation_ts)
    return model.get_space():put{
      socket_id,
      user_id,
      creation_ts or os.time(),
    }
  end

  function model.get_by_id(socket_id)
      return model.get_space():get(socket_id)
  end

  function model.get_by_user_id(user_id)
      return model.get_space().index[model.USER_ID_INDEX]:select{user_id}
  end

  function model.delete(socket_id)
      local socket_tuple = model.get_space():delete(socket_id)
      return socket_tuple ~= nil
  end

  return model
end

return socket
