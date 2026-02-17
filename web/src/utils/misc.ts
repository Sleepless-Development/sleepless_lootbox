export const isEnvBrowser = (): boolean => {
  return !(window as any).invokeNative;
};

export const noop = () => {};

export const clamp = (value: number, min: number, max: number): number => {
  return Math.min(Math.max(value, min), max);
};

export const formatNumber = (num: number): string => {
  return num.toLocaleString();
};

export const formatChance = (chance: number): string => {
  if (chance >= 1) {
    return `${chance.toFixed(1)}%`;
  } else if (chance >= 0.1) {
    return `${chance.toFixed(2)}%`;
  } else {
    return `${chance.toFixed(3)}%`;
  }
};

export const sleep = (ms: number): Promise<void> => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};
