import React, { useEffect, useState } from "react";
import logo from "./logo.svg";
import "./App.css";
import useAPI from "./hooks/useAPI";
import useInstrument from "./hooks/useSound";
import { Service } from "./services/openapi";

function App() {
  const [count, setCount] = useState(0);
  const { handleRequest } = useAPI();
  const { test } = Service;

  const { play } = useInstrument();

  useEffect(async () => {
    try {
      const num: int = await test(5);
      setCount(num);
    } catch (error) {
      throw new Error(error);
    }
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>Hello Vite + React!</p>
        <p>
          <button onClick={() => play()}>play</button>
          <button onClick={() => setCount((count) => count + 1)}>
            count is: {count}
          </button>
        </p>
        <p>
          Edit <code>App.tsx</code> and save to test HMR updates.
        </p>
        <p>
          <a
            className="App-link"
            href="https://reactjs.org"
            target="_blank"
            rel="noopener noreferrer"
          >
            Learn React
          </a>
          {" | "}
          <a
            className="App-link"
            href="https://vitejs.dev/guide/features.html"
            target="_blank"
            rel="noopener noreferrer"
          >
            Vite Docs
          </a>
        </p>
      </header>
    </div>
  );
}

export default App;
