const INCREMENT = 'INCREMENT';
const DECREMENT = 'DECREMENT';

// reducer
const counterReducer = (state = 0, action) => {
  switch (action.type) {
    case INCREMENT:
      return state + 1;
    case DECREMENT:
      return state - 1;
    default:
      return state;
  }
};

// create action (increment)
const incAction = () => {
  return {
    type: INCREMENT
  }
};

// create action (decrement)
const decAction = () => {
  return {
    type: DECREMENT
  }
};

// create store
const store = Redux.createStore(counterReducer);