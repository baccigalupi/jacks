import { createActions } from '../utils/actions'

export default createActions([
  'createList',
  'updateList',
  'finishList',
  'deleteList',
  'toggleList',

  'createNewTodo',
  'updateTodo',
  'finishTodo',
  'deleteTodo'
])
