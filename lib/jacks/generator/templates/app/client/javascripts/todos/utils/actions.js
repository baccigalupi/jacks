// utils for static actions
const normalizePayload = (payload) => {
  if (payload === undefined || payload === null) {
    return {}
  }
  if (typeof payload === 'object' && !Array.isArray(payload)) {
    return payload
  }
  return {
    value: payload,
  }
}

export const createAction = (name) => {
  return (payload) => {
    return {
      type: name,
      payload: normalizePayload(payload),
    }
  }
}

export const createActions = (names) => {
  return names.reduce((collection, name) => {
    collection[name] = createAction(name)
    return collection
  }, {})
}

export const isMatch = (actionData, action) => {
  return actionData.type === action().type
}

export const noMatch = (actionData, action) => {
  return !isMatch(actionData, action)
}
