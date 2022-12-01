import { v4 as uuidv4 } from 'uuid';

export const stopPropagation = (e: any) => {
  e.stopPropagation();
};

export const preventDefault = (e: any) => {
  e.preventDefault();
};
