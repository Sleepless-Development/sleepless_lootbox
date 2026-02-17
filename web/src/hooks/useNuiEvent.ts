import { useEffect, useRef } from 'react';

interface NuiMessageData<T = unknown> {
  action: string;
  data: T;
}

type NuiHandler<T> = (data: T) => void;

export function useNuiEvent<T = unknown>(action: string, handler: NuiHandler<T>) {
  const savedHandler = useRef<NuiHandler<T>>(handler);

  useEffect(() => {
    savedHandler.current = handler;
  }, [handler]);

  useEffect(() => {
    const eventListener = (event: MessageEvent<NuiMessageData<T>>) => {
      const { action: eventAction, data } = event.data;

      if (eventAction === action) {
        savedHandler.current(data);
      }
    };

    window.addEventListener('message', eventListener);

    return () => {
      window.removeEventListener('message', eventListener);
    };
  }, [action]);
}

export default useNuiEvent;
