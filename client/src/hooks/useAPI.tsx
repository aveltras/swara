import { useCallback, useState } from "react";
import { ApiError, OpenAPI } from "../services/openapi";

export default function useAPI() {
  const [error, setError] = useState<ApiError | undefined>(undefined);
  const [isLoading, setIsLoading] = useState<boolean>(true);

  OpenAPI.BASE = "http://localhost:8000";
  const handleRequest = useCallback(async function <T>(request: Promise<T>) {
    setIsLoading(true);
    try {
      const response = await request;
      setError(undefined);
    } catch (error) {
      setError(error);
    } finally {
      setIsLoading(true);
    }
  }, []);

  function dismissError() {
    setError(undefined);
  }

  return { dismissError, error, isLoading, handleRequest };
}
