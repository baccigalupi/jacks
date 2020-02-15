import { noMatch } from '../actions'

const unwrapInitialState = (initialState) => {
  if (typeof initialState === 'function') {
    return initialState()
  }
  return initialState
}

export const create = (action, fn, initialState) => {
  return (state = unwrapInitialState(initialState), actionData) => {
    if (noMatch(actionData, action)) {
      return state
    }

    return fn(state, actionData)
  }
}

export const compose = (initialState, reducers) => {
  return (state = unwrapInitialState(initialState), actionData) => {
    return reducers.reduce((latestState, reducer) => {
      return reducer(latestState, actionData)
    }, state)
  }
}