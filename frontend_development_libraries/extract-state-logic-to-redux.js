// Define ADD, addMessage(), messageReducer(), and store here:
const ADD = 'ADD'

let addMessage = message => {
  return {
    type: ADD,
    message
  }
}

let messageReducer = (state = [], action) => {
  switch(action.type) {
    case ADD:
      return [...state, action.message]
    default:
      return state
  }
}

const store = Redux.createStore(messageReducer)