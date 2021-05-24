import React, { useEffect, useState } from "react";
import logo from "./logo.svg";
import "./App.css";
import useAPI from "./hooks/useAPI";
import useInstrument from "./hooks/useSound";
import { Service } from "./services/openapi";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";

function App() {
  const [count, setCount] = useState(0);
  const { handleRequest } = useAPI();
  const { test } = Service;

  const { play } = useInstrument();

  useEffect(async () => {
    try {
      const num: int = await test(8);
      setCount(num);
    } catch (error) {
      throw new Error(error);
    }
  }, []);

  return (
    <div className="App">
      <header>
        <p>Hello Vite + React!</p>
        <p>
          <button onClick={() => play()}>play</button>
          <button onClick={() => setCount((count) => count + 1)}>
            count is: {count}
          </button>
        </p>
      </header>
      <Router>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
              <Link to="/ragas">Ragas</Link>
            </li>
          </ul>
        </nav>
        <Switch>
          <Route path="/ragas">Ragas</Route>
          <Route exact path="/">
            Home
          </Route>
        </Switch>
      </Router>
    </div>
  );
}

export default App;
