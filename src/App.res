type todo = {
  title: string,
  isDone: bool,
}

type state = {
  todoList: array<todo>,
  inputValue: string,
}

let initialState: state = {
  todoList: [],
  inputValue: "",
}

type actions = AddTodo | ClearTodos | InputChanged(string) | MarkDone(int)

let reducer = (state, action) => {
  switch action {
  | AddTodo => {
      inputValue: "",
      todoList: state.todoList->Js.Array2.concat([
        {
          title: state.inputValue,
          isDone: false,
        },
      ]),
    }
  | ClearTodos => {
      ...state,
      todoList: [],
    }
  | InputChanged(newValue) => {
      ...state,
      inputValue: newValue,
    }
  | MarkDone(index) => {
      ...state,
      todoList: state.todoList->Belt.Array.mapWithIndex((i, todo) => {
        switch i {
        | i if i == index => {...todo, isDone: !todo.isDone}
        | _ => todo
        }
      }),
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  let handleInput = e => {
    let newValue = ReactEvent.Form.target(e)["value"]
    newValue->InputChanged->dispatch
  }

  <div className="App">
    <h1> {"Todo Items"->React.string} </h1>
    <input
      className="mt-1 p-2 border border-gray-300 rounded-md focus:outline-none focus:ring focus:ring-indigo-200"
      value={state.inputValue}
      type_="text"
      onChange={handleInput}
    />
    <button
      onClick={_ => AddTodo->dispatch}
      className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
      {"ADD"->React.string}
    </button>
    <button
      onClick={_ => ClearTodos->dispatch}
      className="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
      {"CLEAR"->React.string}
    </button>
    <div className="flex flex-col mt-2">
      {state.todoList
      ->Belt.Array.mapWithIndex((i, todo) => {
        <p
          onClick={_ => i->MarkDone->dispatch}
          key={todo.title}
          className={"text-lg bg-" ++ {todo.isDone ? "green" : "blue"} ++ "-400 text-white p-4 m-2"}>
          {todo.title->React.string}
        </p>
      })
      ->React.array}
    </div>
  </div>
}
