import { CairoCustomEnum } from "starknet";

export enum MoveDirection {
  Up = 'Up',
  Down = 'Down',
  Left = 'Left',
  Right = 'Right',
}

export const directionToCairoCustomEnum = (direction: MoveDirection): CairoCustomEnum => {
  switch (direction) {
    case MoveDirection.Up:
      return new CairoCustomEnum({ Up: "()" });
    case MoveDirection.Down:
      return new CairoCustomEnum({ Down: "()" });
    case MoveDirection.Left:
      return new CairoCustomEnum({ Left: "()" });
    case MoveDirection.Right:
      return new CairoCustomEnum({ Right: "()" });
    default:
      return new CairoCustomEnum({ None: "()" });
  }
}
